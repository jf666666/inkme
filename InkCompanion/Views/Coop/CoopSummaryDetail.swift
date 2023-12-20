//
//  CoopShiftCardDetail.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/28/23.
//

import SwiftUI
import Kingfisher



struct CoopSummaryDetail:View {

  let details:[CoopHistoryDetail]


  @AppStorage("showTeamResultInCoopSummaryDetail")
  private var showTeamResult: Bool = false

  var body: some View {
    DetailScrollView(horizontalPadding: 8){
      VStack(spacing:20) {
        card
        wave
        enemy
        
        king
      }
    }
    .fixSafeareaBackground()
  }
  var wave:some View{
    VStack{
      ForEach(status.waves.reversed(), id: \.id){result in
        WaveRow(wave: result)
          .frame(height: 20)
      }
    }
    .padding(.all, 10)
    .textureBackground(texture: .bubble, radius: 18)

  }
  var king:some View{
    HStack{
      ForEach(status.kings,id:\.id){k in
        if let king = CoopEnemy.Enemy(rawValue: k.id){
          VStack{
            king.image
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
            Text("\(k.defeat)/\(k.appear)")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }
        }
      }
    }
  }
  var enemy:some View{
    VStack{
      ForEach(bossesResult, id:\.id){boss in
        if boss.id != bossesResult.first?.id{
          line
        }
        EnemyRow(result: boss)
        .frame(height: 40)

      }
    }
    .padding(.all, 10)
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
              KFImage(URL(string: suppliedWeapons[i]))
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
        .offset(y: -8)
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

  var stats:[CoopStatus] {details.map{$0.status}.filter{!$0.exempt}}
  var status:CoopsStatus{
    addCoopStatus(coops: details.map{$0.status}.filter{!$0.exempt})
  }
  var bossesResult:[BossSalmonidStats]{
    status.bosses
  }
  var suppliedWeapons:[String] {details[0].weapons.map{$0.image!.url!}}
  var weaponUsages:[CoopsStatus.Weapon]{status.weapons}
  var stage:StageSelection{StageSelection(rawValue: stats[0].stage) ?? .unknown}
  var timeSpanText:String {
    let start = stats.min { $0.time < $1.time }!.time
    let end = stats.max { $0.time < $1.time }!.time
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MM/dd HH:mm"
    return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
  }
  var averageWave:Double {
    Double(status.wave)/Double(status.count)
  }
  var rescue:Double {
    Double(status.selfStats.rescue)/Double(status.count)
  }
  var rescued:Double {
    Double(status.selfStats.rescued)/Double(status.count)
  }
  var goldenAssist:Double {
    Double(status.selfStats.assist)/Double(status.count)
  }
  var goldenDeliver:Double {
    Double(status.selfStats.golden)/Double(status.count)
  }
  var normalDeliver:Double {
    Double(status.selfStats.power)/Double(status.count)
  }
  var defeat:Double {
    Double(status.selfStats.defeat)/Double(status.count)
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
  var goldenScale:Int {status.scales.gold}
  var silverScale:Int {status.scales.silver}
  var bronzeScale:Int {status.scales.bronze}
  var scales:[Int]{
    [bronzeScale,silverScale,goldenScale]
  }

}

#Preview {
  CoopSummaryDetail(details: [MockData.getCoopHistoryDetail()])

}

extension CoopSummaryDetail{

  struct EnemyRow:View {
    let result:BossSalmonidStats

    var body: some View {
      HStack{
        result.enemy.enemy.image
          .resizable()
          .scaledToFit()
        Text("\(result.enemy.id.localizedString)")
          .inkFont(.font1, size: 15, relativeTo: .body)
        Spacer()
        Group{
          Text("\(result.defeatTeam)").font(.custom(InkFont.font1.rawValue, size: 15)) + Text(result.defeat == 0 ? "" : "(\(result.defeat))").font(.custom(InkFont.font1.rawValue, size: 12))
          Text("/")
            .inkFont(.font1, size: 16, relativeTo: .body)
          Text("出现数量x").font(.custom(InkFont.font1.rawValue, size: 12)) + Text("\(result.appear)").font(.custom(InkFont.font1.rawValue, size: 15))
        }

      }
    }
  }
}

extension CoopSummaryDetail{
  struct WaveRow:View {
    let wave:WaveStats
    var body: some View {
      HStack{
        Text(wave.id.localizedString)
          .inkFont(.font1, size: 15, relativeTo: .body)
        Spacer()
        Text("\(wave.levels.map{$0.clear}.sum())/\(wave.levels.map{$0.appear}.sum())")
          .inkFont(.font1, size: 15, relativeTo: .body)
      }
    }
  }
}
