//
//  AccountViewModel.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/7/23.
//

import Foundation

class AccountViewModel:ObservableObject{
  let inkData = InkData.shared
  let inkNet = InkNet.shared
  let nintendo = InkNet.NintendoService()
  let inkUserDefaults = InkUserDefaults.shared
  @Published var accounts:[InkAccount] = []
  @Published var selectedAccount:InkAccount?

//  init() {
//    Task{
//      await self.accounts = inkData.getAllAccounts()
//      self.selectedAccount = self.accounts.first(where: {$0.sessionToken == inkUserDefaults.sessionToken})
//    }
//  }

  func loadAccount() async{
    let aaccounts = await inkData.getAllAccounts()
    DispatchQueue.main.async {
      self.accounts = aaccounts
      self.selectedAccount = self.accounts.first(where: {$0.sessionToken == self.inkUserDefaults.sessionToken})
    }
  }

  func addAccount(sessionToken:String) async{
    if let (account, web, bullet) = await nintendo.loginWithSessionToken(sessionToken: sessionToken){
      await inkData.addAccount(account: account)
      DispatchQueue.main.async {
        self.accounts.append(account)
        self.inkUserDefaults.sessionToken = sessionToken
        self.inkUserDefaults.webServiceToken = web.encode()
        self.inkUserDefaults.bulletToken = bullet
      }

    }
  }

  func shouldUpdate()->Bool{
    guard let lastUpdate = selectedAccount?.lastRefreshTime else {return true}
    let currentTime = Date()
    let updateInterval = 1 * 60 * 60 // 1小时

    if currentTime.timeIntervalSince(lastUpdate) > TimeInterval(updateInterval) {
      return true
    }
    return false
  }

}
