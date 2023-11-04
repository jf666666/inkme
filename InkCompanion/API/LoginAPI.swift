//
//  LoginAPI.swift
//  hailuowan
//
//  Created by 姜锋 on 10/31/23.
//


import Foundation
import CryptoKit
import AuthenticationServices
import SwiftyJSON
import CoreData

extension String {
    func base64UrlEncoded() -> String {
        return self.replacingOccurrences(of: "+", with: "-")
                   .replacingOccurrences(of: "/", with: "_")
                   .replacingOccurrences(of: "=", with: "")
    }
}

enum CryptoAlgorithm {
    case sha256
    // 你可以根据需要添加更多的算法
}

func digestString(_ input: String, using algorithm: CryptoAlgorithm) -> String? {
    guard let inputData = input.data(using: .utf8) else { return nil }
    
    switch algorithm {
    case .sha256:
        let hashed = SHA256.hash(data: inputData)
        return Data(hashed).base64EncodedString()
    // 在这里你可以处理更多的算法
    }
}


func saveUniqueWebServiceToken(_ webServiceToken: WebServiceTokenStruct, in context: NSManagedObjectContext) {
    // 创建一个请求来获取所有的 WebServiceTokenEntity 实例
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WebServiceTokenEntity.fetchRequest()

    // 创建一个删除请求，使用上面的抓取请求
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        // 执行删除请求
        try context.execute(deleteRequest)

        // 创建新的 WebServiceTokenEntity 实例
        let newToken = WebServiceTokenEntity(context: context)
        newToken.accessToken = webServiceToken.accessToken
        newToken.country = webServiceToken.country
        newToken.language = webServiceToken.language
        // 保存上下文
        try context.save()
        print("Unique WebServiceTokenEntity saved successfully")
    } catch {
        print("Failed to save unique WebServiceTokenEntity: \(error.localizedDescription)")
    }
}


func isWebServiceTokenInCoreData(in context: NSManagedObjectContext)->Bool {
    let fetchRequest: NSFetchRequest<WebServiceTokenEntity> = WebServiceTokenEntity.fetchRequest()

    do {
        let results = try context.fetch(fetchRequest)
        if results.first != nil {
            return true
        } else {
            return false
        }
    } catch {
        return false
    }
}

func updateTokens(completion: @escaping (Bool) -> Void) {
    let context = PersistenceController.shared.container.viewContext
    
    NintendoService(sessionToken: UserDefaultsManager.string(forKey: Keys.SessionToken) ?? "").getWebServiceToken() { result in
        DispatchQueue.main.async { // 确保在主线程中更新UI
            switch result {
            case .success(let webServiceToken):
                print("WebServiceToken: \(webServiceToken)")
                
                NintendoService(sessionToken: UserDefaultsManager.string(forKey: Keys.SessionToken) ?? "").getBulletToken(webServiceToken: webServiceToken) { result in
                    DispatchQueue.main.async { // 再次确保在主线程中更新UI
                        switch result {
                        case .success(let bulletToken):
                            print("bulletToken: \(bulletToken)")
                            UserDefaultsManager.set(value: bulletToken, forKey: Keys.BulletToken)
                            UserDefaultsManager.set(value: Date(), forKey: Keys.LastRefreshTime)
                            completion(true) // 更新完成，调用completion闭包
                        case .failure(let error):
                            print("BulletToken Error: \(error.localizedDescription)")
                            completion(false) // 即使失败也应该调用completion，以便关闭Toast
                        }
                    }
                }
                
                saveUniqueWebServiceToken(webServiceToken, in: context)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false) // 即使失败也应该调用completion，以便关闭Toast
            }
        }
    }
}




func shouldUpdate()->Bool{
    let lastUpdate = UserDefaultsManager.date(forkey: Keys.LastRefreshTime)
    let currentTime = Date()
    let updateInterval = 1 * 60 * 60 // 1小时

    if currentTime.timeIntervalSince(lastUpdate) > TimeInterval(updateInterval) {
        return true
    }
    return false
}

func showUpdateAlert() {
    // 显示应用内提示，例如使用Toast或者Alert
}


func generateLogIn(completion: @escaping (URL?, String?) -> Void) {
    // 生成随机字节
    guard let random36Data = try? SecureRandomNumberGenerator.randomBytes(count: 36) else {
        completion(nil, nil)
        return
    }
    
    guard let random32Data = try? SecureRandomNumberGenerator.randomBytes(count: 32) else {
        completion(nil, nil)
        return
    }
    
    // 将随机字节转换为Base64编码的字符串
    let state = random36Data.base64EncodedString().base64UrlEncoded()
    let cv = random32Data.base64EncodedString().base64UrlEncoded()
    let cvHash = digestString(cv, using: .sha256)
    
//    // 使用SHA256生成code challenge
//    let codeVerifier = SHA256.hash(data: random32Data)
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
    
    guard let url = components.url else {
        completion(nil, nil)
        return
    }
    
    completion(url, cv)
}

