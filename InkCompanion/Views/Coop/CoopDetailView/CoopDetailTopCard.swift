//
//  CoopDetailTopCard.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct ProgressBar: View {
    var fillPercentage: CGFloat  // 0.0 到 1.0 之间

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle() // 背景条
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                Rectangle() // 填充条
                    .frame(width: geometry.size.width * fillPercentage)
                    .foregroundColor(Color.waveDefeat)
                    .cornerRadius(10)
            }
        }
        .frame(height: 8) // 指定高度
    }
}

extension CoopDetailView{

  struct TopCard:View{
    let stats:CoopStatus
    var stage:StageSelection{StageSelection(rawValue: stats.stage) ?? .MaroonersBay}
    var smell:Int
    var boss:CoopEnemy.Enemy = CoopEnemy.Enemy.Cohozuna
    @State var phase:Double = 0
    var width: CGFloat {
        var screentWidth = UIScreen.main.bounds.size.width
        if screentWidth > 500 {
            screentWidth = 500
        }

        return screentWidth - 64
    }
    var dangerRateText:String{
      let dangerRate = stats.dangerRate
      if dangerRate >= 3.33{
        return "危险度 MAX!!"
      }
      return "危险度 \(Int(dangerRate*100))%"
    }
    var weapons:[String] {stats.suppliedWeapon}
    var scales:[String] {
      if let scale = stats.scale{
        return ["\(scale.bronze)","\(scale.silver)","\(scale.gold)"]
      }
      return ["-","-","-"]
    }
    var body:some View{

        VStack(alignment: .leading, spacing: 4){
          HStack {
            VStack(alignment: .leading,spacing: 0) {

              HStack(spacing: 10) {
//                Image("SalmonRun")
                switch CoopRule(rawValue: stats.rule){
                case .BIG_RUN:
                  Image(.coopBigrun)
                case .TEAM_CONTEST:
                  Image(.coopTeamContest)
                default:
                  Image(.coopRegular)
                }



                Text(stats.time.toPlayedTimeString(full: true))
                  .inkFont(.Splatoon2, size: 15, relativeTo: .body)
                  .foregroundStyle(.spOrange)
                  .scaledLimitedLine()
              }
              .padding(.bottom, 7)

              stage.image
                .resizable()
                .scaledToFit()
              .continuousCornerRadius(10)


            }

            VStack {
              Text(stats.clear ? "Clear!!" : "Failure")
                .inkFont(.Splatoon2, size: 30, relativeTo: .body)
                .foregroundStyle(stats.clear ? AppColor.waveClearColor : AppColor.waveDefeatColor)
              Spacer()
              VStack{
                VStack(spacing:5) {
                  HStack {
                    Text("获得点数")
                      .inkFont(.font1, size: 10, relativeTo: .body)
                      .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(stats.jobPoint)p")
                      .inkFont(.font1, size: 20, relativeTo: .body)
                  }
                  GeometryReader { geo in
                    Path { path in
                      path.move(to: .init(x: 0, y: 0))
                      path.addLine(to: .init(x: geo.size.width, y: 0))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color.waveDefeat)
                  }
                  .frame(height: 1)
                  HStack(spacing:4){
                    VStack(spacing:4){
                      Text("\(stats.jobScore)")
                      Text("打工分数")
                        .inkFont(.font1, size: 8, relativeTo: .body)
                        .foregroundStyle(.secondary)
                    }
                    Text("x")
                      .inkFont(.font1, size: 12, relativeTo: .body)
                    VStack(spacing:4){
                      Text("\(stats.jobRate,places: 2)")
                      Text("评价倍率")
                        .inkFont(.font1, size: 8, relativeTo: .body)
                        .foregroundStyle(.secondary)
                    }
                    Text("+")
                    VStack(spacing:4){
                      Text("\(stats.jobBonus)")
                      Text("通关奖励")
                        .inkFont(.font1, size: 8, relativeTo: .body)
                        .foregroundStyle(.secondary)
                    }
                  }
                  .inkFont(.font1, size: 16, relativeTo: .body)
                }
                .padding([.leading, .trailing], 3)
                .padding([.top, .bottom], 3)
                .background(Color(.sRGB, white: 201 / 255.0, opacity: 0.1))
                .continuousCornerRadius(7)
                .frame(width:135)
                Spacer()
                if stats.rule == CoopRule.TEAM_CONTEST.rawValue{
                  EmptyView()
                    .padding([.leading, .trailing], 3)
                    .padding([.top, .bottom], 3)
                    .background(Color(.sRGB, white: 201 / 255.0, opacity: 0.1))
                    .continuousCornerRadius(7)
                    .frame(width:135)
                }else{
                  VStack(alignment: .leading,spacing: 2){
                    if let grade = stats.grade{
                      Text("\(grade.name.localizedString) \(grade.point)")
                        .inkFont(.font1, size: 12, relativeTo: .body)
                        .foregroundStyle(AppColor.waveClearColor)
                      ProgressBar(fillPercentage: grade.point >= 100 ? 1 : Double(grade.point)/Double(100))
                        .padding([.bottom,.top],2)
                    }

                    HStack{
                      var scaleImage:[Image]{[Image(.scale1),Image(.scale2),Image(.scale3)]}
                      ForEach(0..<3,id: \.self) { i in
                        HStack(spacing:0){
                          scaleImage[i]
                            .resizable()
                            .frame(width: 18, height: 18)
                          Text(scales[i])
                            .inkFont(.font1, size: 12, relativeTo: .body)
                        }
                        if i != 2{
                          Spacer()
                        }
                      }
                    }
                  }
                  .padding([.leading, .trailing], 3)
                  .padding([.top, .bottom], 3)
                  .background(Color(.sRGB, white: 201 / 255.0, opacity: 0.1))
                  .continuousCornerRadius(7)
                  .frame(width:135)
                }
              }
            }
          }


          HStack {
            Text(stage.name)
              .inkFont(.font1, size: 13, relativeTo: .body)
              .foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: 3){
              Image(.golden)
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
              Text("\(stats.team.golden)")
                .inkFont(.Splatoon1, size: 15, relativeTo: .body)
            }


            HStack(spacing: 3){
              Image(.egg)
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
              Text("\(stats.team.power)")
                .inkFont(.Splatoon1, size: 15, relativeTo: .body)
            }
          }
          
          GeometryReader { geo in
              Path { path in
                  path.move(to: .init(x: 0, y: 0))
                  path.addLine(to: .init(x: geo.size.width, y: 0))
              }
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [3.5, 3.5]))
              .foregroundColor(Color.init(.sRGB, white: 0.4, opacity: 0.36))
          }
          .frame(height: 1)

          HStack{
            ForEach(weapons.indices,id: \.self){ i in
              KFImage(URL(string: weapons[i]))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            }
            Spacer()
            Text(dangerRateText)
              .inkFont(.font1, size: 12, relativeTo: .body)
              .foregroundStyle(.secondary)
          }

        }
        .overlay (
          SineWaveShape(percent: 1-Double(smell)*0.2, strength: 1.2, frequency: 12, phase: self.phase, totalWidth: 60)
            .fill(Color.salmonRunTheme)
            .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: self.phase)
            .onAppear {
              withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = .pi * 2
              }
            }
            .frame(width: 60,height: 60)
            .mask {
              boss.image
                .resizable()
                .scaledToFit()
                .frame(width: 60,height: 60)
                .colorMultiply(.black)
            }
            .background(content: {
              boss.image
                .resizable()
                .scaledToFit()
                .frame(width: 60,height: 60)
                .colorMultiply(.black)
            })
            .offset(x:20,y:-40),
          alignment: .topTrailing
        )

    }
  }
}

#Preview(body: {
  GeometryReader{geo in
    CoopDetailView.TopCard(stats: getCoopStats(coop: MockData.getCoopHistoryDetail()), smell: 0)
      .frame(width: 400,height: 250)
  }
})

