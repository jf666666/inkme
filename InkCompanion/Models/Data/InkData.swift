//
//  InkData.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/18/23.
//

import Foundation
import CoreData
import OSLog
import Combine

class InkData{
  static let shared = InkData()
  let logger = Logger(.custom(InkData.self))
  private init() {}
  private var cancellables = Set<AnyCancellable>()

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

  func coopStatus(accountId:Int64) ->[Judgement]{
    let fetchRequest = DetailEntity.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let filter = FilterProps(modes: ["salmon_run"],accountId: accountId)
    fetchRequest.predicate = convertFilter(filter)
    fetchRequest.fetchLimit = 500
    do{
      let results = try context.fetch(fetchRequest)
      return results.compactMap{
        if let stats = $0.stats?.decode(CoopStatus.self){
          if stats.exempt{
            return .DRAW
          }
          if stats.clear{
            return .WIN
          }
          return .LOSE
        }
        return nil
      }
    }catch{
      logger.error("InkData.\(#function) failed: \(error.localizedDescription)")
    }
    return []
  }

  func todayBattle(accountId: Int64) -> TodayBattle{
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()


    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: Date())
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

    let filter = FilterProps(modes: ["REGULAR","BANKARA","XMATCH","LEAGUE","PRIVATE"],dateRange:[startDate,endDate],accountId: accountId)
    fetchRequest.predicate = convertFilter(filter)
    do {
      let results = try context.fetch(fetchRequest)
      if results.isEmpty{
        return TodayBattle()
      }else{
        let statuses = results.compactMap { entity in
          entity.stats?.decode(BattleStatus.self)
        }
        let victory = statuses.filter{$0.win}.count
        let defeat = statuses.filter{$0.loss}.count
        let kill = statuses.map{$0.myself.kill}.sum()
        let assist = statuses.map{$0.myself.assist}.sum()
        let death = statuses.map{$0.myself.death}.sum()
        return TodayBattle(victoryCount: victory, defeatCount: defeat, killCount: kill, assistCount: assist, deathCount: death)
      }
    } catch {
      print("Error fetching data: \(error)")
      return TodayBattle()
    }
  }

  func todayCoop(accountId: Int64) -> TodayCoop {

    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()


    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: Date())
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

    let filter = FilterProps(modes: ["salmon_run"],dateRange:[startDate,endDate],accountId: accountId)
    fetchRequest.predicate = convertFilter(filter)
    do {
      let results = try context.fetch(fetchRequest)
      if results.isEmpty{
        return TodayCoop()
      }else{
        let statuses = results.compactMap { entity in
          entity.stats?.decode(CoopStatus.self)
        }
        let kill = statuses.map{$0.myself.defeat}.average()
        let egg = statuses.map{$0.myself.golden}.average()
        let clear = statuses.filter{$0.clear}.count
        let abort = statuses.filter{$0.exempt}.count
        let failure = statuses.count - clear - abort
        let rescue = statuses.map{$0.myself.rescue}.average()
        let rescued = statuses.map{$0.myself.rescued}.average()
        return TodayCoop(clear: clear, failure: failure, abort: abort, kill: kill, egg: egg, rescue: rescue, rescued: rescued)
      }
    } catch {
      print("Error fetching data: \(error)")
      return TodayCoop()
    }
  }
  
  func recentGroupCoop(accountId: Int64) -> TodayCoop {
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 设置排序，以便最新的记录排在前面
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    let filter = FilterProps(modes: ["salmon_run"], accountId: accountId)
    fetchRequest.predicate = convertFilter(filter)

    do {
      let fetchResults = try context.fetch(fetchRequest)

      // 检查是否有数据
      guard !fetchResults.isEmpty else { return TodayCoop() }

      var recentGroup: [DetailEntity] = []
      for (index, detail) in fetchResults.enumerated() {
        // 将第一个记录加入最近一轮
        if index == 0 {
          recentGroup.append(detail)
          continue
        }

        // 检查是否属于同一轮
        let previousDetail = fetchResults[index - 1]
        if self.coopCanGroup(current: previousDetail, new: detail) {
          recentGroup.append(detail)
        } else {
          break // 遇到不同轮次，停止添加
        }
      }
      let statuses = recentGroup.compactMap{
        entity in
          entity.stats?.decode(CoopStatus.self)
      }
      let kill = statuses.map{$0.myself.defeat}.average()
      let egg = statuses.map{$0.myself.golden}.average()
      let clear = statuses.filter{$0.clear}.count
      let abort = statuses.filter{$0.exempt}.count
      let failure = statuses.count - clear - abort
      let rescue = statuses.map{$0.myself.rescue}.average()
      let rescued = statuses.map{$0.myself.rescued}.average()
      return TodayCoop(clear: clear, failure: failure, abort: abort, kill: kill, egg: egg, rescue: rescue, rescued: rescued)

    } catch {
      print("查询错误: \(error)")
      return TodayCoop()
    }
  }

  private func coopCanGroup(current detail: DetailEntity,new:DetailEntity)->Bool{
//    return detail.rule == new.rule && detail.stage == new.coopStage.id && detail.weapons.map{$0.image?.url ?? ""}.joined(separator: ",") == new.weapons.map{$0.image?.url ?? ""}.joined(separator: ",")
    return detail.stage == new.stage && detail.rule == new.rule
  }

  func battleStatus(accountId:Int64) ->[Judgement]{
    let fetchRequest = DetailEntity.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let filter = FilterProps(modes: ["REGULAR","BANKARA","XMATCH","LEAGUE","PRIVATE"],accountId: accountId)
    fetchRequest.predicate = convertFilter(filter)
    fetchRequest.fetchLimit = 500
    do{
      let results = try context.fetch(fetchRequest)
      return results.compactMap{
        if let stats = $0.stats?.decode(BattleStatus.self){
          if stats.exempt{
            return .DRAW
          }
          if stats.win{
            return .WIN
          }
          return .LOSE
        }
        return nil
      }
    }catch{
      logger.error("InkData.\(#function) failed: \(error.localizedDescription)")
    }
    return []
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
    fetchRequest.predicate = convertFilter(FilterProps(modes: ["salmon_run"], accountId: Int64(InkUserDefaults.shared.currentUserKey ?? "")))
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
        if detail.id!.base64Decoded().hasPrefix("Vs"){
          detail.stats = detail.detail?.decode(VsHistoryDetail.self)?.status.encode()
        }else{
          detail.stats = detail.detail?.decode(CoopHistoryDetail.self)?.status.encode()
        }
        await save()
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

  func queryDetailGroup<T: Codable>(totalGroup:Int, offset:Int = 0, filter: FilterProps? = nil, canGroup: @escaping (T, T) -> Bool) async -> [[T]] {
    var groups: [[T]] = []
    var currentGroup: [T] = []
    var offset = offset
    let limit = 30
    var keepFetching = true

    while keepFetching {
      let details: [T] = await queryDetail(offset: offset, limit: limit, filter: filter)

      // 如果没有更多的数据，停止获取
      if details.isEmpty  {
        keepFetching = false
        continue
      }

      for detail in details {
        // 检查是否应该开始新的组
        if let last = currentGroup.last, !canGroup(last, detail) {
          // 当前元素不符合分组条件，开始新的组
          groups.append(currentGroup)
          if groups.count >= totalGroup{
            keepFetching = false
            break
          }
          currentGroup = [detail]
        } else {
          // 当前元素符合分组条件，加入当前组
          currentGroup.append(detail)
        }
      }
      offset += limit
    }

    // 添加最后一组（如果存在）
    if !currentGroup.isEmpty {
      groups.append(currentGroup)
    }

    return groups
  }


  func queryDetail<T:Codable>(offset: Int, limit: Int, filter: FilterProps? = nil) async -> [T] {
    let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

    // 设置排序
    let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]


    // 应用过滤条件
    if var filter = filter {
      if let userKey = InkUserDefaults.shared.currentUserKey, let userID = Int64(userKey){
        filter.accountId = userID
      }
      fetchRequest.predicate = convertFilter(filter)
    }
    // 设置分页
    fetchRequest.fetchOffset = offset
    fetchRequest.fetchLimit = limit

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


  func queryDetail<T: Codable>(offset: Int, limit: Int, filter: FilterProps? = nil) -> AnyPublisher<[T], Error> {
    Deferred {
      Future<[T], Error> { promise in
        let fetchRequest: NSFetchRequest<DetailEntity> = DetailEntity.fetchRequest()

        // 设置排序
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // 应用过滤条件
        if var filter = filter {
          if let userKey = InkUserDefaults.shared.currentUserKey, let userID = Int64(userKey) {
            filter.accountId = userID
          }
          fetchRequest.predicate = convertFilter(filter)
        }
        // 设置分页
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit

        do {
          let results = try self.context.fetch(fetchRequest)
          let decoder = JSONDecoder()
          let decodedResults = results.compactMap { entity -> T? in
            guard let detail = entity.detail else { return nil }
            return try? decoder.decode(T.self, from: detail)
          }
          promise(.success(decodedResults))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
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
  var accountId:Int64?
}

func convertFilter(_ filter: FilterProps) -> NSPredicate? {
  var predicates: [NSPredicate] = []
  //  if let userKey = InkUserDefaults.shared.currentUserKey, let playerId = Int64(userKey){
  //    predicates.append(NSPredicate(format: "playerId == %ld",playerId))
  //  }


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
    predicates.append(NSPredicate(format: "(time >= %@) AND (time < %@)", startDate as NSDate, endDate as NSDate))
  }

  // 武器逻辑可能需要根据你的具体需求进行调整
  if let weapons = filter.weapons, !weapons.isEmpty {
    // 此处只是一个基本示例，可能需要根据weaponList.weapons的结构进行调整
    let weaponPredicates = weapons.map { NSPredicate(format: "weapon == %@", $0) }
    predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: weaponPredicates))
  }

  if filter.inverted ?? false {
    if let accountId = filter.accountId{
      predicates.append(NSPredicate(format: "playerId != %ld", accountId))
    }
    return NSCompoundPredicate(notPredicateWithSubpredicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates))
  } else {
    if let accountId = filter.accountId{
      predicates.append(NSPredicate(format: "playerId == %ld", accountId))
    }
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








