//
//  WeaponRecord.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation

struct WeaponRecordQuery: Codable {
    struct Data:Codable{
        let weaponRecords: WeaponConnection?
    }
    let data:Data
}

struct WeaponConnection: Codable {
    var nodes: [WeaponNode]?
}

struct WeaponNode: Codable {
    var id: String?
    var image2d: Icon?
    var image2dThumbnail: Icon?
    var image3d: Icon?
    var image3dThumbnail: Icon?
    var name: String?
    var specialWeapon: SpecialWeapon?
    var stats: WeaponRecordStats?
    var subWeapon: SubWeapon?
    var weaponCategory: WeaponCategory?
    var weaponId: Int?
}




