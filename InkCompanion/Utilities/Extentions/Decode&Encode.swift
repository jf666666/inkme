//
//  Decode&Encode.swift
//  imink
//
//  Created by Jone Wang on 2020/9/17.
//

import Foundation
import os

extension String {
    
    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        guard let object = data.decode(type) else {
            return nil
        }
        
        return object
    }
    
}

extension Data {

    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try decoder.decode(type.self, from: self)
        } catch {
            if let jsonString = String(data: self, encoding: .utf8) {
                os_log("Decode \(String(describing: T.self)) Error: \(error.localizedDescription), Data: \(jsonString)")
            } else {
                os_log("Decode \(String(describing: T.self)) Error: \(error.localizedDescription), Data could not be serialized")
            }
            return nil
        }
    }
}



extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        do {
            return try encoder.encode(self)
        } catch {
            os_log("Encode Error: \(error.localizedDescription)")
            return nil
        }
    }
}
