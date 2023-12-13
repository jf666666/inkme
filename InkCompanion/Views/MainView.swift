//
//  ContentView.swift
//  hailuowan
//
//  Created by 姜锋 on 10/29/23.
//

import SwiftUI
import SwiftData
import AlertToast
import IndicatorsKit


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



  var body: some View {

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
