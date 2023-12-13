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
      ScrollView{
        VStack{
          VStack{
            Button {
              loadingHandler("测试"){id in
                print(id)
                self.id = id
              }
            } label: {
              Label(
                title: { Text("测试") },
                icon: { Image(systemName: "checkmark") }
              )
            }

            Button {
              indicators.dismiss(matching: id)
            } label: {
              Label(
                title: { Text("取消") },
                icon: { Image(systemName: "xmark") }
              )
            }

            if !accountViewModel.accounts.isEmpty{
              Text("有\(accountViewModel.accounts.count)个账号已登陆")
            
            }


          }
          .modifier(LoginViewModifier(isLogined: model.isLoggedin))
          if let sessionToken = inkUserDefaults.sessionToken{
            Text(sessionToken)
          }
        }
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
