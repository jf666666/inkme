//
//  LatestBattleHistories.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import Foundation

struct GeneralBattleHistories:Codable{
  var historyGroups:HistoryGroups
  var summary:Summary
  var currentFest:CurrentFest?
}


extension GeneralBattleHistories{
  typealias HistoryGroups = Connection<temp>
  struct temp:Codable{
    var historyDetails:HistoryDetails
  }
  typealias HistoryDetails = Connection<BriefDetail>
  struct BriefDetail:Codable{
    struct Mode:Codable{
      var id:String
      var mode:String
    }
    struct Rule:Codable{
      var id:String
      var name:String
    }
    var id:String
    var vsMode:Mode
    var vsRule:Rule
    var udemae:String?
    var myTeam:MyTeam

    struct MyTeam:Codable{
      let result:MyResult?
      struct MyResult:Codable{
        let score:Double?
        let paintPoint:Double?
      }
    }
  }

  struct Summary:Codable{
  var assistAverage: Double
  var deathAverage: Double
  var killAverage: Double
  var lose:Int
  var perUnitTimeMinute: Int
  var specialAverage: Double
  var win: Int
  }
}


extension GeneralBattleHistories{
  struct CurrentFest:Codable{
    var id:String
    var state:FestState
    var teams:[Team]
    struct Team:Codable{
      var id:String
      var color:SN3Color
    }
  }
}
