//
//  BattleItem.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import SwiftUI
import Kingfisher

struct BattleItem: View {
  let detail:VsHistoryDetail

  var mode:BattleMode{BattleMode(rawValue: detail.vsMode.id)}
  var rule:BattleRule{detail.vsRule.rule}
  var species:Species {detail.player.species}
  var myTeamColor:Color{detail.myTeam.color.swiftColor}
  var otherTeamColor:[Color]{detail.otherTeams.map{$0.color.swiftColor}}
  var myPoint:Double{
    if rule == .turfWar || rule == .triColor{
      return detail.myTeam.result?.paintRatio ?? 0
    }else{
      return (detail.myTeam.result?.score ?? 0)/100
    }
  }
  var otherPoint:[Double]{
    detail.otherTeams.map{
      if rule == .turfWar || rule == .triColor{
        return $0.result?.paintRatio ?? 0
      }else{
        return ($0.result?.score ?? 0)/100
      }
    }
  }
  var stage:VsStage{detail.vsStage}
  var playTime:String{detail.playedTime.asDate.toPlayedTimeString()}
  var weapon:String{detail.player.weapon.image?.url ?? ""}

  var body: some View {
    ZStack {
      VStack(spacing:0){
        HStack(spacing:6){
          mode.icon
            .resizable()
            .frame(width: 16, height: 16)
            .padding(.top, -0.5)
            .padding(.bottom, -1.5)

          Text(rule.name)
            .inkFont(.font1, size: 12, relativeTo: .body)
            .foregroundStyle(mode.color)
          Spacer()

          if mode == .anarchy{
            HStack(alignment: .firstTextBaseline, spacing: 0){
              Text(detail.udemae ?? "C-")
                .inkFont(.Splatoon2, size: 12, relativeTo: .body)
              if let plus = detail.bankaraMatch?.earnedUdemaePoint{
                Text("\(plus)")
                  .inkFont(.Splatoon2, size: 8, relativeTo: .body)
                  .padding(.leading,0.6)
//                  .padding(.bottom, 0)
              }
            }
          }
        }
        .padding(.bottom, 6.5)

        HStack {
          Text(detail.judgement.name)
            .inkFont(.Splatoon1, size: 14, relativeTo: .body)
            .foregroundStyle(detail.judgement.color)
          if let k = detail.knockout, k == .WIN {
            Text("完胜!")
              .inkFont(.font1, size: 14, relativeTo: .body)
              .foregroundStyle(.spYellow)
          }else if detail.vsRule.rule != .turfWar && detail.vsRule.rule != .triColor{
            Text("\(detail.myTeam.result?.score ?? 0)计数")
              .inkFont(.font1, size: 14, relativeTo: .body)
              .foregroundStyle(detail.judgement == .LOSE ? Color.secondary : .spGreen)
          }else if let point = detail.myTeam.result?.paintPoint{
            Text("\(point)p")
              .inkFont(.Splatoon2, size: 14, relativeTo: .body)
              .foregroundStyle(detail.judgement == .LOSE ? Color.secondary : .spGreen)
          }
          Spacer()
          HStack{
            HStack(spacing:3){
              species.icon.kill
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.systemGray3)
              HStack(alignment: .firstTextBaseline, spacing: 0){
                Text("\((detail.player.result?.kill ?? 0) + (detail.player.result?.assist ?? 0))")
                  .inkFont(.font1, size: 10, relativeTo: .body)
                Text("(\(detail.player.result?.assist ?? 0))")
                  .inkFont(.font1, size: 7, relativeTo: .body)
              }
            }

            HStack(spacing: 3) {
              species.icon.dead
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.systemGray3)
              Text("\(detail.player.result?.death ?? 0)")
                .inkFont(.font1, size: 10, relativeTo: .body)
            }
            
            HStack(spacing: 3) {
              species.icon.kd
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.systemGray3)
              let death = detail.player.result?.death ?? 1
              Text("\(Double(detail.player.result?.kill ?? 0) -/ Double(death == 0 ? 1 : death), places: 1)")
                .inkFont(.font1, size: 10, relativeTo: .body)
            }
          }
        }
        .padding(.bottom, 7)

        HStack(spacing: 0) {
          GeometryReader { geo in
            Rectangle()
              .foregroundStyle(Color.systemGray3)
            Rectangle()
              .foregroundColor(detail.judgement.color)
              .frame(width: geo.size.width*myPoint)

          }
        }
        .frame(height: 5)
        .clipShape(Capsule())
        .padding(.bottom, 6)

        HStack{
          Text(stage.localizedName)
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(Color.systemGray2)
          Spacer()
          Text(playTime)
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(Color.systemGray2)
        }
      }

      VStack {
          KFImage(URL(string: weapon))
          .resizable()
          .resizedToFit()
          .frame(width: 40, height: 40)
          Spacer()
      }
      .padding(.top, 6.5)
    }
    .padding(.top, 7.5)
    .padding(.bottom, 7)
    .padding([.leading, .trailing], 8)
    .background(Color(.listItemBackground))
    .frame(height: 92)
    .continuousCornerRadius(10)
  }
}

struct BattleItem_Previews:PreviewProvider{
  static var previews: some View{
    StatefulPreviewWrapper("") {index in
      BattleItem(detail: MockData.getVsHistoryDetail()!)
    }
  }
}


struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
