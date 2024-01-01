//
//  CoopHistories.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation
import CoreData
import SwiftUI

struct CoopHistories:Codable{
  struct Data:Codable{
    let coopResult:CoopResult?
  }
  let data: Data
}



struct CoopResult: Codable {
  let regularAverageClearWave: Double
  let regularGrade: CoopGrade
  let regularGradePoint: Double
  let monthlyGear: Gear
  let scale: CoopScale
  let pointCard: CoopPointCard
  let historyGroups: CoopHistoryGroupConnection?

}

typealias CoopHistoryGroupConnection = Connection<CoopHistoryGroup>

struct CoopHistoryGroup: Codable,Hashable{
  static func == (lhs: CoopHistoryGroup, rhs: CoopHistoryGroup) -> Bool {
    lhs.startTime == rhs.startTime
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(startTime)
    hasher.combine(endTime)
  }
  let startTime: String
  let endTime: String
  let mode: CoopMode
  let rule: CoopRule
  let playCount: Int
  let highestResult: CoopGroupHighestResult?
  var historyDetails: CoopHistoryDetailConnection?

}

typealias CoopHistoryDetailConnection = Connection<CoopGroupDetail>

struct CoopGroupDetail:Codable{
  let id: String
  let gradePointDiff: CoopGradePointDiff?
}
struct CoopHistoryDetail: Codable,Equatable,Identifiable,Hashable {
  static func == (lhs: CoopHistoryDetail, rhs: CoopHistoryDetail) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  let id: String
  let rule: CoopRule
  let weapons: [CoopSupplyWeapon]
  let nextHistoryDetail: NextPreviousHistory?
  let previousHistoryDetail: NextPreviousHistory?
  let resultWave: Int
  let coopStage: CoopStage
  // in team contest, there is no grade and grade point, it will be nil
  let afterGrade: CoopGrade?
  let afterGradePoint: Int?
  var gradePointDiff: CoopGradePointDiff?
  let bossResult: CoopBossResult?
  let myResult: CoopPlayerResult
  let memberResults: [CoopPlayerResult]
  let enemyResults: [CoopEnemyResult]
  let waveResults: [CoopWaveResult]
  let playedTime: String
  let dangerRate: Double
  let smellMeter: Int?
  let scale: CoopScale?
  let jobPoint: Int
  let jobScore: Int
  let jobRate: Double
  let jobBonus: Int

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.rule = try container.decode(CoopRule.self, forKey: .rule)
    self.weapons = try container.decode([CoopSupplyWeapon].self, forKey: .weapons)
    self.nextHistoryDetail = try container.decodeIfPresent(NextPreviousHistory.self, forKey: .nextHistoryDetail)
    self.previousHistoryDetail = try container.decodeIfPresent(NextPreviousHistory.self, forKey: .previousHistoryDetail)
    self.resultWave = try container.decode(Int.self, forKey: .resultWave)
    self.coopStage = try container.decode(CoopStage.self, forKey: .coopStage)
    self.afterGrade = try container.decodeIfPresent(CoopGrade.self, forKey: .afterGrade)
    self.afterGradePoint = try container.decodeIfPresent(Int.self, forKey: .afterGradePoint)
    self.gradePointDiff = try container.decodeIfPresent(CoopGradePointDiff.self, forKey: .gradePointDiff)
    self.bossResult = try container.decodeIfPresent(CoopBossResult.self, forKey: .bossResult)
    self.myResult = try container.decode(CoopPlayerResult.self, forKey: .myResult)
    self.memberResults = try container.decode([CoopPlayerResult].self, forKey: .memberResults)
    self.enemyResults = try container.decode([CoopEnemyResult].self, forKey: .enemyResults)
    self.waveResults = try container.decode([CoopWaveResult].self, forKey: .waveResults)
    self.playedTime = try container.decode(String.self, forKey: .playedTime)
    self.dangerRate = try container.decode(Double.self, forKey: .dangerRate)
    self.smellMeter = try container.decodeIfPresent(Int.self, forKey: .smellMeter)
    self.scale = try container.decodeIfPresent(CoopScale.self, forKey: .scale)
    do{
      self.jobPoint = try container.decode(Int.self, forKey: .jobPoint)
    }catch{
      self.jobPoint = 0
    }
    do{
      self.jobScore = try container.decode(Int.self, forKey: .jobScore)
    }catch{
      self.jobScore = 0
    }
    do{
      self.jobRate = try container.decode(Double.self, forKey: .jobRate)
    }catch{
      self.jobRate = 0
    }
    do{
      self.jobBonus = try container.decode(Int.self, forKey: .jobBonus)
    }catch{
      self.jobBonus = 0
    }

  }

  var status:CoopStatus {getCoopStats(coop: self)}
}

enum CoopRule: String, Codable, Hashable, CaseIterable {
  case ALL = "ALL_RULE"
  case REGULAR = "REGULAR"
  case BIG_RUN = "BIG_RUN"
  case TEAM_CONTEST = "TEAM_CONTEST"
}

extension CoopRule{
  var icon:Image{
    switch self {
    case .REGULAR, .ALL:
      return Image(.salmonRun)
    case .BIG_RUN:
      return Image(.coopBigrun)
    case .TEAM_CONTEST:
      return Image(.coopTeamContest)

    }
  }

  var name:String{
    switch self {
    case .REGULAR:
      return "鲑鱼跑"
    case .BIG_RUN:
      return "大型跑"
    case .TEAM_CONTEST:
      return "团队打工竞赛"
    case .ALL:
      return "全部打工"
    }
  }
}

