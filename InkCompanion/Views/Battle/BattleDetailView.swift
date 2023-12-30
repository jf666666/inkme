//
//  BattleDetailView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/15/23.
//

import SwiftUI
import Kingfisher

struct BattleDetailView: View {
  let detail: VsHistoryDetail
  var mode:BattleMode{BattleMode(rawValue: detail.vsMode.id)}
  var rule:BattleRule{detail.vsRule.rule}
  var winTeamMember:[VsTeam]{
    if detail.judgement != .LOSE && detail.judgement != .WIN{
      return [detail.myTeam]
    }
    return ([detail.myTeam] + detail.otherTeams).filter{
      $0.judgement == .WIN
    }
  }
  var loseTeamMember:[VsTeam]{
    if detail.judgement != .LOSE && detail.judgement != .WIN{
      return detail.otherTeams
    }
    return ([detail.myTeam] + detail.otherTeams).filter{
      $0.judgement == .LOSE
    }
  }
  var crt:([Color?],[Double?],[String?]){
    detail.getColorRatioText()
  }

  @State private var myselfPosition:CGFloat = 0
  @State private var hidePlayerNames: Bool = false
  @State private var showPlayerSkill: Bool = false
  @State private var activePlayer: VsPlayer? = nil
  @State private var activePlayerVictory: Bool = false
  @State private var hoveredMember: Bool = false

  var body: some View {

    ScrollView{
      HStack {
        Spacer()
        VStack(spacing:20){
          card
          winTeam
          loseTeam
          playerInfo
        }
        Spacer()
      }
      .padding(.horizontal,8)
    }
    .frame(maxWidth: .infinity)
    .fixSafeareaBackground()
    .modifier(Popup(isPresented: showPlayerSkill,
                    onDismiss: {
      showPlayerSkill = false
    }, content: {
      Text(activePlayer?.name ?? "")
    }))

  }

  var card:some View{
    VStack(spacing:0){
      HStack{
        mode.icon
          .resizable()
          .frame(width: 30, height: 30)
          .padding(.top, -0.5)
          .padding(.bottom, -1.5)

        Text(rule.name)
          .inkFont(.font1, size: 20, relativeTo: .body)
          .foregroundStyle(mode.color)
        Spacer()
        Text("\(detail.playedTime.asDate.toPlayedTimeString(full: true))")
          .inkFont(.font1, size: 18, relativeTo: .body)
          .foregroundStyle(.secondary)
      }
      .padding(.all,12)
      detail.vsStage.stage.image
        .resizable()
        .scaledToFit()
        .overlay (
          WaveOverlay(crt: crt),
            alignment: .bottom
        )

    }

    .textureBackground(texture: .streak, radius: 18)
    .continuousCornerRadius(18)
  }

  var winTeam:some View{
    VStack{
      ForEach(0..<winTeamMember.count, id: \.self){index in
        VStack(alignment: .leading, spacing: 3) {
          Text("VICTORY")
            .inkFont(.Splatoon2, size: 12, relativeTo: .body)
            .padding(.leading,10)
            .foregroundStyle(winTeamMember[index].color.swiftColor)

          TeamList(
            team: winTeamMember[index],
            activePlayer: $activePlayer,
            showPlayerSkill:$showPlayerSkill,
            hoveredMember: $hoveredMember
          )


        }
      }
    }

  }

  var loseTeam:some View{
    VStack{
      ForEach(0..<loseTeamMember.count, id: \.self){index in
        VStack(alignment: .leading, spacing: 3) {
          Text("DEFEAT")
            .inkFont(.Splatoon2, size: 12, relativeTo: .body)
            .padding(.leading,10)
            .foregroundStyle(loseTeamMember[index].color.swiftColor)
          TeamList(team: loseTeamMember[index],
                   activePlayer: $activePlayer,
                   showPlayerSkill:$showPlayerSkill,
                   hoveredMember: $hoveredMember
          )


        }
      }
    }
  }

  var playerInfo:some View{
    VStack{

    }
  }

  struct TeamList:View {
    let team:VsTeam
    @Binding var activePlayer:VsPlayer?
    @Binding var showPlayerSkill: Bool
    @Binding var hoveredMember: Bool
    @State var center:CGPoint?
    @State var height:CGFloat?
    @State private var offset: CGFloat = 0
    var index:Int?{
      team.players.firstIndex(where: {$0.isMyself})
    }
    var playerCount:Int{
      Int(team.players.count)
    }
    var body: some View {
      VStack(spacing: 5) {
        DividerViewBuilder(items: team.players) { player in
          PlayerRow(player: player,color: team.color.swiftColor)
            .overlay {
              TouchDownAndTouchUpGestureView {
                activePlayer = player
                hoveredMember = true
              } touchMovedCallBack: { distance in
                if distance > 10 {
                  hoveredMember = false
                }
              } touchUpCallBack: {
                if hoveredMember {
                  showPlayerSkill = true
                  hoveredMember = false
                }
              }
            }
        }
      }
      .overlay {
        GeometryReader { geometry in
          Color.clear.onAppear{
            center = CGPoint(x: geometry.frame(in: .local).minX, y: geometry.frame(in: .local).minY)
            height = geometry.size.height
          }
        }
      }
      .padding(.all,10)
      .background(Color.listItemBackground)
      .continuousCornerRadius(18)
      .overlay {
        if let index{
          var offset:CGFloat{
            CGFloat(10+(playerCount-(index+1))*2)
          }
          Image(.memberArrow)

            .foregroundStyle(Color.memberArrow)
            .position(x:center?.x ?? 0,y: (center?.y ?? 0) + (height ?? 0)/CGFloat(Double(playerCount)/Double(index+1))-offset)
            .offset(x: -self.offset)
            .onAppear {
              withAnimation(Animation.linear(duration: 0.55).repeatForever(autoreverses: true)) {
                self.offset = 7
              }
            }
        }
      }

    }
  }
  
