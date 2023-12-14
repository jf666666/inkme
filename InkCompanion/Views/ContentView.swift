//
//  ContentView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/13/23.
//

import SwiftUI
import IndicatorsKit

struct ContentView: View {
  @EnvironmentObject var homeViewModel: HomeViewModel
  @EnvironmentObject var accountViewModel:AccountViewModel
  @EnvironmentObject var mainViewModel:MainViewModel
  @EnvironmentObject private var sceneDelegate: SceneDelegate
  var body: some View {
    ZStack{
      MainView()
    }
    .overlay(alignment: .top, content: {
      IndicatorsOverlay(model: SceneDelegate.indicators)
    })
    .environment(\.errorHandler, .init(sceneDelegate.handleError))
    .environment(\.loadingHandler, .init(sceneDelegate.handleLoading))
    .environment(\.showIndicator, sceneDelegate.showIndicator)
    .environment(\.informationHandler, .init(sceneDelegate.handleInformation))
    .environmentObject(SceneDelegate.indicators)
    .task{
      InkNet.shared.sessionToken = InkUserDefaults.shared.sessionToken
      InkNet.shared.bulletToken = InkUserDefaults.shared.bulletToken
      InkNet.shared.webServiceToken = InkUserDefaults.shared.webServiceToken?.decode(WebServiceTokenStruct.self)
      await homeViewModel.loadSchedules()

    }
  }
}

#Preview {
  ContentView()
}
