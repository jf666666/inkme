//
//  RequestID.swift
//  hailuowan
//
//  Created by 姜锋 on 10/31/23.
//

import Foundation


func FetchGraphQl<T: Codable>(
    webServiceToken: WebServiceTokenStruct,
    bulletToken: String,
    language: String? = httpAcceptLanguageFormat(),
    hash: RequestId,
    variables: String?,
    completion: @escaping (Result<T, Error>) -> Void
) {
    // 构建请求体
    let body: [String: Any] = [
        "extensions": [
            "persistedQuery": [
                "sha256Hash": hash.rawValue,
                "version": 1
            ]
        ],
        "variables": variables ?? ""
    ]
    
    // 将请求体转换为 JSON 数据
    guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request body"])))
        return
    }
    
    // 创建请求
    var request = URLRequest(url: URL(string: "https://api.lp1.av5ja.srv.nintendo.net/api/graphql")!)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
    request.addValue(language ?? "", forHTTPHeaderField: "Accept-Language")
    request.addValue("Bearer \(bulletToken)", forHTTPHeaderField: "Authorization")
    request.addValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("_gtoken=\(webServiceToken.accessToken); _dnt=1", forHTTPHeaderField: "Cookie")
    request.addValue("https://api.lp1.av5ja.srv.nintendo.net", forHTTPHeaderField: "Origin")
    request.addValue("https://api.lp1.av5ja.srv.nintendo.net/?lang=\(language ?? "")&na_country=\(webServiceToken.country)&na_lang=\(webServiceToken.language)", forHTTPHeaderField: "Referer")
    request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
    request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
    request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
    request.addValue("Mozilla/5.0 (Linux; Android 11; sdk_gphone_arm64 Build/RSR1.210722.013.A6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.114 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
    request.addValue("com.nintendo.znca", forHTTPHeaderField: "X-Requested-With")
    request.addValue(SPLATNET_VERSION, forHTTPHeaderField: "X-Web-View-Ver")
    
    
    // 发送请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
}


func fetchFestival(completion: @escaping (Result<FestRecordResult_splatoon3ink, Error>)->Void){
    let url = URL(string: "https://splatoon3.ink/data/festivals.json")!
    var request = URLRequest(url: url)
    
    request.setValue(USER_AGENT, forHTTPHeaderField: "User-Agent")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let festivalsQuery = try decoder.decode(Festivals.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(festivalsQuery.US.data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } else if let error = error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}
