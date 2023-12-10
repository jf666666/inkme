//
//  TodayView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/10/23.
//

import SwiftUI

struct TodayCoopView: View {
  var today:TodayCoop
  var body: some View {
    HStack(spacing:8){
      rate
        .padding([.top,.bottom],5)
        .background(AppColor.listItemBackgroundColor)
        .continuousCornerRadius(10)
      info
        .padding([.top,.bottom],5)
        .background(AppColor.listItemBackgroundColor)
        .continuousCornerRadius(10)
    }
    .frame(maxWidth: .infinity)

  }

  var rate:some View{
    VStack{
      HStack{
        PieView(values: [Double(today.clear), Double(today.failure)], colors: [AppColor.waveClearColor, AppColor.waveDefeatColor])
          .opacity(0.9)
          .frame(width: 25, height: 25)
        Text("通关率")
          .inkFont(.font1, size: 16, relativeTo: .body)
          .foregroundStyle(.appLabel)
          .minimumScaleFactor(0.5)
        let total = Double(today.clear + today.failure) == 0 ? 1 : Double(today.clear + today.failure)
        Text("\((Double(today.clear) &/ total) * 100)%")
          .inkFont(.font1, size: 16, relativeTo: .body)
          .foregroundStyle(.secondary)
      }

      HStack{
        Spacer()
        VStack(spacing: 4) {

          Text("Clear")
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(.secondary)

          Text("\(today.clear)")
            .inkFont(.font1, size: 24, relativeTo: .body)
            .foregroundStyle(.waveClear)


        }
        Spacer()
        VStack(spacing: 4) {

          Text("Failure")
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(.secondary)

          Text("\(today.failure)")
            .inkFont(.font1, size: 24, relativeTo: .body)
            .foregroundStyle(.waveDefeat)


        }
        Spacer()
        if today.abort != 0{
          VStack(spacing: -10) {

            Text("abort")
              .inkFont(.font1, size: 10, relativeTo: .body)
              .foregroundStyle(.secondary)

            Text("\(today.abort)")
              .inkFont(.font1, size: 24, relativeTo: .body)
              .foregroundStyle(.waveDefeat)


          }
          Spacer()
        }
      }
    }
  }
  var info:some View{

    VStack{
      HStack{
        PieView(values: [today.rescue, today.rescued], colors: [AppColor.waveClearColor, AppColor.waveDefeatColor])
          .opacity(0.9)
          .frame(width: 25, height: 25)
        Text("营救率")
          .inkFont(.font1, size: 16, relativeTo: .body)
          .foregroundStyle(.appLabel)
          .minimumScaleFactor(0.5)
        let rescued = today.rescued == 0 ? 1 : today.rescued
        Text("\((today.rescue &/ rescued) * 100) %")
          .inkFont(.font1, size: 16, relativeTo: .body)
          .foregroundStyle(.secondary)
      }

      HStack{
        Spacer()
        VStack(spacing: 4) {

          Image(.salmonRun)
            .resizable()
            .scaledToFit()
//            .frame(width: 20, height: 20)

          Text("\(today.kill)")
            .inkFont(.font1, size: 24, relativeTo: .body)
          //            .foregroundStyle(.waveClear)
            .opacity(0.5)


        }
        Spacer()
        VStack(spacing: 4) {

          Image(.golden)
            .resizable()
            .scaledToFit()
//            .frame(width: 20,height: 20)

          Text("\(today.egg)")
            .inkFont(.font1, size: 24, relativeTo: .body)
          //            .foregroundStyle(.waveDefeat)
            .opacity(0.5)


        }
        Spacer()
        if today.abort != 0{
          VStack(spacing: -10) {

            Text("abort")
              .inkFont(.font1, size: 10, relativeTo: .body)
              .foregroundStyle(.secondary)

            Text("\(today.abort)")
              .inkFont(.font1, size: 24, relativeTo: .body)
              .foregroundStyle(.waveDefeat)
              .minimumScaleFactor(0.5)

          }
          Spacer()
        }
      }
    }
  }
}

struct TodayBattleView: View {

  let today: TodayBattle

  @AppStorage("showKDInHome")
  private var showKD: Bool = false

