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



//struct CoopHistoryDetail: Codable,Equatable,Identifiable,Hashable {
//    let playedTime: String
//    let dangerRate: Double
//}

//extension String {
//  var asDate:Date{
//      utcToDate(date: self) ?? Date()
//  }
//}

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

extension Array where Element == Int {
  func sum()->Int{
    var num = 0
    for i in self{
      num += i
    }
    return num
  }
}
