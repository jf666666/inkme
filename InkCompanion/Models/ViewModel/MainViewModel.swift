//
//  MainViewModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/8/23.
//

import Foundation

class MainViewModel:ObservableObject{
  
  
  @Published var isUpdateToken:Bool = false
  @Published var updateTokenFailed:Bool = false
  @Published var updateTokenSuccess:Bool = false
}
