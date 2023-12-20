//
//  EquipmentsQuery.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation
import AnyCodable


struct MyOutfitCommonDataEquipmentsQuery: Codable {
    struct Data:Codable{
        var clothingGears: OperationField<ClothingGearConnection>?
        var headGears: OperationField<HeadGearConnection>?
        var shoesGears: OperationField<ShoesGearConnection>?
        var weapons: OperationField<WeaponConnection>?
    }
    let data:Data
}

typealias HeadGearConnection = Connection<HeadGear>
typealias ShoesGearConnection = Connection<ShoesGear>
typealias ClothingGearConnection = Connection<ClothingGear>

struct OperationField<T: Codable>: Codable {
    var nodes: [GearNode<T>]?
}

struct GearNode<T: Codable>: Codable {
    var __isGear: String?
    var __typename: String?
    var additionalGearPowers: [GearPower]?
    var brand: Brand?
    var image: Icon?
    var name: String?
    var primaryGearPower: GearPower?
    var rarity: Int?
    var stats: GearRecordStats?
    var headGearId: Double?
    var clothingGearId: Double?
    var shoesGearId: Double?
}



