//
//  CoopShiftCardDetail.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/28/23.
//

import SwiftUI
import Kingfisher

//extension CoopShiftCard{
//  var enemies:[CoopEnemyResult] {[]}
//  var detail:some View{
//    VStack{
//
//    }
//  }
//}

struct CoopSummaryDetail:View {
  let details:[CoopHistoryDetail]
  var stats:[CoopStatus] {details.map{$0.status}.filter{!$0.exempt}}
  var weapons:[String] {details[0].weapons.map{$0.image!.url!}}
  var stage:StageSelection{StageSelection(rawValue: stats[0].stage) ?? .MaroonersBay}
  var timeSpanText:String {
    let start = stats.min { $0.time < $1.time }!.time
    let end = stats.max { $0.time < $1.time }!.time
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MM/dd HH:mm"
    return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
  }
  var wave:Double {stats.map { stat in
    stat.wave
  }.average()}
  var rescue:Double {
    stats.map { stat in
      stat.myself.rescue
    }
    .average()
  }
  var rescued:Double {
    stats.map { stat in
      stat.myself.rescued
    }
    .average()
  }
  var goldenAssist:Double {
    stats.map { stat in
      stat.myself.assist
    }
    .average()
  }
  var goldenDeliver:Double {
    stats.map { stat in
      stat.myself.golden
    }
    .average()
  }
  var normalDeliver:Double {
    stats.map { stat in
      stat.myself.power
    }
    .average()
  }
  var averageClear:Double {
    stats.map { stat in
      stat.myself.defeat
    }
    .average()
  }
  var maxScore:Int? {
    stats.max{
      if let left = $0.grade?.point, let right = $1.grade?.point{
        return left < right
      }
      return false
    }?.grade?.point
  }
  var maxGolden:Int{
    stats.max{
      $0.team.golden < $1.team.golden
    }!
    .team.golden
  }
  var specie:[Image]{
    switch details[0].myResult.player.species{
    case .OCTOLING:
      return [Image(.helpOcto),Image(.helpedOcto)]
    case .INKLING:
      return [Image(.helpSquid),Image(.helpedSquid)]
    }
  }
  var goldenScale:Int {stats.compactMap{$0.scale?.gold}.sum()}
  var silverScale:Int {stats.compactMap{$0.scale?.silver}.sum()}
  var bronzeScale:Int {stats.compactMap{$0.scale?.bronze}.sum()}
  var scales:[Int]{
    [bronzeScale,silverScale,goldenScale]
  }
  var body: some View {
    DetailScrollView(horizontalPadding: 8){
      VStack(spacing:30) {
        card

        enemy
      }
    }
  }
  
  var enemy:some View{
    VStack{
      
    }
    .padding([.leading, .trailing], 12)
    .padding(.top, 9)
    .padding(.bottom, 8)
    .textureBackground(texture: .bubble, radius: 18)
  }

