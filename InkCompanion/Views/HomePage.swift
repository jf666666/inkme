//
//  HomePage.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/30/23.
//

import SwiftUI

struct HomePage: View {
  @EnvironmentObject var viewModel: HomeViewModel
  @State private var vdChartViewHeight: CGFloat = 200
  @State private var vdChartLastBlockWidth: CGFloat = 0

  var body: some View {
    NavigationStack {
      ScrollView{
        VStack(alignment: .center,spacing: 10){
          today
          VStack(spacing:5){
            scheduleTitle
            modePicker
            subModePicker
            if viewModel.currentMode != .salmonRun{
              BattleScheduleView()
            }else{
              CoopScheduleView()
            }
//            ScheduleView()
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,15)
      }
      .navigationBarTitle("主页", displayMode: .inline)
      .frame(maxWidth: .infinity)
      .fixSafeareaBackground()
      .task {
        viewModel.loadGirds()
        viewModel.loadTodayCoop()
      }
      .refreshable {
        await viewModel.loadSchedules()
    }
    }
  }

  var today:some View{
    TabView{
      todayBattle

      todayCoop
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    .frame(height: 240)


  }


  var todayBattle:some View{
    VStack {
      VStack(spacing: 10) {
        HStack(alignment: .firstTextBaseline) {
          Text("今日")
            .inkFont(.font1, size: 22, relativeTo: .body)

//          Text("(\(viewModel.resetHour):00 \("reset".localized))")
//            .inkFont(.Splatoon2, size: 12, relativeTo: .body)
//            .foregroundStyle(.secondary)

          Spacer()
        }

        TodayBattleView(today: viewModel.todayBattle)


      }
      .padding(.top)



      VStack(spacing: 0) {
        HStack(alignment: .firstTextBaseline) {
          Text("近期战况")
            .inkFont(.font1, size: 22, relativeTo: .body)
            .foregroundStyle(Color.appLabel)

          Text("(\(NSLocalizedString("最近500场", comment: "")))")
            .inkFont(.font1, size: 12, relativeTo: .body)
            .foregroundStyle(.secondary)

          Spacer()
        }

        HStack {
          Text("最近50场")
            .inkFont(.font1, size: 8, relativeTo: .body)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.5)
            .frame(width: vdChartLastBlockWidth)
          Spacer()
        }
        .frame(height: 20)

        VDGridView(
          data: viewModel.battleWinLoseDrawResult,
          height: $vdChartViewHeight,
          lastBlockWidth: $vdChartLastBlockWidth,
          isCoop: false
        )
        .frame(height:vdChartViewHeight)
      }
    }
  }

  var todayCoop:some View{
    VStack {
      VStack(spacing: 10) {
        HStack(alignment: .firstTextBaseline) {
          Text("今日")
            .inkFont(.font1, size: 22, relativeTo: .body)

//          Text("(\(viewModel.resetHour):00 \("reset".localized))")
//            .inkFont(.Splatoon2, size: 12, relativeTo: .body)
//            .foregroundStyle(.secondary)

          Spacer()
        }

        TodayCoopView(today: viewModel.todayCoop)


      }
      .padding(.top)



      VStack(spacing: 0) {
        HStack(alignment: .firstTextBaseline) {
          Text("近期工况")
            .inkFont(.font1, size: 22, relativeTo: .body)
            .foregroundStyle(Color.appLabel)

          Text("(\(NSLocalizedString("最近500场", comment: "")))")
            .inkFont(.font1, size: 12, relativeTo: .body)
            .foregroundStyle(.secondary)

          Spacer()
        }

        HStack {
          Text("最近50场")
            .inkFont(.font1, size: 8, relativeTo: .body)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.5)
            .frame(width: vdChartLastBlockWidth)
          Spacer()
        }
        .frame(height: 20)

        VDGridView(
          data: viewModel.coopWinLoseDrawResult,
          height: $vdChartViewHeight,
          lastBlockWidth: $vdChartLastBlockWidth
        )
        .frame(height:vdChartViewHeight)


      }
//      .padding(.top)
//      Spacer()
    }
  }

  var todayHolder:some View{
    VStack{}
      .textureBackground(texture: .bubble, radius: 18)
      .frame(height: 200)
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
