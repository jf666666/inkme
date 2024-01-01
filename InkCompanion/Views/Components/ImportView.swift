//
//  ImportView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/28/23.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftyJSON



func importJsonData(from url: URL)  {
  struct temp:Codable{
    struct temp1:Codable{
      let coopHistoryDetail:CoopHistoryDetail
    }
    struct temp2:Codable{
      let vsHistoryDetail:VsHistoryDetail
    }
    let coops:[temp1]
    let battles:[temp2]
  }
  Task{
    print("开始导入")
    do {
      let jsonData = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let data = try decoder.decode(temp.self, from: jsonData)
      for detail in data.coops{
        if  await !InkData.shared.isExist(id: detail.coopHistoryDetail.id){
          await InkData.shared.addCoop(detail: detail.coopHistoryDetail)
        }
      }
      for detail in data.battles{
        if  await !InkData.shared.isExist(id: detail.vsHistoryDetail.id){
          await InkData.shared.addBattle(detail: detail.vsHistoryDetail)
        }
      }
    } catch {
      print("Error reading or decoding JSON: \(error)")
    }
  }
}
