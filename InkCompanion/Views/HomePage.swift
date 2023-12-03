//
//  HomePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/30/23.
//

import SwiftUI

struct HomePage: View {
  @EnvironmentObject var viewModel: HomeViewModel
  var body: some View {
    ScrollView{
      VStack(alignment: .center,spacing: 20){
        EmptyView()
          .textureBackground(texture: .streak, radius: 18)
          .frame(height: 200)
        VStack(spacing:5){
          scheduleTitle
          modePicker
          subModePicker
          if viewModel.currentMode != .salmonRun{
            ScheduleView()
          }else{
            ShiftView()
          }

        }

      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal,15)
    }

    .navigationBarTitle("Home", displayMode: .inline)
    .frame(maxWidth: .infinity)
    .fixSafeareaBackground()
    .task {
      await viewModel.loadSchedules()
    }
    .refreshable {
      await viewModel.loadSchedules()
    }
  }


  var todayHolder:some View{
    VStack{}
      .textureBackground(texture: .bubble, radius: 18)
      .frame(height: 300)
  }
  var scheduleTitle:some View{
    Text("日程")
      .inkFont(.font1, size: 22, relativeTo: .body)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  var modePicker: some View{
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

      }
    }
  }
}

#Preview {
  HomePage()
    .environmentObject(HomeViewModel())
}


struct ViewWidthKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
