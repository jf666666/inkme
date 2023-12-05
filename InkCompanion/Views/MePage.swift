//
//  MePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import SwiftUI

struct MePage: View {
  @StateObject var model:MeViewModel = MeViewModel()
  @State var showSettings = false
  var body: some View {

    NavigationStack {
      ScrollView{
        VStack{
          HStack{
            Text("hello world")

          }
          .modifier(LoginViewModifier(isLogined: model.isLoggedin))
          if let sessionToken = AppUserDefaults.shared.sessionToken{
            Text(sessionToken)
          }
        }
      }
      .navigationBarTitle("我",displayMode: .inline)
      .navigationBarItems(trailing: settingButton)

    }
    .sheet(isPresented: $showSettings, content: {
      EmptyView()
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
}

#Preview {
  MePage()
}
