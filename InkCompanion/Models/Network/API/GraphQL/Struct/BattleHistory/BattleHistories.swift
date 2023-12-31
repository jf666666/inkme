//
//  BattleHistories.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation
import AnyCodable
import SwiftUI

enum BankaraMatchMode: String, Codable,CaseIterable {

  case CHALLENGE = "CHALLENGE"
  case OPEN = "OPEN"

  var name:String{
    switch self {
    case .CHALLENGE:
      return "挑战"
    case .OPEN:
      return "开放"
    }
  }
}

enum BankaraMatchChallengeState: String, Codable {
  case succeeded = "SUCCEEDED"
  case failed = "FAILED"
  case abortedBySeasonReset = "ABORTED_BY_SEASON_RESET"
  case abortedByUdemaeReset = "ABORTED_BY_UDEMAE_RESET"
}

enum FestMatchMode: String, Codable,CaseIterable{
  case challenge = "CHALLENGE"
  case regular = "REGULAR"
  var name:String{
    switch self {
    case .challenge:
      return "挑战"
    case .regular:
      return "一般"
    }
  }
}

enum Judgement: String, Codable {
  case WIN = "WIN"
  case LOSE = "LOSE"
  case EXEMPTED_LOSE = "EXEMPTED_LOSE"
  case DEEMED_LOSE = "DEEMED_LOSE"
  case DRAW = "DRAW"

  var name:String{
    switch self {
    case .WIN:
      return rawValue+"!"
    case .LOSE,.EXEMPTED_LOSE,.DEEMED_LOSE:
      return Judgement.LOSE.rawValue+"..."
    case .DRAW:
      return rawValue
    }
  }
  var color:Color{
    switch self {
    case .WIN:
      return Color.spLightGreen
    default:
      return Color.spPink
    }
  }
}

enum LeagueMatchTeamComposition:String,Codable {
  case TEAM = "TEAM"
  case PAIR = "PAIR"
  case SOLO = "SOLO"
}

enum XMatchMeasurementState: String, Codable {
  case completed = "COMPLETED"
  case inProgress = "INPROGRESS"
}

enum JudgementKnockout: String, Codable {
  case NEITHER = "NEITHER"
  case WIN = "WIN"
  case LOSE = "LOSE"
}



struct FestData: Codable {
  var id: String?
  var state: String?
  var teams: [FestTeamData]?
}

struct FestTeamData: Codable {
  var id: String?
  var color: SN3Color?
}


struct VsResultData: Codable {
  var historyGroups: VsHistoryGroupConnection?
  var historyGroupsOnlyFirst: VsHistoryGroupConnection?
  var summary: VsHistorySummaryData?
}

struct VsHistoryGroup: Codable {
  let __typename: String?
  let bankaraMatchChallenge: BankaraMatchChallenge?
  let xMatchMeasurement: XMatchMeasurement?
  let leagueMatchTeamId: String?
  let historyDetails: VsHistoryDetailConnection?
  let regularMatchLastPlayedTime: String?
  let privateMatchLastPlayedTime: String?
  let leagueMatchHistoryGroup: LeagueMatchHistoryGroup?
}

struct LeagueMatchEvent: Codable {
  var id: String?
  var leagueMatchEventId: String?
  var name: String?
  var desc: String?
  var regulation: String?
  var regulationUrl: String?
}

struct LeagueMatchHistoryGroup: Codable {
  let leagueMatchEvent: LeagueMatchEvent?
  let myLeaguePower: AnyCodable? // Assuming myLeaguePower is a string type
  let measurementState: AnyCodable? // Assuming measurementState is a string type
  let teamComposition: LeagueMatchTeamComposition?
  let vsRule: VsRule?
}


struct XMatchMeasurement: Codable {
  let state: XMatchMeasurementState?
  let xPowerAfter: Int?
  let isInitial: Bool?
  let winCount: Int?
  let loseCount: Int?
  let maxInitialBattleCount: Int?
  let maxWinCount: Int?
  let maxLoseCount: Int?
  let vsRule: VsRule?
}


struct VsRule: Codable {
  let name: String
  let rule: BattleRule
  let id: String
}

struct BankaraMatchChallenge: Codable {
  let winCount: Double?
  let loseCount: Double?
  let maxWinCount: Double?
  let maxLoseCount: Double?
  let state: BankaraMatchChallengeState?
  let isPromo: Bool?
  let isUdemaeUp: Bool?
  let udemaeAfter: String?
  let earnedUdemaePoint: Double?
}

typealias VsHistoryGroupConnection = Connection<VsHistoryGroup>

typealias VsHistoryDetailConnection = Connection<VsHistoryDetail>




struct VsHistoryDetailQuery:Codable{
  struct Data:Codable{
    let vsHistoryDetail:VsHistoryDetail
  }
  let data:Data
}






struct FestMatchHistory: Codable {
  var dragonMatchType: DragonMatchType
  var contribution: Int
  var jewel: Int
  var myFestPower: Double?
}

enum DragonMatchType:String,Codable {
  case NORMAL = "NORMAL"
  case DECUPLE = "DECUPLE"
  case DRAGON = "DRAGON"
  case DOUBLE_DRAGON = "DOUBLE_DRAGON"
}

struct XMatchHistory: Codable {
  var lastXPower: Double?
  var entireXPower: Double?
}

struct LeagueMatchHistory: Codable {
  var teamId: String?
  var leagueMatchEvent: LeagueMatchEvent?
  var myLeaguePower: Double?
}

