//
//  MePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import SwiftUI
import Kingfisher
import IndicatorsKit

struct MePage: View {
  @StateObject var model:MeViewModel = MeViewModel()
  @State var showSettings = false
  @ObservedObject var inkUserDefaults = InkUserDefaults.shared
  @EnvironmentObject var accountViewModel:AccountViewModel
  @Environment(\.errorHandler) private var errorHandler
  @Environment(\.loadingHandler) private var loadingHandler
  @EnvironmentObject var indicators:Indicators
  @State var id:String = ""

  var body: some View {

    NavigationStack {
      List{
        NavigationLink("鲑鱼跑记录", destination: SalmonRunStatsPage())
    
      }
      .navigationTitle("我")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: settingButton)
    }
    .sheet(isPresented: $showSettings, content: {
      SettingView(showSettings:$showSettings)
  })
  }

  var settingButton:some View{
    Button(action: {
      showSettings = true
    }) {
      HStack {
        Spacer()

        Image(systemName: "gear")
          .frame(width: 22, height: 22)
      }
      .frame(width: 38, height: 40)
    }
  }

  var playerInformation:some View{
    HStack{

    }
  }
}

#Preview {
  MePage()
}