  var card:some View{
    VStack {
      VStack{
        HStack {
          VStack(spacing:0){

            HStack(spacing:10) {
              CoopRule(rawValue: stats[0].rule)?.icon
                .resizable()
                .scaledToFit()
                .frame(width: 30)
              Text(timeSpanText)
                .inkFont(.Splatoon2, size: 15, relativeTo: .body)
                .scaledLimitedLine(lineLimit: 2)
                .foregroundStyle(Color.spOrange)
            }
            stage.image
              .resizable()
              .scaledToFit()
              .continuousCornerRadius(10)
            Text(stage.name)
              .inkFont(.font1, size: 15, relativeTo: .body)
              .foregroundStyle(.secondary)
          }
          VStack{
            Text("Summary")
              .inkFont(.Splatoon2, size: 30, relativeTo: .body)
              .foregroundStyle(Color.spOrange)
            if let maxScore = maxScore{
              Text("最高分\(maxScore)")
                .inkFont(.font1, size: 18, relativeTo: .body)
                .foregroundStyle(Color.spGreen)
              HStack{
                Image(.golden)
                Text("\(maxGolden)")
                  .inkFont(.font1, size: 18, relativeTo: .body)
                  .foregroundStyle(Color.spGreen)
              }
            }
            HStack{
              var
            scaleImage:[Image]{[Image(.scale1),Image(.scale2),Image(.scale3)]}
              ForEach(0..<3,id: \.self) { i in
                HStack(spacing:0){
                  scaleImage[i]
                    .resizable()
                    .frame(width: 18, height: 18)
                  Text("\(scales[i])")
                    .inkFont(.font1, size: 12, relativeTo: .body)
                }
              }
            }
            Spacer()
          }
        }
        line
        HStack{
          Text("发放武器")
            .inkFont(.font1, size: 15, relativeTo: .body)
            .foregroundStyle(.secondary)
          Spacer()
          HStack{
            ForEach(0..<4,id: \.self){ i in
              KFImage(URL(string: weapons[i]))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            }

          }
        }
      }
      .padding([.leading, .trailing], 12)
      .padding(.top, 9)
      .padding(.bottom, 8)
      .textureBackground(texture: .bubble, radius: 18)
      VStack { }
        .frame(maxWidth: .infinity, minHeight: 19, maxHeight: 19)
        .overlay(
          GrayscaleTextureView(
            texture: .bubble,
            foregroundColor: AppColor.battleDetailStreakForegroundColor,
            backgroundColor: AppColor.listItemBackgroundColor
          )
          .frame(height: 100)
          .offset(y: -78)
          .mask(
            VStack {
              HStack {
                Spacer()
                Image("JobShiftCardTail")
                  .resizable()
                  .frame(width: 33, height: 19)
              }
              Spacer()
            }
              .padding(.trailing, 24)
          ),
          alignment: .topLeading
        )
        .overlay {
          HStack(spacing:0){
            Text("\(details.count)场打工")
              .inkFont(.font1, size: 12, relativeTo: .body)
            if stats.count != details.count{
              Text("<\(details.count-stats.count)场掉线>")
                .inkFont(.font1, size: 10, relativeTo: .body)
                .foregroundStyle(Color.waveDefeat)
            }
          }
          .foregroundStyle(Color.spGreen)
          .offset(y:2)
        }
    }

//    .overlay {
//      HStack(spacing:0){
//        Text("\(details.count)场打工")
//          .inkFont(.font1, size: 12, relativeTo: .body)
//        if stats.count != details.count{
//          Text("<\(details.count-stats.count)场掉线>")
//            .inkFont(.font1, size: 10, relativeTo: .body)
//            .foregroundStyle(Color.waveDefeat)
//        }
//      }
//      .foregroundStyle(Color.spGreen)
//      .offset(y:125)
//    }


  }
  var line:some View{
    GeometryReader { geo in
      Path { path in
        path.move(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: geo.size.width, y: 0))
      }
      .stroke(style: StrokeStyle(lineWidth: 1, dash: [3.5, 3.5]))
      .foregroundColor(Color.init(.sRGB, white: 0.4, opacity: 0.36))
    }
    .frame(height: 1)
  }
}

#Preview {
  CoopSummaryDetail(details: [MockData.getCoopHistoryDetail()])
}

//extension CoopStats{
//  static func + (left:CoopStats, right:CoopStats) ->CoopStats{
//
//    let wave = left.wave + right.wave
//    let myself = left.myself + right.myself
//    let team = left.team + right.team
//
//    var scales = [0,0,0]
//    if let leftScale = left.scale{
//      scales[0] += leftScale.bronze
//      scales[1] += leftScale.silver
//      scales[2] += leftScale.gold
//    }
//    if let rightScale = right.scale{
//      scales[0] += rightScale.bronze
//      scales[1] += rightScale.silver
//      scales[2] += rightScale.gold
//    }
//
//    let waves = right.waves + left.waves
//    var scale = CoopStats.Scale(gold: scales[2], silver: scales[1], bronze: scales[0])
//
//    let suppliedWeapon = left.suppliedWeapon + right.suppliedWeapon
//    let jobPoint = right.jobPoint + left.jobPoint
//    let jobScore = left.jobScore + right.jobScore
//    let jobRate = left.jobRate + right.jobRate
//    let jobBonus = left.jobBonus + right.jobBonus
//
//    // 合并两个数组
//    let combinedBosses = left.bosses + right.bosses
//
//    // 构建字典并累加值
//    let summedBosses = combinedBosses.reduce(into: [String: BossSalmonidStats]()) { (dict, stats) in
//      if let existing = dict[stats.id] {
//            dict[stats.id] = BossSalmonidStats(
//                id: stats.id,
//                appear: existing.appear + stats.appear,
//                defeat: existing.defeat + stats.defeat,
//                defeatTeam: existing.defeatTeam + stats.defeatTeam
//            )
//        } else {
//            dict[stats.id] = stats
//        }
//    }
//
//    return CoopStats(time: left.time,
//                     exempt: left.exempt,
//                     clear: left.clear,
//                     wave: wave,
//                     dangerRate: left.dangerRate,
//                     myself: myself,
//                     member: left.member + right.member,
//                     team: team,
//                     bosses: [],
//                     king: nil,
//                     scale: scale,
//                     waves: wave,
//                     rule: <#T##String#>,
//                     stage: <#T##String#>,
//                     weapons: <#T##[String]#>,
//                     specialWeapon: <#T##String?#>,
//                     suppliedWeapon: <#T##[String]#>,
//                     jobPoint: jobPoint,
//                     jobScore: jobScore,
//                     jobRate: jobRate,
//                     jobBonus: jobBonus,
//                     grade: left.grade
//                  )
//  }
//}
