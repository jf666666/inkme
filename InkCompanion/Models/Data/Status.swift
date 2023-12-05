//
//  Status.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import Foundation

func getCoopStats(coop:CoopHistoryDetail) -> CoopStatus{
  var exempt = false
  if coop.resultWave < 0 {
    exempt = true
  }
  var wave = 0
  if coop.resultWave == 0{
    wave = coop.waveResults.count
    switch coop.rule{
    case .BIG_RUN, .REGULAR, .ALL:
      if (coop.bossResult != nil){
        wave -= 1
      }
      break
    case .TEAM_CONTEST:
      break
    }
  }else {
    wave = coop.resultWave - 1
  }
  var grade:CoopStatus.Grade? = nil
  if let afterGrade = coop.afterGrade,let afterGradePoint = coop.afterGradePoint{
    grade = CoopStatus.Grade(name: afterGrade.id ?? "", point: afterGradePoint)
  }
  let bosses = coop.enemyResults.map { BossSalmonidStats(id: $0.enemy.id, appear: $0.popCount, defeat: $0.defeatCount, defeatTeam: $0.teamDefeatCount)}
  var waves:[WaveStats] = []
  var king:CoopStatus.King?
  if let bossResult = coop.bossResult {
    let waveResult = coop.waveResults[3]
    waves.append(WaveStats(id: bossResult.boss.id, levels: [WaveStats.Level(id: waveResult.waterLevel, appear: 1, clear: (bossResult.hasDefeatBoss) ? 1:0)]))
    king = CoopStatus.King(id: bossResult.boss.id, defeat: bossResult.hasDefeatBoss)
  }
  for (i,result) in coop.waveResults.enumerated() {
    waves.append(WaveStats(id: result.eventWave?.id ?? "-", levels: [WaveStats.Level(id: result.waterLevel, appear: 1, clear: (coop.resultWave == 0 || coop.resultWave > i + 1) ? 1 : 0)]))
  }
  let selfResult = getCoopPlayerStats(player: coop.myResult)
  return CoopStatus(time: coop.playedTime.asDate,
                   exempt: exempt,
                   clear: coop.resultWave == 0,
                   wave: wave,
                   dangerRate: coop.dangerRate,
                   myself: selfResult,
                   member: coop.memberResults.count+1,
                   team: coop.memberResults.map{getCoopPlayerStats(player: $0)}.sum()+selfResult,
                   bosses: bosses,
                   king: king,
                   scale: coop.scale != nil ? CoopStatus.Scale(gold: coop.scale?.gold ?? 0, silver: coop.scale?.silver ?? 0, bronze: coop.scale?.bronze ?? 0) : nil,
                   waves: waves,
                    rule: coop.rule.rawValue,
                   stage: coop.coopStage.id,
                   weapons: coop.myResult.weapons.map{$0.image?.url ?? ""},
                   specialWeapon: coop.myResult.specialWeapon?.id,
                   suppliedWeapon: coop.weapons.map{$0.image?.url ?? ""},
                   jobPoint: coop.jobPoint,
                   jobScore: coop.jobScore,
                   jobRate: coop.jobRate,
                   jobBonus: coop.jobBonus,
                   grade: grade
  )
}

func getCoopPlayerStats(player:CoopPlayerResult) -> CoopPlayerStats{
  return CoopPlayerStats(defeat: player.defeatEnemyCount, golden: player.goldenDeliverCount, assist: player.goldenAssistCount, power: player.deliverCount, rescue: player.rescueCount, rescued: player.rescuedCount)
}


struct CoopStatus:Codable{
  struct King:Codable{
    let id:String
    let defeat:Bool
  }

  struct Scale: Codable {
    static func + (left:Scale, right:Scale) -> Scale{
      return Scale(gold: left.gold+right.gold, silver: left.silver+right.silver, bronze: left.bronze+right.bronze)
    }
    var gold: Int
    var silver: Int
    var bronze: Int
  }
  struct Grade:Codable{
    let name:String
    let point:Int
  }

