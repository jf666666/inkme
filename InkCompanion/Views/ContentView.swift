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
  var body: some View {
    ZStack {

      TabView {

        NavigationView {
          BattleRotationTab()
//          ImportView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
          Label("schedule", systemImage: "calendar")
        }
        .tag(0)



        CoopHistoryList()
          .navigationViewStyle(StackNavigationViewStyle())
          .tabItem {
            Label("shift", systemImage: "lifepreserver")
          }
          .tag(1)

        NavigationView {
          LoginView()
        }
        .navigationViewStyle(.stack)
        .tabItem {
          Label("ikachan", systemImage: "info.circle")

        }
        .tag(2)
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
      if shouldUpdate(){
        self.updating = true
        do{
          try await InkNet.NintendoService().updateTokens()
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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