  var body: some View {
    HStack(spacing: 8) {

      VStack {
        HStack {

          PieView(values: [Double(today.victoryCount), Double(today.defeatCount)], colors: [AppColor.spPink, AppColor.spLightGreen])
            .opacity(0.9)
            .frame(width: 25, height: 25)

          Text("胜率")
            .inkFont(.font1, size: 16, relativeTo: .body)
            .foregroundStyle(.appLabel)
            .minimumScaleFactor(0.5)

          Text("\((Double(today.victoryCount) &/ Double(today.victoryCount + today.defeatCount)) * 100)%")
            .inkFont(.font1, size: 16, relativeTo: .body)
            .foregroundStyle(.secondary)

        }

        HStack {

          Spacer()

          VStack(spacing: 4) {

            Text("胜利")
              .inkFont(.font1, size: 10, relativeTo: .body)
              .foregroundStyle(.secondary)

            Text("\(today.victoryCount)")
              .inkFont(.font1, size: 24, relativeTo: .body)
              .foregroundStyle(.waveClear)
              .minimumScaleFactor(0.5)


          }

          Spacer()

          VStack(spacing: 4) {

            Text("失利")
              .inkFont(.font1, size: 10, relativeTo: .body)
              .foregroundStyle(.secondary)

            Text("\(today.defeatCount)")
              .inkFont(.font1, size: 24, relativeTo: .body)
              .foregroundStyle(.waveDefeat)
              .minimumScaleFactor(0.5)

          }

          Spacer()

        }
      }
      .padding([.top,.bottom],5)
      .background(AppColor.listItemBackgroundColor)
      .continuousCornerRadius(10)

      ZStack {
        VStack {
          HStack {

            if showKD {
              PieView(values: [Double(today.killCount), Double(today.deathCount)], colors: [.red, Color.gray.opacity(0.5)])
                .opacity(0.9)
                .frame(width: 25, height: 25)

              Text("K/D:")
                .inkFont(.font1, size: 16, relativeTo: .body)
                .foregroundStyle(.appLabel)

              Text("\(Double(today.killCount) &/ Double(today.deathCount), places: 1)")
                .inkFont(.font1, size: 16, relativeTo: .body)
                .foregroundStyle(.secondary)
            } else {
              PieView(values: [Double(today.killCount), Double(today.assistCount), Double(today.deathCount)], colors: [.red, Color.red.opacity(0.8), Color.gray.opacity(0.5)])
                .opacity(0.9)
                .frame(width: 25, height: 25)

              Text("KA/D:")
                .inkFont(.font1, size: 16, relativeTo: .body)
                .foregroundStyle(.appLabel)

              Text("\(Double(today.killCount + today.assistCount) &/ Double(today.deathCount), places: 1)")
                .inkFont(.font1, size: 16, relativeTo: .body)
                .foregroundStyle(.secondary)
            }

          }

          HStack {

            Spacer()

            VStack(spacing: 4) {

              if showKD {
                Text("KILL")
                  .inkFont(.font1, size: 10, relativeTo: .body)
                  .foregroundStyle(.secondary)

                Text("\(today.killCount)")
                  .inkFont(.font1, size: 24, relativeTo: .body)
                  .foregroundStyle(.red)
                  .minimumScaleFactor(0.5)
              } else {
                Text("KILL+ASSIST")
                  .inkFont(.font1, size: 10, relativeTo: .body)
                  .foregroundStyle(.secondary)

                Text("\(today.killCount + today.assistCount)")
                  .inkFont(.font1, size: 24, relativeTo: .body)
                  .foregroundStyle(.red)
                  .minimumScaleFactor(0.5)
              }

            }

            Spacer()

            VStack(spacing: 4) {

              Text("DEATH")
                .inkFont(.font1, size: 10, relativeTo: .body)
                .foregroundStyle(.secondary)

              Text("\(today.deathCount)")
                .inkFont(.font1, size: 24, relativeTo: .body)
                .foregroundStyle(.gray.opacity(0.5))
                .minimumScaleFactor(0.5)

            }

            Spacer()

          }
        }
        .padding([.top,.bottom],5)
        .background(AppColor.listItemBackgroundColor)
        .continuousCornerRadius(10)

        VStack {
          HStack {
            Spacer()

            Image(systemName: showKD ? "circle" : "largecircle.fill.circle")
              .resizable()
              .frame(width: 14, height: 14)
              .foregroundColor(Color.gray.opacity(0.3))
              .padding([.trailing, .top], 6)
          }

          Spacer()
        }
      }
      .onTapGesture {
        showKD.toggle()
      }

    }
    .frame(maxWidth: .infinity)

  }
}

#Preview {
//  TodayCoopView(today: TodayCoop())
  TodayBattleView(today: TodayBattle())
}
//struct TodayView_Previews: PreviewProvider {
//    static var previews: some View {
//      TodayBattleView(today: TodayBattle())
//    }
//}

struct TodayCoop{
  var clear:Int = 0
  var failure:Int = 0
  var abort:Int = 0
  var kill:Double = 0
  var egg:Double = 0
  var rescue:Double = 0
  var rescued:Double = 0
}

struct TodayBattle {
  var victoryCount: Int = 0
  var defeatCount: Int = 0
  var killCount: Int = 0
  var assistCount: Int = 0
  var deathCount: Int = 0
}
