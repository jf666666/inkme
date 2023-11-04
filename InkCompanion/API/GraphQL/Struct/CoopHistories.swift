//
//  CoopHistories.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation

struct CoopHistories:Codable{
    struct Data:Codable{
        let coopResult:CoopResult?
    }
    let data: Data
}

enum CoopRule: String,Codable {
    case REGULAR = "REGULAR"
    case BIG_RUN = "BIG_RUN"
    case TEAM_CONTEST = "TEAM_CONTEST"
}

struct CoopResult: Codable {
    let regularAverageClearWave: Double?
    let regularGrade: CoopGrade?
    let regularGradePoint: Double?
    let monthlyGear: Gear?
    let scale: CoopScale?
    let pointCard: CoopPointCard?
    let historyGroups: CoopHistoryGroupConnection?
}

typealias CoopHistoryGroupConnection = Connection<CoopHistoryGroup>

struct CoopHistoryGroup: Codable {
    let startTime: String?
    let endTime: String?
    let mode: CoopMode?
    let rule: CoopRule?
    let playCount: Double?
    let highestResult: CoopGroupHighestResult?
    let historyDetails: CoopHistoryDetailConnection?
}


struct NextPreviousHistory:Codable{
    let id:String?
}
struct CoopHistoryDetail: Codable {
    let __typename: String?
    let id: String?
    let rule: CoopRule?
    let weapons: [CoopSupplyWeapon]?
    let nextHistoryDetail: NextPreviousHistory?
    let previousHistoryDetail: NextPreviousHistory?
    let resultWave: Double?
    let coopStage: CoopStage?
    let afterGrade: CoopGrade?
    let afterGradePoint: Double?
    let gradePointDiff: CoopGradePointDiff?
    let bossResult: CoopBossResult?
    let myResult: CoopPlayerResult?
    let memberResults: [CoopPlayerResult]?
    let enemyResults: [CoopEnemyResult]?
    let waveResults: [CoopWaveResult]?
    let playedTime: String?
    let dangerRate: Double?
    let scenarioCode: String?
    let smellMeter: Double?
    let scale: CoopScale?
    let jobPoint: Double?
    let jobScore: Double?
    let jobRate: Double?
    let jobBonus: Double?
}

struct CoopUniform: Codable {
    let id: String?
    let name: String?
    let image: Icon?
}

struct CoopWaveResult: Codable {
    let waveNumber: Int?
    let waterLevel: Int?
    let eventWave: CoopEventWave?
    let deliverNorm: Int?
    let goldenPopCount: Int?
    let teamDeliverCount: Int?
    let specialWeapons: [SpecialWeapon]?
}

struct CoopEventWave: Codable {
    let id: String?
    let name: String?
}

struct CoopEnemyResult: Codable {
    let defeatCount: Int?
    let teamDefeatCount: Int?
    let popCount: Int?
    let enemy: CoopEnemy?
}

struct CoopEnemy: Codable {
    let id: String?
    let name: String?
    let image: Icon?
}

// Assuming the structure of Image, SpecialWeapon

struct CoopBossResult: Codable {
    let boss: CoopEnemy?
    let hasDefeatBoss: Bool?
}

struct CoopPlayerResult: Codable {
    let player: CoopPlayer?
    let weapons: [CoopSupplyWeapon]?
    let specialWeapon: CoopSupplySpecialWeapon?
    let defeatEnemyCount: Int?
    let deliverCount: Int?
    let goldenAssistCount: Int?
    let goldenDeliverCount: Int?
    let rescueCount: Int?
    let rescuedCount: Int?
}

struct CoopPlayer: Codable {
    let __isPlayer: String?
    let id: String?
    let name: String?
    let nameId: String?
    let byname: String?
    let nameplate: Nameplate?
    let uniform: CoopUniform?
    let isMyself: Bool?
    let species: Species?
}



enum CoopGradePointDiff:String,Codable {
    case UP = "UP"
    case DOWN = "DOWN"
    case KEEP = "KEEP"
}

struct CoopStage: Codable {
    let __typename: String?
    let id: String?
    let name: String?
    let coopStageId: Int?
    let image: Icon?
    let thumbnailImage: Icon?
}

// Assuming the structure of Image

struct CoopSupplyWeapon: Codable {
    let __typename: String?
    let name: String?
    let image: Icon?
}

struct CoopSupplySpecialWeapon: Codable {
    let weaponId: Int?
    let name: String?
    let image: Icon?
}

// Assuming the structure of Image


typealias CoopHistoryDetailConnection = Connection<CoopHistoryDetail>

struct CoopGroupHighestResult: Codable {
    let grade: CoopGrade?
    let gradePoint: Double?
    let jobScore: Double?
    let trophy: CoopTrophy?
}

enum CoopTrophy:String,Codable {
    case GOLD = "GOLD"
    case SILVER = "SILVER"
    case BRONZE = "BRONZE"
}

// Assuming the structure of CoopGrade, CoopTrophy

enum CoopMode:String,Codable {
    case REGULAR = "REGULAR"
    case PRIVATE_CUSTOM = "PRIVATE_CUSTOM"
    case PRIVATE_SCENARIO = "PRIVATE_SCENARIO"
    case LIMITED = "LIMITED"
}

// Assuming the structure of CoopMode, CoopRule, CoopGroupHighestResult, CoopHistoryDetailConnection

struct CoopGrade: Codable {
    let id: String?
    let name: String?
}

struct CoopScale: Codable {
    let gold: Double?
    let silver: Double?
    let bronze: Double?
}

struct CoopPointCard: Codable {
    let defeatBossCount: Double?
    let deliverCount: Double?
    let goldenDeliverCount: Double?
    let playCount: Double?
    let rescueCount: Double?
    let regularPoint: Double?
    let totalPoint: Double?
    let limitedPoint: String? // Assuming limitedPoint is a string type
}
