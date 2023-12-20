//
//  Struct.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//

import Foundation

struct FriendListResult: Codable {
    struct Data: Codable{
        var currentFest: CurrentFest?
        var friends: Friends?
        
        struct CurrentFest: Codable {
            var id: String
            var state: String
            var teams: [FestTeam]?
            
            struct FestTeam: Codable {
                var id: String
                var color: Color
                
                struct Color: Codable {
                    var r: Float
                    var g: Float
                    var b: Float
                    var a: Float
                }
            }
        }
        
        struct Friends: Codable {
            var nodes: [Node]?
            
            struct Node: Codable, Equatable {
                var id: String
                var coopRule: String?
                var isLocked: Bool?
                var isVcEnabled: Bool?
                var nickname: String
                var onlineState: String
                var playerName: String?
                var userIcon: UserIcon?
                var vsMode: VsMode?
                var isFavorite: Bool?
                
                struct UserIcon: Codable, Equatable {
                    var height: Int
                    var url: String
                    var width: Int
                }
                

            }

        }
    }
    let data:Data
}

struct VsMode: Codable, Equatable {
    var id: String
    var mode: String
//    var name: String
}
