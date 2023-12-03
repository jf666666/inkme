//
//  CoopDetailView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/20/23.
//

import SwiftUI
import Kingfisher

struct CoopDetailView: View {

  @Environment(\.presentationMode) var presentationMode


  let detail:CoopHistoryDetail
  var namespace:Namespace.ID
  var showMemberName:Bool = true
  
  var clear:Bool {detail.resultWave == 0}
  var stat:CoopStatus{getCoopStats(coop: detail)}
  var stage:StageSelection{
    StageSelection(rawValue: stat.stage) ?? .MaroonersBay
  }

  var body: some View {

    ScrollView{
      HStack {
        Spacer()
        VStack(spacing:20){
          card
          wave
          member
          enemy
        }
        Spacer()
      }
      .padding(.horizontal,8)
    }
    .frame(maxWidth: .infinity)
    .fixSafeareaBackground()

  }

  var card:some View{
    TopCard(stats: stat)
      .padding([.leading, .trailing], 12)
      .padding(.top, 9)
      .padding(.bottom, 8)
      .textureBackground(texture: .bubble, radius: 18)
  }

  var wave: some View {
      VStack {
          if stat.rule == CoopRule.TEAM_CONTEST.rawValue && detail.waveResults.count > 4 {
              waveResultsView(range: 0..<3)
              waveResultsView(range: 3..<5)
          } else {
              waveResultsView(range: detail.waveResults.indices)
          }
      }
  }

  var enemy:some View {
    VStack(spacing:2){
      ForEach(detail.enemyResults,id: \.enemy.id){ enemy in
        if enemy.enemy.id != detail.enemyResults[0].enemy.id{
          line
        }
        enemyResult(result: enemy)
          .frame(height: 40)
      }
    }
    .padding(.all,10)
    .textureBackground(texture: .bubble, radius: 18)
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

  var member:some View{
    VStack(spacing:2){
      Group {
        playerResult(result: detail.myResult)
        ForEach(detail.memberResults,id: \.player.id){ result in
          line
          playerResult(result: result,showName: showMemberName)
        }
      }
    }
    .padding(.all,10)
    .textureBackground(texture: .bubble, radius: 18)
  }

  private func waveResultsView(range: Range<Int>) -> some View {
      HStack(alignment: .top, spacing: 10) {
          ForEach(range, id: \.self) { waveIndex in
              let waveResult = detail.waveResults[waveIndex]
              WaveResult(result: waveResult, pass: isWavePassed(waveResult), bossName: detail.bossResult?.boss.name)
                  .rotationEffect(.degrees(-2))
          }
      }
  }

  private func isWavePassed(_ waveResult: CoopWaveResult) -> Bool {
      if waveResult.waveNumber == 4, let bossResult = detail.bossResult {
          return bossResult.hasDefeatBoss
      }
      return detail.resultWave == 0 || waveResult.waveNumber != detail.waveResults.count
  }
}

struct CoopDetailView_Previews:PreviewProvider{
  @Namespace static var namespace

  static var previews: some View{
    CoopDetailView( detail: MockData.getCoopHistoryDetail(),namespace: namespace)
  }
}

