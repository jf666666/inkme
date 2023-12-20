//
//  CoopRecord.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/16/23.
//

import Foundation

struct CoopRecord:Codable{
  let teamContestRecord:TeamContestRecord
  let defeatBossRecords:[DefeatEnemyRecord]
  let defeatEnemyRecords:[DefeatEnemyRecord]
  let stageHighestRecords:[StageHighestRecord]
}

struct CoopRecordQuery:Codable{
  struct Data:Codable{
    let coopRecord:CoopRecord
  }
  let data:Data
}

struct DefeatEnemyRecord:Codable{
  let enemy:CoopEnemy
  let defeatCount:Int
}

struct StageHighestRecord:Codable{
  let coopStage:CoopStage
  let grade:CoopGrade
  let gradePoint:Int
}

struct TeamContestRecord:Codable{
  let gold : Int
  let bronze : Int
  let silver : Int
  let attend : Int
}
