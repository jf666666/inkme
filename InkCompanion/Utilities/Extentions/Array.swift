//
//  Array.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/24/23.
//

import Foundation

extension Array where Element: BinaryInteger {
    func average() -> Double {
        guard !isEmpty else { return 0.0 }
        let sum = self.reduce(0, +)
        return Double(sum) / Double(count)
    }
}



extension Array where Element == CoopHistoryDetail {
    mutating func insert<S>(contentsOf newElements: S) where S: Collection, CoopHistoryDetail == S.Element {
        // 遍历新元素
        for newElement in newElements {
            // 找到正确的插入位置
            if let insertIndex = self.firstIndex(where: { $0.playedTime.asDate < newElement.playedTime.asDate }) {
                self.insert(newElement, at: insertIndex)
            } else {
                // 如果没有找到合适的位置，则添加到数组末尾
                self.append(newElement)
            }
        }
    }
}

extension Array where Element == VsHistoryDetail {
    mutating func insert<S>(contentsOf newElements: S) where S: Collection, VsHistoryDetail == S.Element {
        // 遍历新元素
        for newElement in newElements {
            // 找到正确的插入位置
            if let insertIndex = self.firstIndex(where: { $0.playedTime.asDate < newElement.playedTime.asDate }) {
                self.insert(newElement, at: insertIndex)
            } else {
                // 如果没有找到合适的位置，则添加到数组末尾
                self.append(newElement)
            }
        }
    }
}

extension Array where Element == CoopPlayerStats {
  func sum() -> CoopPlayerStats {
    return self.reduce(CoopPlayerStats(defeat: 0, golden: 0, assist: 0, power: 0, rescue: 0, rescued: 0)) { $0 + $1 }
  }
}

extension Array where Element == BattlePlayerStats{
  func sum() ->BattlePlayerStats{
    return self.reduce(BattlePlayerStats(turf: 0, kill: 0, assist: 0, death: 0, special: 0)){
      $0 + $1
    }
  }
}

extension Array where Element == Int {
  func sum()->Int{
    var num = 0
    for i in self{
      num += i
    }
    return num
  }
}

extension Array where Element == Double {
  func sum()->Double{
    var num = 0.0
    for i in self{
      num += i
    }
    return num
  }
}

extension Array where Element == BossSalmonidStats {
    func sum() -> [BossSalmonidStats] {
        var dict = [String: BossSalmonidStats]()

        for boss in self {
            if let existingBoss = dict[boss.id] {
                let newBoss = BossSalmonidStats(
                    id: boss.id,
                    appear: existingBoss.appear + boss.appear,
                    defeat: existingBoss.defeat + boss.defeat,
                    defeatTeam: existingBoss.defeatTeam + boss.defeatTeam
                )
                dict[boss.id] = newBoss
            } else {
                dict[boss.id] = boss
            }
        }

      return Array(dict.values).sorted { $0.id.base64Index < $1.id.base64Index }
    }
}

extension Array where Element == CoopStatus.King{

  func sum() -> [CoopsStatus.King] {
    var dict = [String:CoopsStatus.King]()
    for king in self{
      if let existingKing = dict[king.id]{
        let newKing = CoopsStatus.King(
          id: king.id,
          appear: existingKing.appear + 1,
          defeat: existingKing.defeat + (king.defeat ? 1 : 0)
        )
        dict[king.id] = newKing
      }else{
        dict[king.id] = CoopsStatus.King(
          id: king.id,
          appear: 1,
          defeat: king.defeat ? 1 : 0
        )
      }
    }
    let array = Array<CoopsStatus.King>(dict.values)
    return array.sorted{ $0.id.base64Index < $1.id.base64Index }
  }

}

extension Array where Element: Summable{
  func sum() -> Element {
          return self.reduce(Element.zero, +)
  }
}


extension Array where Element == WaveStats{

  func sum() -> [WaveStats]{
    var dict = [String: WaveStats]()

    for wave in self {
        if let existingWave = dict[wave.id] {
          let newWave = WaveStats(id: wave.id, levels: (existingWave.levels+wave.levels).sum())
            dict[wave.id] = newWave
        } else {
            dict[wave.id] = wave
        }
    }
    
    return Array(dict.values).sorted {
      if $0.id == "-" {
        return false
      }
      if $1.id == "-"{
        return true
      }
      if $0.id.hasPrefix("Q29vcEVu") && !$1.id.hasPrefix("Q29vcEVu"){
        return true
      }
      if !$0.id.hasPrefix("Q29vcEVu") && $1.id.hasPrefix("Q29vcEVu"){
        return false
      }
      return $0.id.base64Index < $1.id.base64Index
    }
  }

}


extension Array where Element == WaveStats.Level{
  func sum() -> [WaveStats.Level]{
    var dict = [Int: WaveStats.Level]()

    for wave in self {
        if let existingWave = dict[wave.id] {
          let newWave = WaveStats.Level(id: wave.id, appear: wave.appear + existingWave.appear, clear: wave.clear+existingWave.clear)
            dict[wave.id] = newWave
        } else {
            dict[wave.id] = wave
        }
    }
    return Array(dict.values).sorted { $0.id < $1.id }
  }
}

extension Array where Element == String{
  func countWeapons() -> [CoopsStatus.Weapon] {
      var counts = [String: Int]()
      for string in self {
          counts[string, default: 0] += 1
      }
    return counts.map { CoopsStatus.Weapon(id: $0.key, count: $0.value) }
  }

  func countSpecialWeapons() -> [CoopsStatus.SpecialWeapon]{
    var counts = [String: Int]()
    for string in self {
        counts[string, default: 0] += 1
    }
  return counts.map { CoopsStatus.SpecialWeapon(id: $0.key, count: $0.value) }
}
}

extension Array where Element == [CoopHistoryDetail] {
  mutating func insert(_ detail: CoopHistoryDetail, coopCanGroup: (CoopHistoryDetail, CoopHistoryDetail) -> Bool) {
    // 检查是否有现有的组可以加入
    for (groupIndex, group) in self.enumerated() {
      if let lastItem = group.last, coopCanGroup(lastItem, detail) {
        // 找到可以加入的组，现在找到在该组内的正确位置
        let insertIndex = group.firstIndex(where: { $0.playedTime.asDate < detail.playedTime.asDate }) ?? group.count
        self[groupIndex].insert(detail, at: insertIndex)
        return
      }
    }

    // 如果不能加入任何现有组，需要找到整个二维数组中正确的位置插入新组
    let insertGroupIndex = self.firstIndex(where: { $0.first?.playedTime.asDate ?? Date.distantPast < detail.playedTime.asDate }) ?? self.count
    self.insert([detail], at: insertGroupIndex)
  }
}