struct CoopSupplyWeapon: Codable,Hashable {
  let name: String?
  let image: Icon?
}

struct NextPreviousHistory:Codable,Hashable{
  let id:String?
}

struct CoopGrade: Codable {
  let id: String?
  let name: String?
}

struct CoopStage: Codable,Equatable,Stage,Hashable {

  static func == (lhs: CoopStage, rhs: CoopStage) -> Bool {
    return lhs.image?.url == rhs.image?.url
  }


  var id: String
  var name: String
  var image: Icon?
  var stage:StageSelection{
    StageSelection(rawValue: id) ?? .unknown
  }
}

struct CoopWaveResult: Codable,Hashable {

  let waveNumber: Int
  let waterLevel: Int
  let eventWave: CoopEventWave?
  let deliverNorm: Int?
  let goldenPopCount: Int
  let teamDeliverCount: Int?
  let specialWeapons: [SpecialWeapon]
}

struct CoopScale: Codable {
  let gold: Int
  let silver: Int
  let bronze: Int

}

struct CoopEnemyResult: Codable,Hashable {
  let defeatCount: Int
  let teamDefeatCount: Int
  let popCount: Int
  let enemy: CoopEnemy
}

struct CoopBossResult: Codable {
  let boss: CoopEnemy
  let hasDefeatBoss: Bool

}

struct CoopPlayerResult: Codable {
  let player: CoopPlayer
  let weapons: [CoopSupplyWeapon]
  let specialWeapon: SpecialWeapon?
  let defeatEnemyCount: Int
  let deliverCount: Int
  let goldenAssistCount: Int
  let goldenDeliverCount: Int
  let rescueCount: Int
  let rescuedCount: Int

}


struct CoopHistoryDetailQuery:Codable{
  struct Data:Codable{
    let coopHistoryDetail:CoopHistoryDetail
  }
  let data:Data
}

struct CoopUniform: Codable {
  let id: String
  let name: String
  let image: Icon
}



struct CoopEventWave: Codable,Hashable {
  let id: String
  let name: String
}



struct CoopEnemy: Codable,Hashable {
  let id: String
  let name: String
  let image: Icon?
  var enemy:Enemy{Enemy(rawValue: id) ?? .unknown}
}

extension CoopEnemy{
  enum Enemy:String{
    case Steelhead = "Q29vcEVuZW15LTQ="
    case Flyfish = "Q29vcEVuZW15LTU="
    case Scrapper = "Q29vcEVuZW15LTY="
    case SteelEel = "Q29vcEVuZW15LTc="
    case Stinger = "Q29vcEVuZW15LTg="
    case Maws = "Q29vcEVuZW15LTk="
    case Drizzler = "Q29vcEVuZW15LTEw"
    case FishStick = "Q29vcEVuZW15LTEx"
    case FlipperFlopper = "Q29vcEVuZW15LTEy"
    case BigShot = "Q29vcEVuZW15LTEz"
    case SlamminLid = "Q29vcEVuZW15LTE0"
    case Cohozuna = "Q29vcEVuZW15LTIz"
    case Horrorboros = "Q29vcEVuZW15LTI0"
    case Megalodontia = "Q29vcEVuZW15LTI1"
    case MudMouth = "Q29vcEVuZW15LTIw"
    case Goldis = "Q29vcEVuZW15LTE1"
    case Griller = "Q29vcEVuZW15LTE3"
    case unknown = "??"
  }

}

extension CoopEnemy.Enemy{
  var image:Image{
    switch self {
    case .Steelhead:
      Image(.steelhead)
    case .Flyfish:
      Image(.flyfish)
    case .Scrapper:
      Image(.scrapper)
    case .SteelEel:
      Image(.steelEel)
    case .Stinger:
      Image(.stinger)
    case .Maws:
      Image(.maws)
    case .Drizzler:
      Image(.drizzler)
    case .FishStick:
      Image(.fishStick)
    case .FlipperFlopper:
      Image(.flipperFlopper)
    case .BigShot:
      Image(.bigShot)
    case .SlamminLid:
      Image(.slamminLid)
    case .Cohozuna:
      Image(.cohozuna)
    case .Horrorboros:
      Image(.horrorboros)
    case .Megalodontia:
      Image(.megalodontia)
    case .MudMouth:
      Image(.mudMouth)
    case .unknown:
      Image(.unknowEnemy)
    case .Goldis:
      Image(.goldie)
    case .Griller:
      Image(.griller)
    }
  }
}






struct CoopPlayer: Codable {

  let id: String
  let name: String
  let nameId: String
  let byname: String
  let nameplate: Nameplate
  let uniform: CoopUniform
  let isMyself: Bool?
  let species: Species

}



enum CoopGradePointDiff:String,Codable {
  case UP = "UP"
  case DOWN = "DOWN"
  case KEEP = "KEEP"
  case NONE = "NONE"
}


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

enum CoopMode:String,Codable,CaseIterable {
  case REGULAR = "REGULAR"
  case PRIVATE_CUSTOM = "PRIVATE_CUSTOM"
  case PRIVATE_SCENARIO = "PRIVATE_SCENARIO"
  case LIMITED = "LIMITED"
}

// Assuming the structure of CoopMode, CoopRule, CoopGroupHighestResult, CoopHistoryDetailConnection





struct CoopPointCard: Codable {
  let defeatBossCount: Double
  let deliverCount: Double
  let goldenDeliverCount: Double
  let playCount: Double
  let rescueCount: Double
  let regularPoint: Double
  let totalPoint: Double
  let limitedPoint: Int? // Assuming limitedPoint is a string type
}
