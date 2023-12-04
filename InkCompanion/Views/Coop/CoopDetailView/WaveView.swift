//
//  WaveView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import SwiftUI
import Charts
import Kingfisher



extension CoopDetailView {

  struct WaveResult:View {
    let result:CoopWaveResult
    let pass:Bool
    let bossName:String?
    var isBossWave:Bool {result.waveNumber == 4 && result.teamDeliverCount == nil}
    let waterLevel = ["干潮","普通","涨潮"]
    var waveHeight: CGFloat {
        switch result.waterLevel {
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
              if isBossWave{
                Text("EX-WAVE")

                Text("\(bossName!)")

              }else{
                Text("WAVE \(result.waveNumber)")

                Text("\(result.teamDeliverCount!)/\(result.deliverNorm!)")

              }

              Text("\(waterLevel[result.waterLevel])")
              if result.eventWave == nil {
                Text("-")

              }else{
                Text("\(result.eventWave!.name)")
                  .scaledLimitedLine(lineLimit: 1)
              }
              HStack(spacing:0){
                Image(.golden)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 10, height: 10)
                Text("x\(result.goldenPopCount)").font(.custom(InkFont.font1.rawValue, size: 10))
              }
              Text("出现数量").font(.custom(InkFont.font1.rawValue, size: 8))
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
        .overlay {
          Text(pass ? "GJ!" : "NG")
            .inkFont(.font1, size: 12, relativeTo: .body)
            .foregroundStyle(pass ? AppColor.waveClearColor : AppColor.waveDefeatColor)
            .position(x:80,y:3)
        }

        let columns = Array(repeating: GridItem(.fixed(13)), count: min(result.specialWeapons.count, 4))
        LazyVGrid(columns: columns, spacing: 2) {
          ForEach(0..<result.specialWeapons.count, id: \.self){index in
            Rectangle()
              .overlay {
                KFImage(URL(string: result.specialWeapons[index].image?.url ?? ""))
                  .resizable()
                  .scaledToFit()
                  .frame(width: 12, height: 12)
              }
              .foregroundStyle(Color.salmonRunSpecialBackground)
              .frame(width: 13, height: 13)
              .clipShape(Capsule())
          }
        }
        .frame(width: 85)
      }
      

    }
  }
}