  struct WaveOverlay:View {
    let crt:([Color?],[Double?],[String?])

    var body: some View {
      WaveBarView(percent:0.1, rightColor: crt.0[2]! ,middleColor:crt.0[1], middleRatio:crt.1[1], leftColor: crt.0[0],leftRatio: crt.1[0])
        .overlay(
          Text(crt.2[0]!)
            .inkFont(.Splatoon2, size: 18, relativeTo: .body)
            .foregroundStyle(.white)
            .padding(.leading,10)
        ,
              alignment: .leading)
        .overlay(
          Text(crt.2[2]!)
            .inkFont(.Splatoon2, size: 18, relativeTo: .body)
            .foregroundStyle(.white)
            .padding(.trailing,10)
        ,
              alignment: .trailing)
        .background(.black.opacity(0.5))
          .clipShape(RoundedRectangle(cornerRadius: 50.0))
          .frame(height: 30)
          .padding(.horizontal,10)
          .padding(.bottom,10)


    }
  }

  struct PlayerRow:View {
    let player:VsPlayer
    let color:Color
    var body: some View {
      HStack{
        KFImage(URL(string: player.weapon.image?.url ?? ""))
          .resizable()
          .scaledToFit()
          .background(.black.opacity(0.75))
          .frame(width: 30, height: 30)
          .continuousCornerRadius(.infinity)


        VStack(alignment: .leading, spacing: 4){
          Text(player.byname)
            .inkFont(.font1, size: 9, relativeTo: .body)
            .foregroundStyle(.secondary)
          Text(player.name)
            .inkFont(.font1, size: 15, relativeTo: .body)
        }
        Spacer()

        Text("\(player.paint)p")
          .inkFont(.font1, size: 15, relativeTo: .body)
        kda
          .padding(.horizontal,5)
          .padding(.vertical, 3)
          .background(.listBackground)
          .continuousCornerRadius(10)
      }
    }

    var kda:some View{
      HStack{
        if let result = player.result{
          HStack(alignment: .bottom, spacing: 0){
            Text("x\(result.kill)")
              .inkFont(.font1, size: 15, relativeTo: .body)
            Text("<\(result.assist)>")
              .inkFont(.font1, size: 12, relativeTo: .body)
              .foregroundStyle(.secondary)
          }

          Text("x\(result.death)")
            .inkFont(.font1, size: 15, relativeTo: .body)
          VStack(spacing:1){
            if let name = player.weapon.specialWeapon?.id?.specialWeaponName{
              Image(name,replacingBlackWith:color)?
                .resizable()
                .scaledToFit()
                .frame(width: 12,height: 12)
            }
            Text("x\(result.special)")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }
        }
      }

    }
  }

}

#Preview {
  BattleDetailView(detail: MockData.getVsHistoryDetail()!)
}

struct DividerViewBuilder<Content: View, Item>: View {
  var items: [Item]
  let content: (Item) -> Content

  init(items: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
    self.items = items
    self.content = content
  }

  var body: some View {
    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
      content(item)
      if index < items.count - 1 {
        Divider()
      }
    }
  }
}


extension VsHistoryDetail {
  func getColorRatioText()->([Color?],[Double?],[String?]){
    var colors:[Color?] = []
    var ratios:[Double?] = []
    var texts:[String?] = []
    colors.append(self.myTeam.color.swiftColor)
    if self.vsRule.rule == .triColor{
      self.otherTeams.forEach { team in
        colors.append(team.color.swiftColor)
      }
    }else{
      colors.append(nil)
      colors.append(self.otherTeams[0].color.swiftColor)
    }

    if self.vsRule.rule == .turfWar || self.vsRule.rule == .triColor {
      ratios.append(self.myTeam.result!.paintRatio)
      texts.append("\((self.myTeam.result?.paintRatio)!*100)%")
      if self.vsRule.rule == .triColor{
        self.otherTeams.forEach { team in
          ratios.append(team.result?.paintRatio)
          texts.append("\((team.result?.paintRatio)!*100)%")
        }
      }else{
        ratios.append(nil)
        texts.append(nil)
        self.otherTeams.forEach { team in
          ratios.append(team.result?.paintRatio)
          texts.append("\((team.result?.paintRatio)!*100)%")
        }
      }
    }else{
      var leftScore = self.myTeam.result!.score!/100
      var rightScore = (self.otherTeams[0].result?.score)!/100
      ratios.append(leftScore/(leftScore+rightScore))
      texts.append("\((self.myTeam.result?.score)!)计数")
      ratios.append(nil)
      texts.append(nil)
      ratios.append(rightScore/(leftScore+rightScore))
      self.otherTeams.forEach { team in
        texts.append("\((team.result?.score)!)计数")
      }
    }
    return (colors, ratios, texts)
  }
}
