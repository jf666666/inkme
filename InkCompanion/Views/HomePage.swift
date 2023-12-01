//
//  HomePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/30/23.
//

import SwiftUI

struct HomePage: View {
  @EnvironmentObject var viewModel: HomeViewModel
  @State var mod:BankaraMatchMode = .CHALLENGE
    var body: some View {
      NavigationStack {
        DetailScrollView{
          VStack{
            VStack{}
              .textureBackground(texture: .bubble, radius: 18)
              .frame(height: 300)
            VStack(spacing:0){
              Text("日程")
                .inkFont(.font1, size: 22, relativeTo: .body)
                .frame(maxWidth: .infinity, alignment: .leading)
              Picker("", selection: $viewModel.currentMode) {
                if viewModel.shouldShowFestival(){
                  ScheduleMode.fest.icon
                    .tag(ScheduleMode.fest)
                }
                ForEach(ScheduleMode.allCases.filter{$0 != .fest}){ mode in
                  mode.icon
                    .tag(mode)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
              .frame(width: 200)
              .padding(.top)
              subModePicker
              
              ScheduleView()
                .padding(.top)

            }
          }
        }
        .navigationBarTitle("Home", displayMode: .inline)
        .task {
          await viewModel.loadSchedules()
        }
        .refreshable {
          await viewModel.loadSchedules()
      }
      }
    }

  var subModePicker: some View{
    VStack{
      if viewModel.currentMode == .anarchy{
        Picker("", selection: $viewModel.anarchyMode) {
          ForEach(BankaraMatchMode.allCases,id:\.rawValue){ mode in
            Text(mode.name)
              .tag(mode)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 80)
        .padding(.top,5)
      }
      if viewModel.currentMode == .fest{
        Picker("", selection: $viewModel.festMode) {
          ForEach(FestMatchMode.allCases,id:\.rawValue){ mode in
            Text(mode.name)
              .tag(mode) 
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 80)
        .padding(.top,5)
      }
    }
  }
}

#Preview {
    HomePage()
    .environmentObject(HomeViewModel())
}
