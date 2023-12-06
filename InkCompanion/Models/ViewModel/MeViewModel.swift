//
//  MeViewModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import Foundation

class MeViewModel:ObservableObject{
  @Published var isLoggedin:Bool = false

  init() {
    self.isLoggedin = InkUserDefaults.shared.sessionToken != nil
  }
}
