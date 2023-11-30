//
//  NintendoAccount.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/20/23.
//

import Foundation
import AuthenticationServices
import OSLog
extension InkNet{
  
  
  class NintendoService:NSObject,ASWebAuthenticationPresentationContextProviding{
    let logger = Logger(.custom(InkNet.NintendoService.self))
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // 确保在主线程上返回UIWindow
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


    var sessionToken: String {UserDefaultsManager.string(forKey: .SessionToken) ?? ""}
    let clientId = "71b963c1b7b6d119"
    let timeoutInterval: TimeInterval = 30

    struct BulletTokenResponse:Decodable{
      let bulletToken:String?
    }

    struct AccountLoginResponse: Decodable {
      struct Result: Decodable {
        struct WebApiServerCredential: Decodable {
          let accessToken: String
        }
        struct User: Decodable {
          let id: Int64
        }
        let webApiServerCredential: WebApiServerCredential
        let user: User
      }
      let result: Result?
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

    func getWebServiceToken() async throws -> WebServiceTokenStruct {
      let tokens = try await getToken()
      let (accessToken, idToken) = tokens
      let userInfo = try await getUserInfo(accessToken: accessToken)
      let loginData = try await getAccountLogin(idToken: idToken, userInfo: userInfo)
      let (idToken2, coralUserId) = loginData
      let webAccessToken = try await getAccessToken(idToken2: idToken2, id: userInfo.id, coralUserId: coralUserId)

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


    private func getToken() async throws -> (accessToken: String, idToken: String) {
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

      request.addValue(SPLATNET_VERSION, forHTTPHeaderField: "X-Web-View-Ver")
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "BulletToken Invalid response from server"])
      }

      let decoder = JSONDecoder()
      let tokenResponse = try decoder.decode(BulletTokenResponse.self, from: data)
      if let accessToken = tokenResponse.bulletToken {
        return accessToken
      } else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "BulletToken Invalid data received"])
      }
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
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
      request.addValue("Android", forHTTPHeaderField: "X-znca-Platform")
      request.addValue(NSO_VERSION, forHTTPHeaderField: "X-znca-Version")

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

    private func getAccountLogin(idToken: String, userInfo: (birthday: String, language: String, country: String, id: String)) async throws -> (idToken2: String, coralUserId: String) {
      do {
        // 尝试第一个API调用
        let fResponse = try await callIminkFApi(step: 1, idToken: idToken, naId: userInfo.id, coralUserId: nil)
        return try await performAccountLogin(with: fResponse, idToken: idToken, userInfo: userInfo)
      } catch {
        // 如果第一个API调用失败，则尝试第二个API调用
        let fResponse = try await callNxapiZncaApi(step: 1, idToken: idToken, naId: userInfo.id, coralUserId: nil)
        return try await performAccountLogin(with: fResponse, idToken: idToken, userInfo: userInfo)
      }
    }

    private func performAccountLogin(with fResponse: IminkResponse, idToken: String, userInfo: (birthday: String, language: String, country: String, id: String)) async throws -> (idToken2: String, coralUserId: String) {
      let url = URL(string: "https://api-lp1.znc.srv.nintendo.net/v3/Account/Login")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue("com.nintendo.znca/\(NSO_VERSION)(Android/11)", forHTTPHeaderField: "User-Agent")
      request.addValue("Android", forHTTPHeaderField: "X-Platform")
      request.addValue(NSO_VERSION, forHTTPHeaderField: "X-ProductVersion")

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
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "performAccountLogin Invalid response from server"])
      }

      let decoder = JSONDecoder()
      let loginResponse = try decoder.decode(AccountLoginResponse.self, from: data)
      if let idToken2 = loginResponse.result?.webApiServerCredential.accessToken,
         let coralUserId = loginResponse.result?.user.id {
        return (idToken2: idToken2, coralUserId: String(coralUserId))
      } else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "performAccountLogin Invalid data received"])
      }
    }

    private func getAccessToken(idToken2: String, id: String, coralUserId: String) async throws -> String {
      do {
        // 尝试第一个API调用
        let fResponse = try await callIminkFApi(step: 2, idToken: idToken2, naId: id, coralUserId: coralUserId)
        return try await self.performGetWebServiceToken(idToken2: idToken2, id: id, coralUserId: coralUserId, fResponse: fResponse)
      } catch {
        // 如果第一个API调用失败，则尝试第二个API调用
        let fResponse = try await callNxapiZncaApi(step: 2, idToken: idToken2, naId: id, coralUserId: coralUserId)
        return try await self.performGetWebServiceToken(idToken2: idToken2, id: id, coralUserId: coralUserId, fResponse: fResponse)
      }
    }

    private func performGetWebServiceToken(idToken2: String, id: String, coralUserId: String, fResponse: IminkResponse) async throws -> String {
      let url = URL(string: "https://api-lp1.znc.srv.nintendo.net/v2/Game/GetWebServiceToken")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.addValue("com.nintendo.znca/\(NSO_VERSION)(Android/11)", forHTTPHeaderField: "User-Agent")
      request.addValue("Bearer \(idToken2)", forHTTPHeaderField: "Authorization")
      request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
      request.addValue("Android", forHTTPHeaderField: "X-Platform")
      request.addValue(NSO_VERSION, forHTTPHeaderField: "X-ProductVersion")

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


        // 这里假设'presentLoginSession'是一个异步函数，用于展示登录界面并返回用户的回调URL
        let callbackURL = try await presentLoginSession(url: loginURL)

        // 从回调URL中获取session token
        guard let callbackURL = callbackURL,let sessionToken = try await getSessionToken(from: callbackURL, cv: cv) else {
          print("Failed to get session token")
          return
        }

        // 存储session token
        UserDefaultsManager.set(value: sessionToken, forKey: .SessionToken)

        try await self.updateTokens()

      } catch {
        print("Error during login process: \(error)")
      }
    }
    
    func updateTokens() async throws{
      do{
        try await self.updateWebServiceToken()
        _ = await self.updateBulletToken()
      }catch let error as NSError{
        logger.error("update token failed due to: \(error)")
        throw error
      }
    }
    
    func updateWebServiceToken() async throws{
      do{
        let webServiceToken = try await getWebServiceToken()
        UserDefaultsManager.set(object: webServiceToken, forKey: .WebServiceToken)
      }catch{
        logger.error("update WebServiceToken failed due to: \(error)")
        throw error
      }
    }

    func updateBulletToken(language: String? = "zh_CN") async ->Bool{
      do{
        let webServiceToken:WebServiceTokenStruct? = UserDefaultsManager.object(forKey: .WebServiceToken)
        if let webServiceToken = webServiceToken{
          let bulletToken = try await getBulletToken(webServiceToken: webServiceToken)
          UserDefaultsManager.set(value: bulletToken, forKey: .BulletToken)
          UserDefaultsManager.set(value: Date(), forKey: .LastRefreshTime)
          return true
        }
      }catch{
        logger.error("update bullet token failed due to: \(error)")

        return false
      }
      return false
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


  }
}


