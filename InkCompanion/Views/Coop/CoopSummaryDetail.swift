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
        friends
        weapon
        king
        enemy
      }
    }
    .fixSafeareaBackground()
  }
  
  var friends:some View{
    VStack{
      FriendsSummary(friends: friendsCount)
    }
  }

  var weapon:some View{
    
    VStack{
      let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
      ]
      
      LazyVGrid(columns: columns, spacing: 10) {
        ForEach(weaponUsages,id: \.id){w in
          VStack(spacing:3){
            KFImage(URL(string: w.id))
              .resizable()
              .scaledToFit()
              .frame(width: 30,height: 30)
            Text("x\(w.count)")
              .inkFont(.font1, size: 15, relativeTo: .body)
          }
        }
      }
    }
    .padding(.all, 10)
    .textureBackground(texture: .bubble, radius: 18)
  }
  var wave:some View{
    VStack{
//      GridRow{
//        Text("WAVE记录")
//        Text("干潮")
//        Text("普通")
//        Text("涨潮")
//      }
//      .inkFont(.font1, size: 15, relativeTo: .body)
      ForEach(status.waves.reversed(), id: \.id){result in
        WaveRow(wave: result)
//          .frame(height: 20)
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
            HStack{
              Text("Clear:\(status.clear)")
                .foregroundStyle(.waveClear)
              Text("Failure:\(status.count-status.clear-status.exempt)")
                .foregroundStyle(.waveDefeat)
            }
            .inkFont(.font1, size: 13, relativeTo: .body)
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
            ForEach(suppliedWeapons.indices,id: \.self){ i in
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

  var stats:[CoopStatus] {details.map{$0.status}/*.filter{!$0.exempt}*/}
  var status:CoopsStatus{
    addCoopStatus(coops: details.map{$0.status}/*.filter{!$0.exempt}*/)
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
  var friendsCount:[CoopPlayer:Int]{
    // 展开所有的player
    let players = details.flatMap { $0.memberResults.map { $0.player } }
    // 计算每个player出现的次数
    return players.reduce(into: [:]) { counts, player in
      counts[player, default: 0] += 1
    }
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
    var levels:[WaveStats.Level]{
      wave.levels.sorted(by: {$0.id<$1.id})
    }
    var body: some View {
      let s:[String] = ["干潮","普通","涨潮"]
//      GridRow {
//        Text(wave.id.localizedString)
//          .scaledLimitedLine(minScaleFactor: 0.4)
//          .frame(maxWidth: .infinity)
//                  .inkFont(.font1, size: 15, relativeTo: .body)
//        // 创建一个固定大小为3的数组来表示每个level的位置
//        let levelSlots: [WaveStats.Level?] = Array(repeating: nil, count: 3)
//
//        // 填充levelSlots数组
//        let filledSlots = wave.levels.reduce(into: levelSlots) { (slots, level) in
//          if level.id >= 0 && level.id < slots.count {
//            slots[level.id] = level
//          }
//        }
//        ForEach(0..<filledSlots.count, id: \.self) { index in
//          if let level = filledSlots[index] {
//            // 这里显示level的信息
//            Text("\(level.appear)/\(level.clear)")
//              .frame(maxWidth: .infinity)
//              .inkFont(.font1, size: 15, relativeTo: .body)
//          } else {
//            // 没有对应的level，显示占位符
//            Text("-")
//              .frame(maxWidth: .infinity)
//              .inkFont(.font1, size: 15, relativeTo: .body)
//          }
//        }
//      }
      DisclosureGroup {
        HStack(spacing:5){
          ForEach(wave.levels,id: \.id){ level in
//                      HStack{
//                        Text("\(s[level.id])")
//                          .inkFont(.font1, size: 15, relativeTo: .body)
//                        Spacer()
//                        HStack(spacing: 10) {
//                          Text("收集\(level.goldenDeliver/Double(level.appear))/\(level.goldenNorm/Double(level.appear))")
//                            .font(.custom(InkFont.font1.rawValue, size: 15))
//                          HStack(spacing:0){
//                            Image(.golden)
//                              .resizable()
//                              .scaledToFit()
//                              .frame(width: 10, height: 10)
//                            Text("x\(level.goldenAppear/Double(level.appear))").font(.custom(InkFont.font1.rawValue, size: 15))
//                          }
//                          Text("\(level.clear)")
//                            .inkFont(.font1, size: 15, relativeTo: .body)
//                            .foregroundStyle(.waveClear)
//                          Text("/")
//                          Text("\(level.appear)")
//                            .inkFont(.font1, size: 15, relativeTo: .body)
//                        }
//            
//                      }
            WaveResult(result: level)
          }
        }
      } label: {
        Text(wave.id.localizedString)
          .scaledLimitedLine(minScaleFactor: 1)
                  .inkFont(.font1, size: 15, relativeTo: .body)
      }


    }
  }
}

extension CoopSummaryDetail{
  struct WaveResult:View {
    let result:WaveStats.Level
    let waterLevel = ["干潮","普通","涨潮"]
    var waveHeight: CGFloat {
        switch result.id {
        case 2:
            return 72
        case 1:
            return 49
        case 0:
            return 16
        default:
          return 49
        }
    }
    var body: some View {
      VStack {
        ZStack {
          VStack {
            Spacer()
            WaveShape()
              .fill(LinearGradient(
                gradient: Gradient(colors: [AppColor.waveGradientStartColor, AppColor.listItemBackgroundColor]),
                startPoint: .top,
                endPoint: .bottom))
              .frame(height: waveHeight)
          }

          VStack {
            VStack(spacing:4){
              HStack(spacing:0){
                Text("\(result.clear)")
                  .inkFont(.font1, size: 15, relativeTo: .body)
                  .foregroundStyle(.waveClear)
                Text("/")
                  .inkFont(.font1, size: 15, relativeTo: .body)
                Text("\(result.appear - result.clear)")
                  .inkFont(.font1, size: 15, relativeTo: .body)
                  .foregroundStyle(.waveDefeat)
              }


              Text("\((result.goldenDeliver ?? 0)/Double(result.appear))/\((result.goldenNorm ?? 0)/Double(result.appear))")



              Text("\(waterLevel[result.id])")
              HStack(spacing:0){
                Image(.golden)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 10, height: 10)
                Text("x\((result.goldenAppear ?? 0)/Double(result.appear))").font(.custom(InkFont.font1.rawValue, size: 10))
              }
              Text("平均出现数量").font(.custom(InkFont.font1.rawValue, size: 8))
                .foregroundStyle(.secondary)

            }
            .inkFont(.font1, size: 15, relativeTo: .body)
            .padding(.top,10)
            Spacer()
          }
        }
        .frame(width: 85, height: 110)
        .background(AppColor.listItemBackgroundColor)
        .continuousCornerRadius(10)

//        let columns = Array(repeating: GridItem(.fixed(13)), count: min(result.specialWeaponUsage.count, 4))
//        LazyVGrid(columns: columns, spacing: 2) {
//          ForEach(0..<result.specialWeapons.count, id: \.self){index in
//            Rectangle()
//              .overlay {
//                KFImage(URL(string: result.specialWeapons[index].image?.url ?? ""))
//                  .resizable()
//                  .scaledToFit()
//                  .frame(width: 12, height: 12)
//              }
//              .foregroundStyle(Color.salmonRunSpecialBackground)
//              .frame(width: 13, height: 13)
//              .clipShape(Capsule())
//          }
//        }
//        .frame(width: 85)
      }


    }
  }
}


extension CoopSummaryDetail {
  struct FriendsSummary:View {
    let friends:[CoopPlayer:Int]
    var body: some View {
      DisclosureGroup {
        let columns = [
          GridItem(.flexible()),
          GridItem(.flexible()),
          GridItem(.flexible()),

        ]

        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(friends.sorted{$0.value > $1.value}.filter{$0.value>1},id:\.key){ player, count in

            VStack{
              NameplateView(coopPlayer: player)
              Text("x\(count)")
                .inkFont(.font1, size: 15, relativeTo: .body)
            }
          }
        }
      } label: {
        Text("遇到过的工友")
          .inkFont(.font1, size: 15, relativeTo: .body)
      }

    }
  }
}
