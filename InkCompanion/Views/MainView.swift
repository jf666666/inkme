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

  @EnvironmentObject var accountViewModel:AccountViewModel
  @Environment(\.loadingHandler) private var loadingHandler
  @Environment(\.errorHandler) private var errorHandler
  @Environment(\.informationHandler) private var informationHandler
  @EnvironmentObject var indicators:Indicators
  @EnvironmentObject var viewModel: HomeViewModel

  @AppStorage("mainViewTabSelection")
  var tabSelection:Int = 0

  var body: some View {

    TabView(selection:$tabSelection){
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
      .task {
        await accountViewModel.loadAccount()
        await update()
      }


  }

  func update() async {

    if accountViewModel.shouldUpdate(){
      var id:String = ""
      loadingHandler("正在更新令牌"){ indicatorId in
        id = indicatorId
      }
      do{
        var bullet:String?
        try await accountViewModel.updateCurrentAccount { b in
          bullet = b
        }
        let infoId = "\(UUID().uuidString)"
        let indicator = Indicator(id: infoId, icon: "checkmark", headline: "更新成功",expandedText: bullet == nil ? nil : "Bullet Token: \(bullet ?? ""))", dismissType: .after(3), style: .init(iconColor:.green)) {
          if let bullet = bullet{
            indicators.dismiss(matching: infoId)
            UIPasteboard.general.string = bullet
            indicators.display(Indicator(id: "\(UUID().uuidString)",
                                         icon: SFSymbol.copy,
                                         headline: "Bullet Token Copied",
                                         style: .default))
          }
        }
        informationHandler(indicator)
      }catch{
        errorHandler(error)
      }
      indicators.dismiss(matching: id)
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
