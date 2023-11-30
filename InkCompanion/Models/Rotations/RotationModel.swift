//
//  RotationModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/16/23.
//

import Foundation


final class RotationModel:ObservableObject{
  @Published var mode:BattleMode = .regular
//  static let shared:RotationModel = .init()
  @Published var battleRotationDict = BattleRotationDict()
  private var inkNet = InkNet.shared
  
//  private init() {}

//  private(set) var battleRotationDict = BattleRotationDict()

  func loadData() async {
    let data = await self.inkNet.fetchSchedule()
    DispatchQueue.main.async {
      self.battleRotationDict[.regular] = (data?.data.regularSchedules?.nodes ?? []).compactMap{ $0.toRotation()}
      self.battleRotationDict[.anarchy(.CHALLENGE)] = (data?.data.bankaraSchedules?.nodes ?? []).compactMap{ $0.toRotation(for: .CHALLENGE)}
      self.battleRotationDict[.anarchy(.OPEN)] = (data?.data.bankaraSchedules?.nodes ?? []).compactMap{ $0.toRotation(for: .OPEN)}
//      battleRotationDict[.event] = (data?.data.eventSchedules?.nodes ?? []).map{ $0.toRotation()!}
      self.battleRotationDict[.x] = (data?.data.xSchedules?.nodes ?? []).compactMap{ $0.toRotation()}
      self.battleRotationDict[.fest(.challenge)] = (data?.data.festSchedules?.nodes ?? []).compactMap{ $0.toRotation(for: .challenge)}
      self.battleRotationDict[.fest(.regular)] = (data?.data.festSchedules?.nodes ?? []).compactMap{ $0.toRotation(for: .regular)}
    }
  }
}
