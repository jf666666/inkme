//
//  InkAccountManager.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/7/23.
//

import Foundation

class InkAccountManager:ObservableObject{
  static let shared = InkAccountManager()
  private init() {}
  let inkData = InkData.shared

  
}
