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
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var managedObjectContext // 使用环境中的managedObjectContext
    @State private var updateStatus: UpdateStatus = .none
    @State private var updating: Bool = false
    @State private var updateFailed: Bool = false
    @State private var updateSuccess: Bool = false
    var body: some View {
        ZStack {
            
            TabView(selection: $modelData.tab) {
                
                NavigationView {
                    SchedulesView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Label("schedule", systemImage: "calendar")
                }
                .tag(Tab.schedule)
                
                NavigationView {
                    ShiftsView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Label("shift", systemImage: "lifepreserver")
                }
                .tag(Tab.shift)
                
                NavigationView {
                    // 直接使用环境中的managedObjectContext
                    LoginView()
                        .environment(\.managedObjectContext, managedObjectContext)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("ikachan", systemImage: "info.circle")
                }
                .tag(Tab.about)
            }
//            GeometryReader { geometry in
//                VStack {
//                    Spacer().frame(height: geometry.safeAreaInsets.top)
//                    
//                    HStack {
//                        Spacer() // 这个 Spacer 会推动内部的内容到中心
//                        VStack {
//                            // 根据更新状态显示不同的通知
//                            if updateStatus == .updating {
//                                AlertToast(displayMode: .hud, type: .loading, title: "Updating")
//                            } else if updateStatus == .success {
//                                AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Update Successful!")
//                            } else if updateStatus == .failure {
//                                AlertToast(displayMode: .hud, type: .error(Color.red), title: "Update Failed")
//                            }
//                        }
//                        Spacer() // 这个 Spacer 也会推动内部的内容到中心
//                    }
//                }
//            }

     
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
        .onAppear{
            if shouldUpdate(){
                self.updating = true
                updateTokens { isUpdated in
                    if isUpdated {
                        self.updating = false
                        self.updateSuccess = true
                    } else {
                        self.updating = false
                        self.updateFailed = true
                    }
                    // 延迟一段时间后清除通知
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.updating = false
                        self.updateSuccess = false
                        self.updateFailed = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) 
    }
}
