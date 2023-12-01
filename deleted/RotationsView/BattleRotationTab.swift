//
//  BattleRotationTab.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/16/23.
//

import SwiftUI

struct BattleRotationTab: View {
  @EnvironmentObject var rotationModel:RotationModel
  @Environment(\.scenePhase) var scenePhase

  var picker:some ToolbarContent{
    ToolbarItemGroup(placement: .bottomBar){
        Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
          ForEach(ScheduleMode.allCases) { mode in
            mode.icon
              .tag(mode)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      Spacer()
      switch rotationModel.mode{
      case .anarchy:
        Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
          ForEach(ScheduleMode.anarchyCases) { mode in
            mode.icon
              .tag(mode)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      case .fest:
        Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
          ForEach(ScheduleMode.festCases) { mode in
            mode.icon
              .tag(mode)
          }
        }
        .pickerStyle(SegmentedPickerStyle())

      case .regular,.x,.event, .salmonRun:
        EmptyView()
      }


    }
  }

    var body: some View {

      NavigationStack {

          BattleRotationList(specifiedMode: rotationModel.mode)

          .navigationBarTitle("日程")
          .toolbar{
            picker
          }
          .task {
            await rotationModel.loadData()
          }
          .refreshable {
            await rotationModel.loadData()
          }
          .onChange(of: scenePhase){ phase in
            if phase == .active{
              Task{
                await rotationModel.loadData()
              }
            }
        }
      }
    }
}

#Preview {
    BattleRotationTab()
    .environmentObject(RotationModel())
}
