//
//  VsHistoryDetail.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/3/23.
//

import Foundation

struct VsHistoryDetail: Codable {
    var id: String
    var vsMode: VsMode
    var vsRule: VsRule
    var vsStage: VsStage

    var playedTime: String
    var duration: Int
    var judgement: Judgement
    var player: VsPlayer

    var knockout: JudgementKnockout?

    var myTeam: VsTeam
    var otherTeams: [VsTeam]

    var bankaraMatch: BankaraMatchHistory?
    var leagueMatch: LeagueMatchHistory?
    var xMatch: XMatchHistory?
    var festMatch: FestMatchHistory?

    var awards: [Award]

    var nextHistoryDetail: NextPreviousHistory?
    var previousHistoryDetail: NextPreviousHistory?
}

extension VsHistoryDetail{
  struct Award: Codable {
      var name: String
      var rank: AwardRank

    enum AwardRank:String,Codable {
        case GOLD = "GOLD"
        case SILVER = "SILVER"
    }
  }
}
