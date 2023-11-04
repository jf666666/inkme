//
//  CatalogQuery.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

// 假设的Codable协议符合的结构体
struct CatalogQuery: Codable {
    struct Data:Codable{
        let catalog: Catalog?
    }
    let data: Data?
}

struct Catalog: Codable {
    var bonus: CatalogBonus?
    var progress: CatalogProgress?
    var seasonEndTime: String?
    var seasonName: String?
}

struct CatalogBonus: Codable {
    var dailyWinPoint: Int?
    var isBigRun: Bool?
    var isFest: Bool?
    var isSeasonClosing: Bool?
}

struct CatalogProgress: Codable {
    var currentPoint: Int?
    var extraReward: CatalogExtraReward?
    var level: Int?
    var levelUpPoint: Int?
    var rewards: [CatalogReward]?
    var totalPoint: Int?
}

struct CatalogExtraReward: Codable {
    var item: CatalogItem?
    var nextAcceptLevel: Int?
}

struct CatalogItem: Codable {
    var id: String?
    var image: Icon?
    var name: String?
    var amount: Int?
    var clothingGear: ClothingGear?
    var headGear: HeadGear?
    var kind: String?
    var primaryGearPower: GearPower?
    var shoesGear: ShoesGear?
}

struct ClothingGear: Codable {
    var image: Icon?
    var primaryGearPower: GearPower?
}

struct HeadGear: Codable {
    var image: Icon?
    var primaryGearPower: GearPower?
}

struct ShoesGear: Codable {
    var image: Icon?
    var primaryGearPower: GearPower?
}


struct CatalogReward: Codable {
    var currentPoint: Int?
    var item: CatalogItem?
    var level: Int?
    var state: String?
}


