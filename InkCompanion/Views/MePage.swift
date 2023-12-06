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
  var body: some View {

    NavigationStack {
      ScrollView{
        VStack{
          VStack{
            if let inkPlayers = InkUserDefaults.shared.inkPlayers?.decode(InkPlayers.self)?.inkPlayers{
              Text("有\(inkPlayers.count)个账号已登陆")
              ForEach(0..<inkPlayers.count,id:\.self){ idx in
                KFImage(URL(string: inkPlayers[idx].avatarUrl))
                Text(inkPlayers[idx].name)
                Text("SW-\(inkPlayers[idx].friendCode)")
                Text(inkPlayers[idx].sessionToken)

              }
            }

          }
          .modifier(LoginViewModifier(isLogined: model.isLoggedin))
          if let sessionToken = InkUserDefaults.shared.sessionToken{
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