// 用于生成随机字节的辅助函数
struct SecureRandomNumberGenerator {
    static func randomBytes(count: Int) throws -> Data {
        var randomBytes = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes)
        if status == errSecSuccess {
            return Data(randomBytes)
        } else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
    }
}

func openAuthSession(url: URL, callbackURLScheme: String, completionHandler: @escaping (URL?, Error?) -> Void) {
    let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { callbackURL, error in
        // 这里你可以处理认证后的回调URL或者错误
        completionHandler(callbackURL, error)
    }
    

    // 启动Web认证会话
    session.start()
}

func randomBytesBase64Encoded(count: Int) -> String {
    var randomBytes = [UInt8](repeating: 0, count: count)
    let _ = SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes)
    return Data(randomBytes).base64EncodedString()
}


func getParam(from url: URL, param: String) -> String? {
    // 将片段参数转换为查询参数的形式
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
    var combinedQuery = components.query ?? ""
    if let fragment = components.fragment {
        combinedQuery += "&" + fragment
    }
    
    // 解析查询参数
    guard let queryItems = URLComponents(string: "?" + combinedQuery)?.queryItems else { return nil }
    return queryItems.first(where: { $0.name == param })?.value
}


func getSessionToken(from url: URL, cv: String, completion: @escaping (String?) -> Void) {
    let sessionTokenCode = getParam(from: url, param: "session_token_code")

    

    let bodyString = "client_id=71b963c1b7b6d119&session_token_code=\(sessionTokenCode ?? "")&session_token_code_verifier=\(cv)"
    guard let bodyData = bodyString.data(using: .utf8) else {
            completion(nil)
            return
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

    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let sessionToken = json["session_token"] as? String {
            completion(sessionToken)
        } else {
            completion(nil)
        }
    }
    
    task.resume()
}

// 打印请求的详细信息的辅助函数
func printRequestDetails(_ request: URLRequest) {
    if let url = request.url {
        print("URL: \(url)")
    }
    if let method = request.httpMethod {
        print("Method: \(method)")
    }
    print("Headers: \(request.allHTTPHeaderFields ?? [:])")
    if let body = request.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
        print("Body: \(bodyString)")
    }
}


// 定义 WebServiceToken 结构体
struct WebServiceTokenStruct: Codable {
    let accessToken: String
    let country: String
    let language: String
}


extension WebServiceTokenEntity {
    func toWebServiceTokenStruct() -> WebServiceTokenStruct {
        return WebServiceTokenStruct(
            accessToken: self.accessToken ?? "",
            country: self.country ?? "",
            language: self.language ?? ""
        )
    }
}


class SessionTokenManager {
    private let sessionTokenKey = "sessionTokenKey"

    var sessionToken: String? {
        get {
            return UserDefaults.standard.string(forKey: sessionTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sessionTokenKey)
        }
    }

    func clearSessionToken() {
        UserDefaults.standard.removeObject(forKey: sessionTokenKey)
    }
}




struct NintendoService {
    
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
    
    struct BulletTokenResponse:Decodable{
        let bulletToken:String?
    }

    let sessionToken: String
    let clientId = "71b963c1b7b6d119"
    let timeoutInterval: TimeInterval = 30 // AXIOS_TOKEN_TIMEOUT equivalent
    
