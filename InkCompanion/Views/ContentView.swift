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


struct ContentView: View {

  @State private var updateStatus: UpdateStatus = .none
  @State private var updating: Bool = false
  @State private var updateFailed: Bool = false
  @State private var updateSuccess: Bool = false
  @EnvironmentObject var homeViewModel: HomeViewModel
  @EnvironmentObject var accountViewModel:AccountViewModel

  //  @AppStorage("content_tab_selection") var selectedTab:Int = 0

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
    .toast(isPresenting: self.$updating, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .loading, title: "Updating")
    }
    .toast(isPresenting: self.$updateSuccess, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Update Successful!")
    }
    .toast(isPresenting: self.$updateFailed, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .error(Color.red), title: "Update Failed")
    }
    .task{
      await accountViewModel.loadAccount()
      if accountViewModel.shouldUpdate(){
        self.updating = true
        do{
          try await InkNet.NintendoService().updateTokens()
          accountViewModel.selectedAccount?.lastRefreshTime = Date.now
          self.updating = false
          self.updateSuccess = true
        }catch{
          self.updating = false
          self.updateFailed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.updating = false
          self.updateSuccess = false
          self.updateFailed = false
        }
      }
      await homeViewModel.loadSchedules()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    @StateObject var timePublisher: TimePublisher = .shared
    @StateObject var coopModel = CoopModel()
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var battleModel = BattleModel()
    @StateObject var accountViewModel = AccountViewModel()
    ContentView()
      .environmentObject(timePublisher)
      .environmentObject(coopModel)
      .environmentObject(homeViewModel)
      .environmentObject(battleModel)
      .environmentObject(accountViewModel)
  }
}