struct BankaraMatchHistory: Codable {
  var earnedUdemaePoint: Double?
  var mode: BankaraMatchMode?
  var bankaraPower: BankaraMatchPower?
}

struct BankaraMatchPower:Codable {
  let power:Double?
}


struct VsTeam: Codable {
  var color: SN3Color
  var judgement: Judgement?
  var result: VsTeamResult?
  var tricolorRole: TricolourRole?
  var festTeamName: String?
  var festUniformName: String?
  var festUniformBonusRate: Double?
  var festStreakWinCount: Double?
  var players: [VsPlayer]
  var order: Int
}

enum TricolourRole:String,Codable {
  case ATTACK_1 = "ATTACK1"
  case ATTACK_2 = "ATTACK2"
  case DEFENSE = "DEFENSE"
}

struct VsTeamResult: Codable {
  var __typename: String?
  var paintPoint: Double?
  var paintRatio: Double?
  var score: Double?
  var noroshi: Double?
}

struct VsPlayer: Codable {
  var id: String
  var byname: String
  var name: String
  var nameId: String
  var nameplate: Nameplate
  var paint: Int
  var isMyself: Bool
  var weapon: Weapon
  var headGear: HeadGear
  var clothingGear: ClothingGear
  var shoesGear: ShoesGear
  var species: Species
  var result: VsPlayerResult?
  var crown: Bool
  var festDragonCert: FestDragonCert
  var festGrade: String?
}

enum FestDragonCert:String,Codable {
  case NONE = "NONE"
  case DRAGON = "DRAGON"
  case DOUBLE_DRAGON = "DOUBLE_DRAGON"
}

struct VsPlayerResult: Codable {
  var kill: Int
  var death: Int
  var assist: Int
  var special: Int
  var noroshiTry: Double?
}

enum Species:String,Codable {
  case INKLING = "INKLING"
  case OCTOLING = "OCTOLING"

  var icon: iIcon {
    return iIcon(species: self)
  }

  struct iIcon {
    let species: Species

    var kill: Image {
      switch species {
      case .INKLING:
        return Image(.ikaK)
      case .OCTOLING:
        return Image(.takoK)
      }
    }

    var dead: Image {
      switch species {
      case .INKLING:
        return Image(.ikaD)
      case .OCTOLING:
        return Image(.takoD)
      }
    }

    var kd: Image {
      switch species {
      case .INKLING:
        return Image(.ikaKd)
      case .OCTOLING:
        return Image(.takoKd)
      }
    }
  }
}


struct VsHistoryDetailConnectionData: Codable {
  var nodes: [VsHistoryDetailData]?
}

struct VsHistoryDetailData: Codable {
  var id: String?
  var bankaraMatch: BankaraMatchHistoryData?
  var judgement: String?
  var knockout: Bool?
  var myTeam: VsTeamData?
  var nextHistoryDetail: VsHistoryDetailReference?
  var player: VsPlayerData?
  var previousHistoryDetail: VsHistoryDetailReference?
  var udemae: String?
  var vsMode: VsModeData?
  var vsRule: VsRuleData?
  var vsStage: VsStageData?
}

struct BankaraMatchHistoryData: Codable {
  var earnedUdemaePoint: Double?
}

struct VsTeamData: Codable {
  var result: VsTeamResultData?
}

struct VsTeamResultData: Codable {
  var paintPoint: Double?
  var score: Double?
}

struct VsHistoryDetailReference: Codable {
  var id: String?
}

struct VsPlayerData: Codable {
  var id: String?
  var festGrade: String?
  var weapon: WeaponData?
}

struct WeaponData: Codable {
  var id: String?
  var image: Icon?
  var name: String?
  var specialWeapon: SpecialWeaponData?
}

struct SpecialWeaponData: Codable {
  var id: String?
  var maskingImage: MaskingImage?
}

struct MaskingImageData: Codable {
  var height: Double?
  var maskImageUrl: String?
  var overlayImageUrl: String?
  var width: Double?
}

struct VsModeData: Codable {
  var id: String?
  var mode: String?
}

struct VsRuleData: Codable {
  var id: String?
  var name: String?
}

struct VsStageData: Codable {
  var id: String?
  var image: Icon?
  var name: String?
}

struct VsHistorySummaryData: Codable {
  var assistAverage: Double?
  var deathAverage: Double?
  var killAverage: Double?
  var lose: Double?
  var perUnitTimeMinute: Double?
  var specialAverage: Double?
  var win: Double?
}

struct LatestBattleHistoriesQuery: Codable {
  struct Data:Codable{
    var currentFest: FestData?
    var latestBattleHistories: VsResultData?
  }
  let data:Data
}

struct BankaraBattleHistories: Codable {
  struct Data:Codable{
    var bankaraBattleHistories: VsResultData?
  }
  let data:Data
}

struct XBattleHistories: Codable {
  struct Data:Codable{
    var xBattleHistories: VsResultData?
  }
  let data:Data
}

struct EventBattleHistories: Codable {
  struct Data:Codable{
    var eventBattleHistories: VsResultData?
  }
  let data:Data
}

struct PrivateBattleHistories: Codable {
  struct Data:Codable{
    var privateBattleHistories: VsResultData?
  }
  let data:Data
}

struct RegularBattleHistories: Codable {
  struct Data:Codable{
    var regularBattleHistories: VsResultData?
  }
  let data:Data
}
