//
//  MePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import SwiftUI
import Kingfisher

struct MePage: View {
  @StateObject var model:MeViewModel = MeViewModel()
  @State var showSettings = false
  @ObservedObject var inkUserDefaults = InkUserDefaults.shared
  @EnvironmentObject var accountViewModel:AccountViewModel
  var body: some View {

    NavigationStack {
      ScrollView{
        VStack{
          VStack{
            if !accountViewModel.accounts.isEmpty{
              Text("有\(accountViewModel.accounts.count)个账号已登陆")
              ForEach(accountViewModel.accounts){ account in
                KFImage(URL(string: account.avatarUrl))
                Text(account.name)
                Text("SW-\(account.friendCode)")
                //                Text(inkPlayers[idx].sessionToken)
                Text("\(account.id)")
              }
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
