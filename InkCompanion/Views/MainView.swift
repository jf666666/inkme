//
//  ContentView.swift
//  hailuowan
//
//  Created by 姜锋 on 10/29/23.
//

import SwiftUI
import SwiftData
import AlertToast


enum UpdateStatus {
  case none
  case updating
  case success
  case failure
}


struct MainView: View {

  @State private var updateStatus: UpdateStatus = .none
  @State private var updating: Bool = false
  @State private var updateFailed: Bool = false
  @State private var updateSuccess: Bool = false
  @EnvironmentObject var homeViewModel: HomeViewModel
  @EnvironmentObject var accountViewModel:AccountViewModel
  @EnvironmentObject var mainViewModel:MainViewModel

  var body: some View {
    ZStack {
      TabView{
        HomePage()
          .tabItem {
            Label("主页", image: "TabBarHome")
          }
          .tag(0)

        BattleView()
          .tabItem {
            Label("对战", image: "TabBarBattle")
          }
          .tag(1)


        CoopView()
          .tabItem {
            Label("鲑鱼跑", image: "TabBarSalmonRun")
          }
          .tag(2)


        MePage()
          .tabItem {
            Label("我", image: "TabBarMe")
          }
          .tag(3)
      }
    }
    .toast(isPresenting: $mainViewModel.isUpdateToken, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .loading, title: "更新令牌")
    }
    .toast(isPresenting: $mainViewModel.updateTokenSuccess,duration: 3,  tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .complete(Color.green), title: "更新成功")
    }
    .toast(isPresenting: $mainViewModel.updateTokenFailed, duration: 3, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .error(.red), title: "更新失败")
    }
    .task{
      InkNet.shared.sessionToken = InkUserDefaults.shared.sessionToken
      InkNet.shared.bulletToken = InkUserDefaults.shared.bulletToken
      InkNet.shared.webServiceToken = InkUserDefaults.shared.webServiceToken?.decode(WebServiceTokenStruct.self)
      await homeViewModel.loadSchedules()
      await accountViewModel.loadAccount()
      await update()
    }
  }


  func update() async {
    if accountViewModel.shouldUpdate(){
      mainViewModel.isUpdateToken = true
      do{
        let (web,bullet) = try await InkNet.nintendo.updateTokens()
        if let web = web{
          InkNet.shared.webServiceToken = web
        }
        if let bullet = bullet{
          InkNet.shared.bulletToken = bullet
        }
        accountViewModel.selectedAccount?.lastRefreshTime = Date.now
        await accountViewModel.updateAccountInCoreData()
        mainViewModel.updateTokenSuccess = true
      }catch{
        mainViewModel.updateTokenFailed = true
      }
      mainViewModel.isUpdateToken = false
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    @StateObject var timePublisher: TimePublisher = .shared
    @StateObject var coopModel = CoopModel()
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var battleModel = BattleModel()
    @StateObject var accountViewModel = AccountViewModel()
    @StateObject var mainViewModel = MainViewModel()
    MainView()
      .environmentObject(timePublisher)
      .environmentObject(coopModel)
      .environmentObject(homeViewModel)
      .environmentObject(battleModel)
      .environmentObject(accountViewModel)
      .environmentObject(mainViewModel)
  }
}
