//
//  InkData.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/18/23.
//

import Foundation
import CoreData

class InkData{
  static let shared = InkData()
  private init() {}

  var context:NSManagedObjectContext {PersistenceController.shared.container.viewContext}

  private func save() async {
      if context.hasChanges {
          do {
              try await context.perform {
                  try self.context.save()
                  print("saved!!")
              }
          } catch let error as NSError {
              print("failed!!")
              print(error.userInfo)
          }
      }
  }


  func isExist(id: String) async -> Bool {
      let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %@", id)
      fetchRequest.fetchLimit = 1

      do {
          let result = try await context.perform {
              try self.context.fetch(fetchRequest)
          }
          return !result.isEmpty
      } catch {
          return false
      }
  }


  private func isShiftExist(id:String) ->Bool{
    let fetchRequest:NSFetchRequest<ShiftEntity> = ShiftEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "startTime == %@", id.asDate as NSDate)
    fetchRequest.fetchLimit = 1

    do {
      let result = try context.fetch(fetchRequest)
      return !result.isEmpty
    }catch{
      return false
    }
  }

  func addCoop(detail:CoopHistoryDetail) async{
    if await isExist(id: detail.id){
      return
    }

    let encoder = JSONEncoder()
    let entity = DetailEntity(context:context)
    entity.id = detail.id
    entity.time = detail.playedTime.asDate
    entity.detail = try? encoder.encode(detail)
    entity.stage = detail.coopStage.id
    entity.mode = "salmon_run"
    entity.rule = detail.rule.rawValue
    entity.stats = try? encoder.encode(getCoopStats(coop: detail))
    entity.weapon = try? encoder.encode(detail.myResult.weapons.map{$0.image?.url ?? ""})
    entity.player = try? encoder.encode(detail.memberResults.map{$0.player.id} + [detail.myResult.player.id])

    var waveLen: Int {detail.rule == .TEAM_CONTEST ? 5 : 3}

    await save()
  }

  func deleteDetail(count:Int) async{
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 设置排序
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    // 限制获取的结果数量
    fetchRequest.fetchLimit = count
    do {
      // 执行请求
      let results = try context.fetch(fetchRequest)

      // 遍历并删除每个对象
      for detail in results {
        context.delete(detail)
      }

      // 保存更改
      await save()
    } catch {
      print("Error deleting DetailEntity objects: \(error)")
    }
  }






  func queryDetail<T:Codable>(offset: Int, limit: Int, filter: FilterProps? = nil) async -> [T] {
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 设置排序
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    // 设置分页
    fetchRequest.fetchOffset = offset
    fetchRequest.fetchLimit = limit
    // 应用过滤条件
    if let filter = filter {
      fetchRequest.predicate = convertFilter(filter)
    }

    do {
      let results = try context.fetch(fetchRequest)
      let decoder = JSONDecoder()
      return results.compactMap{
        if let detail = $0.detail{
          return try? decoder.decode(T.self, from: detail)
        }
        return nil
      }
    } catch {
      print("查询错误: \(error)")
      return []
    }
  }

  func addShift(group:CoopHistoryGroup) async{
    if self.isShiftExist(id: group.startTime){
      return
    }
    let entity = ShiftEntity(context: context)
    entity.startTime = group.startTime.asDate
    entity.endTime = group.endTime.asDate
    entity.mode = group.mode.rawValue
    entity.rule = group.rule.rawValue
    entity.playCount = 0
    entity.goldenDeliver = 0
    entity.goldenAssist = 0
    entity.rescue = 0
    entity.wave = 0
    entity.rescued = 0
    await save()
  }
}



struct FilterProps {
  var modes: [String]?
  var rules: [String]?
  var stages: [String]?
  var weapons: [String]?
  var dateRange: [Date]?
  var inverted: Bool?
}

func convertFilter(_ filter: FilterProps) -> NSPredicate? {
  var predicates: [NSPredicate] = []

  if let modes = filter.modes, !modes.isEmpty {
    predicates.append(NSPredicate(format: "mode IN %@", modes))
  }
  if let rules = filter.rules, !rules.isEmpty {
    predicates.append(NSPredicate(format: "rule IN %@", rules))
  }
  if let stages = filter.stages, !stages.isEmpty {
    predicates.append(NSPredicate(format: "stage IN %@", stages))
  }

  if let dateRange = filter.dateRange, dateRange.count == 2 {
    let startDate = dateRange[0]
    let endDate = dateRange[1]
    predicates.append(NSPredicate(format: "(time >= %@) AND (time <= %@)", startDate as NSDate, endDate as NSDate))
  }

  // 武器逻辑可能需要根据你的具体需求进行调整
  if let weapons = filter.weapons, !weapons.isEmpty {
    // 此处只是一个基本示例，可能需要根据weaponList.weapons的结构进行调整
    let weaponPredicates = weapons.map { NSPredicate(format: "weapon == %@", $0) }
    predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: weaponPredicates))
  }

  if filter.inverted ?? false {
    return NSCompoundPredicate(notPredicateWithSubpredicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates))
  } else {
    return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
  }
}

struct ShiftInfo{
  var startTime:Date
  var endTime:Date
  var goldenAssist:Double
  var goldenDeliver:Double
  var normalDeliver:Double
  var rescue:Double
  var rescued:Double
  var wave:Double
  var weapons:[String]
  var stageId:String
  var rule:CoopRule
  var mode:CoopMode
  var playCount:Int
}



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

extension Array where Element == CoopPlayerStats {
  func sum() -> CoopPlayerStats {
    return self.reduce(CoopPlayerStats(defeat: 0, golden: 0, assist: 0, power: 0, rescue: 0, rescued: 0)) { $0 + $1 }
  }
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
