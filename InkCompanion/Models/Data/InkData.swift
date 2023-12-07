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

  func save() async {
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
    if let currentUserKey = InkUserDefaults.shared.currentUserKey, let playerId = Int64(currentUserKey){
      entity.playerId = playerId
    }
    await save()
  }

  func addBattle(detail:VsHistoryDetail)async{
    if await isExist(id: detail.id){
      return
    }
    let encoder = JSONEncoder()
    let entity = DetailEntity(context:context)
    entity.id = detail.id
    entity.time = detail.playedTime.asDate
    entity.detail = try? encoder.encode(detail)
    entity.stage = detail.vsStage.id
    entity.mode = detail.vsMode.mode
    entity.rule = detail.vsRule.rule.rawValue
    entity.stats = try? encoder.encode(detail.status)
    entity.weapon = try? encoder.encode(detail.myTeam.players.filter{$0.isMyself}[0].weapon.id)
    entity.player = try? encoder.encode(detail.myTeam.players.map{$0.id}+detail.otherTeams.map{$0.players.map{$0.id}}.flatMap{$0})
    if let currentUserKey = InkUserDefaults.shared.currentUserKey, let playerId = Int64(currentUserKey){
      entity.playerId = playerId
    }

    await save()
  }

  func deleteDetail(count:Int) async{
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 设置排序
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    // 限制获取的结果数量
    fetchRequest.fetchLimit = count
    fetchRequest.predicate = convertFilter(FilterProps(modes: ["salmon_run"], inverted: true))
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
  
  func processOldData() async{

    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()
    do{
      let result = try context.fetch(fetchRequest)
      for detail in result{
        if let userKey = detail.id?.base64Decoded().userKey, userKey == "qaenpmwwot2cvyq3qpmm"{
          detail.playerId = 5366484838940672
          await save()
        }
        if let userKey = detail.id?.base64Decoded().userKey, userKey == "q4hxd36lzgos5xtmjtom"{
          detail.playerId = 4936207332311040
          await save()
        }

        if let userKey = detail.id?.base64Decoded().userKey, userKey == "acprc5gvph3wozi5zcum"{
          detail.playerId = 6578101926264832
          await save()
        }
      }
      print("done!!!!")
    }catch{
      
    }
  }

  func countDetailsMatchingFilter(filter: FilterProps?)  -> Int {
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 应用过滤条件
    if let filter = filter {
      fetchRequest.predicate = convertFilter(filter)
    }

    do {
      let count = try context.count(for: fetchRequest)
      return count
    } catch {
      print("计数错误: \(error)")
      return 0
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
          do{
            let data = try decoder.decode(T.self, from: detail)
            return data
          }catch let error as NSError{
            if let jsonString = String(data: detail, encoding: .utf8) {
              print("原始 JSON: \(jsonString)")
            }
            print("解码 \(String(describing: T.self)) 失败: \(error), \(error.userInfo)")
            return nil
          }
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
  if let userKey = InkUserDefaults.shared.currentUserKey, let playerId = Int64(userKey){
    predicates.append(NSPredicate(format: "playerId == %ld",playerId))
  }
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








