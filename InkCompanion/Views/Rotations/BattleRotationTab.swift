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

    var body: some View {

      NavigationStack {

          BattleRotationList(specifiedMode: rotationModel.mode)

          .navigationBarTitle("日程")
//          .toolbarTitleMenu{
//            ForEach(BattleMode.allCases, id:\.self){ mode in
//              Button{
//
//              } label: {
//                Label(
//                  title: { Text("\(mode.name)") },
//                  icon: { mode.icon }
//                )
//
//              }
//
//            }
//          }
          .toolbar{
            ToolbarItemGroup(placement: .bottomBar){
                Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
                  ForEach(BattleMode.allCases) { mode in
                    mode.icon
                      .resizable()
                      .scaledToFit()
                      .frame(width: 5, height: 5)
                      .tag(mode)
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
              Spacer()
              switch rotationModel.mode{
              case .anarchy:
                Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
                  ForEach(BattleMode.anarchyCases) { mode in
                    mode.icon
                      .tag(mode)
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
              case .fest:
                Picker(selection: $rotationModel.mode, label: Text("Battle Mode")){
                  ForEach(BattleMode.festCases) { mode in
                    mode.icon
                      .tag(mode)
                  }
                }
                .pickerStyle(SegmentedPickerStyle())

              case .regular,.x,.event:
                EmptyView()
              }


            }
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
