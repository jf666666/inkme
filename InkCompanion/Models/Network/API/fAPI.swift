//
//  fAPI.swift
//  hailuowan
//
//  Created by 姜锋 on 10/31/23.
//

import Foundation

let USER_AGENT = "ConchBay/1.10.0"
let NSO_VERSION = "2.7.1"
let SPLATNET_VERSION = "6.0.0-e135295b"
let AXIOS_TOKEN_TIMEOUT: TimeInterval = 30 // Replace with your actual timeout

struct IminkResponse: Decodable {
    let f: String
    let request_id: String
    let timestamp: Int64
}

func callIminkFApi(step: Int, idToken: String, naId: String, coralUserId: String? = nil, completion: @escaping (Result<IminkResponse, Error>) -> Void) {
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

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
        print("iminkapi json序列化失败")
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
            let iminkResponse = try decoder.decode(IminkResponse.self, from: data)
            completion(.success(iminkResponse))
        } catch {
            print("imninkapi http请求失败")
            completion(.failure(error))
        }
    }
    task.resume()
}

func callNxapiZncaApi(step: Int, idToken: String, naId: String, coralUserId: String? = nil, completion: @escaping (Result<IminkResponse, Error>) -> Void) {
    let url = URL(string: "https://nxapi-znca-api.fancy.org.uk/api/znca/f")!
    var request = URLRequest(url: url)
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

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
        print("NxapiZncaApi json序列化失败")
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
            let zncaResponse = try decoder.decode(IminkResponse.self, from: data)
            completion(.success(zncaResponse))
        } catch {
            print("NxapiZncaApi http请求失败")
            completion(.failure(error))
        }
    }
    task.resume()
}