  let time:Date
  let exempt:Bool
  let clear:Bool
  let wave:Int
  let dangerRate:Double
  let myself:CoopPlayerStats
  let member:Int
  let team:CoopPlayerStats
  let bosses:[BossSalmonidStats]
  let king:King?
  let scale:Scale?
  let waves:[WaveStats]
  let rule:String
  let stage:String
  let weapons:[String]
  let specialWeapon:String?
  let suppliedWeapon:[String]
  let jobPoint: Int
  let jobScore: Int
  let jobRate: Double
  let jobBonus: Int
  let grade:Grade?
}

struct CoopPlayerStats:Codable {
  static func + (lhs: CoopPlayerStats, rhs: CoopPlayerStats) -> CoopPlayerStats {
    return CoopPlayerStats(
      defeat: lhs.defeat + rhs.defeat,
      golden: lhs.golden + rhs.golden,
      assist: lhs.assist + rhs.assist,
      power: lhs.power + rhs.power,
      rescue: lhs.rescue + rhs.rescue,
      rescued: lhs.rescued + rhs.rescued
    )
  }
  let defeat: Int
  let golden: Int
  let assist: Int
  let power: Int
  let rescue: Int
  let rescued: Int
}

struct BossSalmonidStats:Codable {
  let id: String
  let appear: Int
  let defeat: Int
  let defeatTeam: Int
}

struct WaveStats:Codable {
  struct Level:Codable{
    let id:Int
    let appear:Int
    let clear:Int
  }
  let id: String
  let levels:[Level]
}

struct BattleStatus:Codable{
  var time:Date
  var win:Bool
  var loss:Bool
  var exempt:Bool
  var power:Double?
  var duration:Int
  var myself:BattlePlayerStats
  var teamMember:Int
  var team:BattlePlayerStats
  var allMember:Int
  var all:BattlePlayerStats
  var mode:String
  var rule:String
  var stage:String
  var weapon:String
}

struct BattlePlayerStats:Codable{
  static func + (left:BattlePlayerStats, right:BattlePlayerStats)->BattlePlayerStats{
    return BattlePlayerStats(turf: left.turf+right.turf, 
                             kill: left.kill+right.kill,
                             assist: left.assist+right.assist,
                             death: left.death+right.death,
                             special: left.special+right.special)
  }
  var turf: Int
  var kill: Int
  var assist: Int
  var death: Int
  var special: Int
}

extension VsHistoryDetail{
  var status:BattleStatus{
    var win:Bool = false
    var loss:Bool = false
    switch self.judgement{
    case .WIN:
      win = true
    case .LOSE,.EXEMPTED_LOSE,.DEEMED_LOSE:
      loss = true
    case .DRAW:
      break
    }
    let team = myTeam.players.map{$0.status}.sum()
    let myself = myTeam.players.filter({ $0.isMyself })[0]
    return BattleStatus(time: playedTime.asDate,
                        win: win,
                        loss: loss,
                        exempt: (judgement == .DEEMED_LOSE && duration == 0) || judgement == .DRAW,
                        power: getVsPower(battle: self),
                        duration: duration,
                        myself: myself.status,
                        teamMember: myTeam.players.count,
                        team: team,
                        allMember: myTeam.players.count + otherTeams.map{$0.players.count}.sum(),
                        all: otherTeams.map{$0.players.map{$0.status}.sum()}.sum()+team,
                        mode: vsMode.id,
                        rule: vsRule.id,
                        stage: vsStage.id,
                        weapon:myself.weapon.image?.url ?? "" )
  }
}

extension VsPlayer{
  var status:BattlePlayerStats{
    return BattlePlayerStats(turf: paint, kill: result?.kill ?? 0, assist: result?.assist ?? 0, death: result?.death ?? 0, special: result?.special ?? 0)
  }
}

func getVsPower(battle:VsHistoryDetail)->Double?{
  if let bankaraMatch = battle.bankaraMatch, let bankaraPower = bankaraMatch.bankaraPower{
    return bankaraPower.power
  }
  if let xMatch = battle.xMatch{
    return xMatch.lastXPower
  }
  if let leagueMatch = battle.leagueMatch, let myLeaguePower = leagueMatch.myLeaguePower{
    return myLeaguePower
  }
  if let festMatch = battle.festMatch{
    return festMatch.myFestPower
  }
  return nil
}
