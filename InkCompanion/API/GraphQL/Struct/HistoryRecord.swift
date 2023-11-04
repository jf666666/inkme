//
//  HistoryRecord.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//

import Foundation
import AnyCodable

struct Icon: Codable {
    var __typename: String? = "Image"
    let url: String
}

struct Brand: Codable {
    var __typename: String? = "Brand"
    let id:String?
    let name:String?
    let image:Icon?
    let usualGearPower:GearPower?
}

struct GearRecordStats: Codable{
    let exp:Int?
}

struct GearPower: Codable {
    var __typename: String? = "GearPower"
    let gearPowerId:Int?
    let name:String?
    let desc:String?
    let image:Icon?
    let power:Double?
    let isEmptySlot: Bool?
}

struct Gear: Codable {
    let __typename: String?
    let name: String?
    let rarity: Int?
    let image: Icon?
    let brand: Brand?
    let primaryGearPower: GearPower?
    let additionalGearPowers: [GearPower]?
    let stats: GearRecordStats?
}

struct Nameplate: Codable {
    let badges: [Badge?]
    let background: NameplateBackground?
}

struct NameplateBackground: Codable {
    let id: String?
    let image: Icon?
    let textColor: Colour?
}

struct Colour: Codable {
    let a: Double
    let r: Double
    let g: Double
    let b: Double
}

struct Badge: Codable {
    var __typename: String? = "Badge"
    let id: String?
    let image: Icon?
    let description: String?
}



struct Weapon: Codable {
    var __typename: String? = "Weapon"
    let id: String?
    let weaponId: Int?
    let weaponCategory: WeaponCategory?
    let name: String?
    let image: Icon?
    let subWeapon: SubWeapon?
    let specialWeapon: SpecialWeapon?
    let stats: WeaponRecordStats? // nil if not owned
}

struct WeaponRecordStats: Codable {
    let lastUsedTime: String?
    let paint: Double?
    let level: Int?
    let expToLevelUp: Int?
    let win: Int?
    let vibes: Double?
}

struct SubWeapon: Codable {
    var __typename: String? = "SubWeapon"
    let id: String?
    let name: String?
    let image: Icon?
}

struct SpecialWeapon: Codable {
    var __typename: String? = "SpecialWeapon"
    let id: String?
    let specialWeaponId: Int?
    let name: String?
    let image: Icon?
    let maskingImage: MaskingImage?
}

struct MaskingImage: Codable {
    let width: Int?
    let height: Int?
    let maskImageUrl: String?
    let overlayImageUrl: String?
}

struct WeaponCategory: Codable {
    var __typename: String? = "WeaponCategory"
    let id: String?
    let weaponCategoryId: Int?
    let category: String?
    let name: String?
    let image: Icon?
}

struct PlayHistoryTrophyRecord:Codable {
    let attend: Int?
    let bronze: Int?
    let gold: Int?
    let silver: Int?
}


struct Connection<T:Codable>:Codable {
    let nodes: [T]?
    let edges: [Edge<T>]?
    let pageInfo: PageInfo?
    let totalCount: Int?
}

struct PageInfo :Codable{
    let endCursor: String?
    let hasNextPage: Bool?
}

struct Edge<T:Codable>:Codable {
    let node: T?
    let cursor: String?
}

struct WeaponHistory:Codable {
    let seasonName: String?
    let isMonthly: Bool?
    let startTime: String?
    let endTime: String?
    let weaponCategories: [WeaponCategoryUtilRatio]?
    let weapons: [WeaponUtilRatio]?
}

struct WeaponUtilRatio:Codable {
    let weapon: Weapon?
    let utilRatio: Double?
}

typealias WeaponHistoryConnection = Connection<WeaponHistory>

struct WeaponCategoryUtilRatio:Codable {
    let weaponCategory: WeaponCategory?
    let utilRatio: Double?
    let weapons: [WeaponUtilRatio]
}

struct XMatchMax: Codable {
    let power: AnyCodable?
    let rank: AnyCodable?
    let rankUpdateSeasonName: AnyCodable?
    let powerUpdateTime: AnyCodable?
}

typealias XRankingHolder = AnyCodable
typealias XRankingHolderConnection = Connection<XRankingHolder>
typealias XRankingHolderEdge = Edge<XRankingHolder>

struct XRankingSeason: Codable {
    let __typename: String?
    let id: String?
    let name: String?
    let isCurrent: Bool?
    let startTime: String?
    let endTime: String?
    let lastUpdateTime: String?
    let xRankingAr: XRankingHolderConnection?
    let xRankingCl: XRankingHolderConnection?
    let xRankingGl: XRankingHolderConnection?
    let xRankingLf: XRankingHolderConnection?
    let weaponTopsAr: XRankingHolderConnection?
    let weaponTopsCl: XRankingHolderConnection?
    let weaponTopsGl: XRankingHolderConnection?
    let weaponTopsLf: XRankingHolderConnection?
}



struct XMatchSeasonHistory: Codable {
    let powerAr: AnyCodable?
    let powerCl: AnyCodable?
    let powerGl: AnyCodable?
    let powerLf: AnyCodable?
    let rankAr: AnyCodable?
    let rankCl: AnyCodable?
    let rankGl: AnyCodable?
    let rankLf: AnyCodable?
    let xRankingSeason: XRankingSeason
}

typealias XMatchSeasonHistoryConnection = Connection<XMatchSeasonHistory>

struct CurrentPlayer: Codable {
    let clothingGear: Gear?
    let headGear: Gear?
    let name: String?
    let shoesGear: Gear?
    let userIcon: Icon?
    let weapon: Weapon?
    let byname: String?
    let nameId: String?
    let nameplate: Nameplate?
}

struct PlayHistory: Codable {
    let allBadges: [Badge]
    let badges: [Badge]
    let bankaraMatchOpenPlayHistory: PlayHistoryTrophyRecord?
    let currentTime: String?
    let frequentlyUsedWeapons: [Weapon?]
    let gameStartTime: String?
    let leagueMatchPlayHistory: PlayHistoryTrophyRecord?
    let paintPointTotal: Int?
    let rank: Int?
    let recentBadges: [Badge]
    let udemae: String?
    let udemaeMax: String?
    let weaponHistory: WeaponHistoryConnection?
    let winCountTotal: Int?
    let xMatchMaxAr: XMatchMax?
    let xMatchMaxCl: XMatchMax?
    let xMatchMaxGl: XMatchMax?
    let xMatchMaxLf: XMatchMax?
    let xMatchRankAr: AnyCodable?
    let xMatchRankCl: AnyCodable?
    let xMatchRankGl: AnyCodable?
    let xMatchRankLf: AnyCodable?
    let xMatchSeasonHistory: XMatchSeasonHistoryConnection?
}




struct HistoryRecordQuery: Codable{
    struct Data: Codable {
        let currentPlayer: CurrentPlayer?
        let playHistory: PlayHistory?
    }
    let data:Data
}