    // 定义函数以获取 Bullet Token
    func getBulletToken(webServiceToken: WebServiceTokenStruct, language: String? = httpAcceptLanguageFormat(), completion: @escaping (Result<String, Error>) -> Void) {

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

        // 发起请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(BulletTokenResponse.self, from: data)
                if let accessToken = tokenResponse.bulletToken {
                    completion(.success(accessToken))
                } else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data received"])
                }
            } catch {
                print("getBulletToken decode failed")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getWebServiceToken(completion: @escaping (Result<WebServiceTokenStruct, Error>) -> Void) {
        getToken { result in
            switch result {
            case .success(let tokens):
                let (accessToken, idToken) = tokens
                getUserInfo(accessToken: accessToken) { userInfoResult in
                    switch userInfoResult {
                    case .success(let userInfo):
                        getAccountLogin(idToken: idToken, userInfo: userInfo) { accountLoginResult in
                            switch accountLoginResult {
                            case .success(let loginData):
                                let (idToken2, coralUserId) = loginData
                                getWebServiceToken(idToken2: idToken2,id: userInfo.id, coralUserId: coralUserId) { webServiceTokenResult in
                                    switch webServiceTokenResult {
                                    case .success(let webServiceToken):
                                        completion(.success(WebServiceTokenStruct(accessToken: webServiceToken, country: userInfo.country, language: userInfo.language)))
                                    case .failure(let error):
                                        print("getWebServiceToken failed")
                                        completion(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                print("getAccountLogin failed")
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        print("getUserInfo failed")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("getToken failed")
                completion(.failure(error))
            }
        }
    }

    private func getToken(completion: @escaping (Result<(accessToken: String, idToken: String), Error>) -> Void) {
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

        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
            request.addValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    guard let accessToken = json?["access_token"] as? String,
                          let idToken = json?["id_token"] as? String else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token response"])
                    }
                    completion(.success((accessToken, idToken)))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    private func getUserInfo(accessToken: String, completion: @escaping (Result<(birthday: String, language: String, country: String, id: String), Error>) -> Void) {
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

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                guard let birthday = json?["birthday"] as? String,
                      let language = json?["language"] as? String,
                      let country = json?["country"] as? String,
                      let id = json?["id"] as? String else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user info response"])
                }
                completion(.success((birthday, language, country, id)))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func getAccountLogin(idToken: String, userInfo: (birthday: String, language: String, country: String, id: String), completion: @escaping (Result<(idToken2: String, coralUserId: String), Error>) -> Void) {
        callIminkFApi(step: 1, idToken: idToken, naId: userInfo.id, coralUserId: nil) { result in
            switch result {
            case .success(let fResponse):
                self.performAccountLogin(with: fResponse,idToken:idToken, userInfo: userInfo, completion: completion)
            case .failure:
                // If the first API call fails, try the second one
                callNxapiZncaApi(step: 1, idToken: idToken, naId: userInfo.id, coralUserId: nil) { result in
                    switch result {
                    case .success(let fResponse):
                        self.performAccountLogin(with: fResponse,idToken:idToken, userInfo: userInfo, completion: completion)
                    case .failure(let error):
                        // If the second API call also fails, handle the error
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    private func performAccountLogin(with fResponse: IminkResponse,idToken:String, userInfo: (birthday: String, language: String, country: String, id: String), completion: @escaping (Result<(idToken2: String, coralUserId: String), Error>) -> Void) {
        let url = URL(string: "https://api-lp1.znc.srv.nintendo.net/v3/Account/Login")!
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
               request.addValue("com.nintendo.znca/\(NSO_VERSION)(Android/11)", forHTTPHeaderField: "User-Agent")
               request.addValue("Android", forHTTPHeaderField: "X-Platform")
               request.addValue(NSO_VERSION, forHTTPHeaderField: "X-ProductVersion")

               let body: [String: Any] = [
                   "parameter": [
                       "f": fResponse.f, // 这里应该是从之前的 API 调用中获取的 f 值
                       "language": userInfo.language,
                       "naBirthday": userInfo.birthday,
                       "naCountry": userInfo.country,
                       "naIdToken": idToken,
                       "requestId": fResponse.request_id, // 这里应该是从之前的 API 调用中获取的 requestId 值
                       "timestamp": fResponse.timestamp // 这里应该是从之前的 API 调用中获取的 timestamp 值
                   ]
               ]
        do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("performAccountLogin JSONSerialization failed")
                completion(.failure(error))
                return
            }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("performAccountLogin URLSession failed")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                print("performAccountLogin http failed")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(AccountLoginResponse.self, from: data)
                if let idToken2 = loginResponse.result?.webApiServerCredential.accessToken,
                   let coralUserId = loginResponse.result?.user.id {
                    completion(.success((idToken2: idToken2, coralUserId: String(coralUserId))))
                } else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data received"])
                }
            } catch {
                print("performAccountLogin decode failed")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func getWebServiceToken(idToken2: String,id:String, coralUserId: String, completion: @escaping (Result<String, Error>) -> Void) {
        callIminkFApi(step: 2, idToken: idToken2, naId: id,coralUserId: coralUserId){ result in
            switch result{
            case .success(let fResponse):
                self.performGetWebServiceToken(idToken2: idToken2, id: id, coralUserId: coralUserId, fResponse: fResponse, completion: completion)
            case .failure:
                // If the first API call fails, try the second one
                callNxapiZncaApi(step: 2, idToken: idToken2, naId: id, coralUserId: coralUserId) { result in
                    switch result {
                    case .success(let fResponse):
                        self.performGetWebServiceToken(idToken2: idToken2, id: id, coralUserId: coralUserId, fResponse: fResponse, completion: completion)
                    case .failure(let error):
                        // If the second API call also fails, handle the error
                        completion(.failure(error))
                    }
                }
            }
            
        }
    }
    
    private func performGetWebServiceToken(idToken2: String,id:String, coralUserId: String,fResponse:IminkResponse, completion: @escaping (Result<String, Error>) -> Void){
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
               
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
            request.addValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(WebServiceTokenResponse.self, from: data)
                if let accessToken = tokenResponse.result?.accessToken {
                    completion(.success(accessToken))
                } else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data received"])
                }
            } catch {
                print("getWebServiceToken decode failed")
                completion(.failure(error))
            }
        }
        task.resume()
    }

}






func httpAcceptLanguageFormat() -> String? {
    if let languageCode = Locale.current.language.languageCode?.identifier, let regionCode = Locale.current.region?.identifier {
        return "\(languageCode)-\(regionCode)"
    } else if let languageCode = Locale.current.language.languageCode?.identifier {
        return languageCode
    }
    return nil
}
