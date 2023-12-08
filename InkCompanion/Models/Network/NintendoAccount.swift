//
//  NintendoAccount.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/20/23.
//

import Foundation
import AuthenticationServices
import OSLog
import SPAlert

extension InkNet{
  static let nintendo = NintendoService()

  class NintendoService:NSObject,ASWebAuthenticationPresentationContextProviding{

    let logger = Logger(.custom(InkNet.NintendoService.self))

//    static let shared = NintendoService()
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if Thread.isMainThread {
            return ASPresentationAnchor()
        } else {
            var anchor: ASPresentationAnchor?
            DispatchQueue.main.sync {
                anchor = ASPresentationAnchor()
            }
            return anchor!
        }
    }

    var sessionToken: String {InkUserDefaults.shared.sessionToken ?? ""}
    let clientId = "71b963c1b7b6d119"
    let timeoutInterval: TimeInterval = 30

    struct AccountLoginResponse: Decodable {
      struct Result: Decodable {
        struct WebApiServerCredential: Decodable {
          let accessToken: String
        }
        struct links:Codable{
          struct friendCode:Codable{
            let id:String
          }
          let friendCode:friendCode
        }
        struct User: Decodable {
          let id: Int64 //unique
          let imageUri:String
          let supportId:String
          let nsaId:String
          let name:String //zifeng
          let links:links
        }
        let webApiServerCredential: WebApiServerCredential
        let user: User
      }
      let result: Result
    }

    struct WebServiceTokenResponse: Decodable {
      struct Result: Decodable {
        let accessToken: String
        let expiresIn: Int
      }
      let status: Int
      let result: Result?
      let correlationId: String
    }

    func getWebServiceStruct() async throws -> WebServiceTokenStruct {
      let (accessToken, idToken) = try await getAccessAndIdToken(sessionToken: InkUserDefaults.shared.sessionToken ?? "")
      let userInfo = try await getUserInfo(accessToken: accessToken)
      let accountLoginResponse = try await getAccountLoginResponse(idToken: idToken, userInfo: userInfo)
      let (webApiAccessToken, userId) = getWebApiAccessTokenAndUserId(loginResponse: accountLoginResponse)
      let webAccessToken = try await getWebServiceToken(webApiAccessToken: webApiAccessToken, userId: userInfo.id, coralUserId: userId)

      return WebServiceTokenStruct(accessToken: webAccessToken, country: userInfo.country, language: userInfo.language)
    }

    func getSessionToken(from url: URL, cv: String) async throws -> String? {
      let sessionTokenCode = getParam(from: url, param: "session_token_code")

      let bodyString = "client_id=71b963c1b7b6d119&session_token_code=\(sessionTokenCode ?? "")&session_token_code_verifier=\(cv)"
      guard let bodyData = bodyString.data(using: .utf8) else {
        return nil
      }

      var request = URLRequest(url: URL(string: "https://accounts.nintendo.com/connect/1.0.0/api/session_token")!)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
      request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
      request.addValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")
      request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.addValue("accounts.nintendo.com", forHTTPHeaderField: "Host")
      request.addValue("Dalvik/2.1.0 (Linux; U; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6)", forHTTPHeaderField: "User-Agent")

      request.httpBody = bodyData

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getSessionToken Invalid response from server"])
      }

