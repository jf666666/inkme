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
  let indicators = SceneDelegate.indicators

  @Published var changingAccount:Bool = false
  @Published var changingAccountFailed:Bool = false
  @Published var changingAccountSuccess:Bool = false

  @Published var accounts:[InkAccount] = []
  @Published var selectedAccount:Int = 0



  func loadAccount() async{
    let aaccounts = await inkData.getAllAccounts()
    DispatchQueue.main.async {
      self.accounts = aaccounts
      self.selectedAccount = self.accounts.firstIndex(where: {$0.sessionToken == self.inkUserDefaults.sessionToken}) ?? 0
    }
  }
  
  func changeAccount(to index: Int) {
      guard self.selectedAccount != index else {
          return
      }

      let player = self.accounts[index]
      self.selectedAccount = index
      self.changingAccount = true
      inkNet.bulletToken = player.bulletToken
      inkNet.webServiceToken = player.webServiceToken


      self.inkUserDefaults.sessionToken = player.sessionToken
      self.inkUserDefaults.webServiceToken = player.webServiceToken.encode()
      self.inkUserDefaults.bulletToken = player.bulletToken
      self.inkUserDefaults.currentUserKey = String(player.id)


      if self.shouldUpdate() {
          Task {
              do {
                  try await updateCurrentAccount() { bullet in
                      if let bullet {
                          print(bullet, terminator: "!")
                      }
                  }
                  DispatchQueue.main.async { [weak self] in
                      self?.changingAccountSuccess = true
                      self?.changingAccount = false
                  }
              } catch {
                  DispatchQueue.main.async { [weak self] in
                      self?.indicators.display(.init(error: error))
                      self?.changingAccount = false
                  }
              }
          }
      } else {
          self.changingAccount = false
      }
  }

  
  func updateCurrentAccount(bullet:(String?)->Void) async throws{
    do{
      let (w, b) = try await nintendo.updateTokens()

      if let w = w{
        self.inkNet.webServiceToken = w
        DispatchQueue.main.async {
          self.inkUserDefaults.webServiceToken = w.encode()
          self.accounts[self.selectedAccount].webServiceToken = w
        }
      }

      if let b = b{
        inkNet.bulletToken = b

        DispatchQueue.main.async {
          self.inkUserDefaults.bulletToken = b
          self.accounts[self.selectedAccount].bulletToken = b
          self.accounts[self.selectedAccount].lastRefreshTime = Date.now
        }

        await updateAccountInCoreData()
        bullet(b)
      }
    }catch{
      throw error
    }

  }

  func updateAccountInCoreData() async {
    let account = self.accounts[self.selectedAccount]
    await inkData.updateAccount(account: account)
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
    if self.accounts.count == 0 {
      return false
    }
    let lastUpdate = self.accounts[self.selectedAccount].lastRefreshTime
    let currentTime = Date()
    let updateInterval = 1 

    if currentTime.timeIntervalSince(lastUpdate) > TimeInterval(updateInterval) {
      return true
    }
    return false
  }

}