      if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
         let sessionToken = json["session_token"] as? String {
        return sessionToken
      } else {
        return nil
      }
    }

    private func generateLogIn() -> (URL, String) {
      // 生成随机字节
      let random36Data = try? SecureRandomNumberGenerator.randomBytes(count: 36)
      let random32Data = try? SecureRandomNumberGenerator.randomBytes(count: 32)

      // 将随机字节转换为Base64编码的字符串
      let state = random36Data?.base64EncodedString().base64UrlEncoded()
      let cv = random32Data?.base64EncodedString().base64UrlEncoded()
      let cvHash = digestString(cv ?? "")

      // 使用SHA256生成code challenge
      let codeChallenge = cvHash?.base64UrlEncoded()

      // 构建登录URL
      var components = URLComponents(string: "https://accounts.nintendo.com/connect/1.0.0/authorize")!
      let queryItems = [
        URLQueryItem(name: "state", value: state),
        URLQueryItem(name: "redirect_uri", value: "npf71b963c1b7b6d119://auth"),
        URLQueryItem(name: "client_id", value: "71b963c1b7b6d119"),
        URLQueryItem(name: "scope", value: "openid user user.birthday user.mii user.screenName"),
        URLQueryItem(name: "response_type", value: "session_token_code"),
        URLQueryItem(name: "session_token_code_challenge", value: codeChallenge),
        URLQueryItem(name: "session_token_code_challenge_method", value: "S256"),
        URLQueryItem(name: "theme", value: "login_form")
      ]
      components.queryItems = queryItems

      let url = components.url

      return (url ?? URL(string: "www.baidu.com")!, cv ?? "")
    }

    private func getAccessAndIdToken(sessionToken:String) async throws -> (accessToken: String, idToken: String) {
      let url = URL(string: "https://accounts.nintendo.com/connect/1.0.0/api/token")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("accounts.nintendo.com", forHTTPHeaderField: "Host")
      request.addValue("Dalvik/2.1.0 (Linux; U; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6)", forHTTPHeaderField: "User-Agent")

      let body: [String: Any] = [
        "client_id": clientId,
        "session_token": sessionToken,
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer-session-token"
      ]

      let bodyData = try JSONSerialization.data(withJSONObject: body)
      request.httpBody = bodyData
      request.addValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")

      let (data, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getToken Invalid response from server"])
      }

      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
      guard let accessToken = json?["access_token"] as? String,
            let idToken = json?["id_token"] as? String else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getToken Invalid token response"])
      }

      return (accessToken, idToken)
    }

    private func getBulletToken(webServiceToken: WebServiceTokenStruct, language: String? = "zh_CN") async throws -> String {
      let url = URL(string: "https://api.lp1.av5ja.srv.nintendo.net/api/bullet_tokens")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("*/*", forHTTPHeaderField: "Accept")
      request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
      request.addValue(language!, forHTTPHeaderField: "Accept-Language")
      request.addValue("0", forHTTPHeaderField: "Content-Length")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("_gtoken=\(webServiceToken.accessToken); _dnt=1", forHTTPHeaderField: "Cookie")
      request.addValue("https://api.lp1.av5ja.srv.nintendo.net", forHTTPHeaderField: "Origin")
      request.addValue("https://api.lp1.av5ja.srv.nintendo.net/?lang=\(language!)&na_country=\(webServiceToken.country)&na_lang=\(webServiceToken.language)", forHTTPHeaderField: "Referer")
      request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
      request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
      request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
      request.addValue("Mozilla/5.0 (Linux; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
      request.addValue(webServiceToken.country, forHTTPHeaderField: "X-NACOUNTRY")
      request.addValue("com.nintendo.znca", forHTTPHeaderField: "X-Requested-With")

      request.addValue(InkUserDefaults.shared.SplatNetVersion, forHTTPHeaderField: "X-Web-View-Ver")
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "BulletToken Invalid response from server"])
      }

      guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let bulletToken = json["bulletToken"] as? String else {throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "BulletToken Invalid data received"])}
      return bulletToken

    }

    private func getUserInfo(accessToken: String) async throws -> (birthday: String, language: String, country: String, id: String) {
      let url = URL(string: "https://api.accounts.nintendo.com/2.0.0/users/me")!
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
      request.addValue("en-US", forHTTPHeaderField: "Accept-Language")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
      request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("api.accounts.nintendo.com", forHTTPHeaderField: "Host")
      request.addValue("NASDKAPI; Android", forHTTPHeaderField: "User-Agent")

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getUserInfo Invalid response from server"])
      }

      guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let birthday = json["birthday"] as? String,
            let language = json["language"] as? String,
            let country = json["country"] as? String,
            let id = json["id"] as? String else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getUserInfo Invalid user info response"])
      }

      return (birthday, language, country, id)
    }

    func callIminkFApi(step: Int, idToken: String, naId: String, coralUserId: String? = nil) async throws -> IminkResponse {
      let url = URL(string: "https://api.imink.app/f")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")

      var body: [String: Any] = [
        "hash_method": step,
        "token": idToken,
        "na_id": naId
      ]
      if let coralUserId = coralUserId {
        body["coral_user_id"] = coralUserId
      }

      request.httpBody = try JSONSerialization.data(withJSONObject: body)

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "callIminkFApi Invalid response from server"])
      }

      let decoder = JSONDecoder()
      let iminkResponse = try decoder.decode(IminkResponse.self, from: data)
      return iminkResponse
    }

    func callNxapiZncaApi(step: Int, idToken: String, naId: String, coralUserId: String? = nil) async throws -> IminkResponse {
      let url = URL(string: "https://nxapi-znca-api.fancy.org.uk/api/znca/f")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
      request.addValue("Android", forHTTPHeaderField: "X-znca-Platform")
      request.addValue(InkUserDefaults.shared.NSOVersion, forHTTPHeaderField: "X-znca-Version")

      var body: [String: Any] = [
        "hash_method": step,
        "token": idToken,
        "na_id": naId
      ]
      if let coralUserId = coralUserId {
        body["coral_user_id"] = coralUserId
      }

      request.httpBody = try JSONSerialization.data(withJSONObject: body)

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "callNxapiZncaApi Invalid response from server"])
      }

      let decoder = JSONDecoder()
      let zncaResponse = try decoder.decode(IminkResponse.self, from: data)
      return zncaResponse
    }


    private func fetchFResponse(step:Int,idToken: String, userInfo: (birthday: String, language: String, country: String, id: String)) async throws-> IminkResponse {
        do {
            let fResponse = try await callIminkFApi(step: step, idToken: idToken, naId: userInfo.id, coralUserId: nil)
            return fResponse
        } catch let iminkError as NSError{
          logger.error("call Imink API failed for: \(iminkError.localizedDescription)")
            do {
                let fResponse = try await callNxapiZncaApi(step: step, idToken: idToken, naId: userInfo.id, coralUserId: nil)
                return fResponse
            } catch let nxApiError as NSError{
              logger.error("call NxapiZnca API failed for: \(nxApiError.localizedDescription)")
              throw NSError(domain: "InkNet.\(#function)", code: nxApiError.code, userInfo: nxApiError.userInfo)
            }
        }
    }

    
    private func getAccountLoginData(idToken: String, userInfo: (birthday: String, language: String, country: String, id: String)) async throws ->Data{
      let fResponse = try await fetchFResponse(step:1, idToken: idToken, userInfo: userInfo)

      let url = URL(string: "https://api-lp1.znc.srv.nintendo.net/v3/Account/Login")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue("com.nintendo.znca/\(InkUserDefaults.shared.NSOVersion)(Android/11)", forHTTPHeaderField: "User-Agent")
      request.addValue("Android", forHTTPHeaderField: "X-Platform")
      request.addValue(InkUserDefaults.shared.NSOVersion, forHTTPHeaderField: "X-ProductVersion")

      let body: [String: Any] = [
        "parameter": [
          "f": fResponse.f,
          "language": userInfo.language,
          "naBirthday": userInfo.birthday,
          "naCountry": userInfo.country,
          "naIdToken": idToken,
          "requestId": fResponse.request_id,
          "timestamp": fResponse.timestamp
        ]
      ]

      request.httpBody = try JSONSerialization.data(withJSONObject: body)

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "getWebApiAccessTokenAndUserId Invalid response from server"])
      }
      return data
    }

    private func getAccountLoginResponse(idToken: String, userInfo: (birthday: String, language: String, country: String, id: String)) async throws ->AccountLoginResponse{
      do{
        let data = try await getAccountLoginData(idToken: idToken, userInfo: userInfo)
        let decoder = JSONDecoder()
        let loginResponse = try decoder.decode(AccountLoginResponse.self, from: data)
        return loginResponse
      }catch let error as NSError{
        throw error
      }
    }

    private func getWebApiAccessTokenAndUserId(loginResponse:AccountLoginResponse) -> (webApiAccessToken: String, userId: String) {
        let idToken2 = loginResponse.result.webApiServerCredential.accessToken
        let coralUserId = loginResponse.result.user.id
        return (webApiAccessToken: idToken2, userId: String(coralUserId))
    }

    private func getWebServiceToken(webApiAccessToken: String, userId:String, coralUserId: String) async throws -> String {
      let userInfo = ("","","",userId)
      let fResponse = try await fetchFResponse(step: 2, idToken: webApiAccessToken, userInfo: userInfo)
      let url = URL(string: "https://api-lp1.znc.srv.nintendo.net/v2/Game/GetWebServiceToken")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue("com.nintendo.znca/\(InkUserDefaults.shared.NSOVersion)(Android/11)", forHTTPHeaderField: "User-Agent")
      request.addValue("Bearer \(webApiAccessToken)", forHTTPHeaderField: "Authorization")
      request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
      request.addValue("Android", forHTTPHeaderField: "X-Platform")
      request.addValue(InkUserDefaults.shared.NSOVersion, forHTTPHeaderField: "X-ProductVersion")

      let body: [String: Any] = [
        "parameter": [
          "f": fResponse.f, // 这里应该是从之前的 API 调用中获取的 f 值
          "id": 4834290508791808,
          "registrationToken": "",
          "requestId": fResponse.request_id, // 这里应该是从之前的 API 调用中获取的 requestId 值
          "timestamp": fResponse.timestamp // 这里应该是从之前的 API 调用中获取的 timestamp 值
        ]
      ]

      request.httpBody = try JSONSerialization.data(withJSONObject: body)
      request.addValue(String(request.httpBody?.count ?? 0), forHTTPHeaderField: "Content-Length")

      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "performGetWebServiceToken Invalid response from server"])
      }

      let decoder = JSONDecoder()
      let tokenResponse = try decoder.decode(WebServiceTokenResponse.self, from: data)
      if let accessToken = tokenResponse.result?.accessToken {
        return accessToken
      } else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "performGetWebServiceToken Invalid data received"])
      }
    }

    func initiateLoginProcess() async {
      do {
        let (loginURL, cv) = generateLogIn()
        let callbackURL = try await presentLoginSession(url: loginURL)

        guard let callbackURL = callbackURL,let sessionToken = try await getSessionToken(from: callbackURL, cv: cv) else {
          print("Failed to get session token")
          return
        }

        InkUserDefaults.shared.sessionToken = sessionToken
        InkUserDefaults.shared.webServiceToken = nil

        _ = try await self.updateTokens()

      } catch {
        print("Error during login process: \(error)")
      }
    }

    func loginWithSessionToken(sessionToken:String) async ->(inkAccount:InkAccount, webServiceTokenStruct:WebServiceTokenStruct, bulletToken:String)?{
      do{
        let (accessToken, idToken) = try await getAccessAndIdToken(sessionToken: sessionToken)
        let userInfo = try await getUserInfo(accessToken: accessToken)
        let accountLoginResponse = try await getAccountLoginResponse(idToken: idToken, userInfo: userInfo)
        let (webApiAccessToken, userId) = getWebApiAccessTokenAndUserId(loginResponse: accountLoginResponse)
        let webAccessToken = try await getWebServiceToken(webApiAccessToken: webApiAccessToken, userId: userInfo.id, coralUserId: userId)


        let webServiceToken = WebServiceTokenStruct(accessToken: webAccessToken, country: userInfo.country, language: userInfo.language)
        let bulletToken = try await getBulletToken(webServiceToken: webServiceToken,language: InkUserDefaults.shared.currentLanguage)
        let inkAccount = accountLoginResponse.toInkAccount(sessionToken: sessionToken, web: webServiceToken, bullet: bulletToken)
        return (inkAccount, webServiceToken, bulletToken)
      }catch{
        logger.error("InkNet.NintendoAccount\(#function)")
        return nil
      }
    }

    func updateTokens() async throws ->(webServiceToken:WebServiceTokenStruct?, bulletToken:String?) {
      let bulletToken:String?
      let webServiceToken:WebServiceTokenStruct?
      do{
        if let w = InkUserDefaults.shared.webServiceToken?.decode(WebServiceTokenStruct.self){
          bulletToken = try await self.getBulletToken(webServiceToken: w)
          return (nil,bulletToken)
        }else{
          throw NSError(domain: "没有webServiceToken", code: 1  )
        }
      }catch{
        do{
          webServiceToken = try await self.getWebServiceStruct()
          bulletToken = try await self.getBulletToken(webServiceToken: webServiceToken!)
          return (webServiceToken,bulletToken)
        }catch{
          logger.error("update token failed due to: \(error)")
          throw error
        }
      }
    }



    func updateWebServiceToken() async throws{
      do{
        let webServiceToken = try await getWebServiceStruct()
        DispatchQueue.main.sync {
          InkUserDefaults.shared.webServiceToken = webServiceToken.encode()
        }

      }catch{
        logger.error("update WebServiceToken failed due to: \(error)")
        throw error
      }
    }

    func updateBulletToken(language: String? = InkUserDefaults.shared.currentLanguage) async throws{
      do{
        if let webServiceToken = InkUserDefaults.shared.webServiceToken?.decode(WebServiceTokenStruct.self){
          let bulletToken = try await getBulletToken(webServiceToken: webServiceToken,language: language)
          DispatchQueue.main.sync {
            InkUserDefaults.shared.bulletToken = bulletToken
          }
        }else{
          throw NSError(domain: "No WebServiceToken", code: 1, userInfo: nil)
        }
      }catch{
        logger.error("update bullet token failed due to: \(error)")
        throw error
      }

    }

    func presentLoginSession(url: URL) async throws -> URL? {
      return try await withCheckedThrowingContinuation { continuation in
        let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, error in
          if let error = error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(returning: callbackURL)
          }
        }
        authSession.presentationContextProvider = self
        authSession.start()
      }
    }

    func getUserKey() async ->String?{
      if let group = await InkNet.shared.fetchCoopHistories()?.historyGroups?.nodes, group.count > 0, let details = group[0].historyDetails?.nodes, details.count > 0, let userKey = details[0].id.base64Decoded().userKey{
        return userKey
      }
      if let group = await InkNet.shared.fetchBattleHistory(for: .Latest)?.historyGroups.nodes, !group.isEmpty, let details = group[0].historyDetails.nodes, !details.isEmpty, let userKey = details[0].id.base64Decoded().userKey{
        return userKey
      }
      return nil
    }
  }
}


extension InkNet.NintendoService.AccountLoginResponse{
  func toInkAccount(sessionToken:String,web:WebServiceTokenStruct,bullet:String)->InkAccount{
    return InkAccount(id: self.result.user.id,  avatarUrl: self.result.user.imageUri, name: self.result.user.name, lastRefreshTime: Date.now, friendCode: self.result.user.links.friendCode.id,sessionToken: sessionToken, bulletToken: bullet, webServiceToken: web)
  }
}
