//
//  CoopShiftCard.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/23/23.
//

import SwiftUI
import Kingfisher

struct CoopSummaryCard: View {
  // MARK: init
  let details:[CoopHistoryDetail]

  // MARK: computed variables
  var stats:[CoopStatus] {details.compactMap { detail in
    let s = getCoopStats(coop: detail)
    if s.exempt{
      return nil
    }
    return s
  }}
  var weapons:[String] {details[0].weapons.map{$0.image!.url!}}
  var stage:String {stats[0].stage}
  var timeSpanText:String {
    let start = stats.min { $0.time < $1.time }!.time
    let end = stats.max { $0.time < $1.time }!.time
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd HH:mm"
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
  var specie:[Image]{
    switch details[0].myResult.player.species{
    case .OCTOLING:
      return [Image(.helpOcto),Image(.helpedOcto)]
    case .INKLING:
      return [Image(.helpSquid),Image(.helpedSquid)]
    }
  }

  var body: some View {
    VStack(spacing: -1){
      HStack{
        VStack(alignment: .leading,spacing: 0){
          Text(timeSpanText)
            .inkFont(.Splatoon1, size: 12, relativeTo: .body)
          VStack(alignment: .leading,spacing: 3){
            HStack(spacing: 16){
              HStack(spacing: 3){
                Image(systemName: "checkmark")
                  .resizable()
                  .bold()
                  .foregroundStyle(Color(.spGreen))
                  .frame(width: 12,height: 12)
                Text("\(averageClear, places:1)")
                  .inkFont(.Splatoon1, size: 12, relativeTo: .body)
              }
              .frame(width: 45, alignment: .leading)

              HStack(spacing: 3){
                Image(.golden)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 12, height: 12)
                Text("\(goldenDeliver, places:1)")
                  .font(.custom(InkFont.Splatoon1.rawValue, size: 12)) + Text("<\(goldenAssist, places:1)>")
                  .font(.custom(InkFont.Splatoon1.rawValue, size: 9)).foregroundColor(.secondary)
              }
            }

            HStack(spacing: 8){
              HStack(spacing: 3){
                specie[0]
                  .resizable()
                  .scaledToFit()
                  .frame(width: 20, height: 20)
                Text("\(rescue, places:1)")
                  .inkFont(.Splatoon1, size: 12, relativeTo: .body)

              }
              .frame(width: 45, alignment: .leading)

              HStack(spacing: 3){
                specie[1]
                  .resizable()
                  .scaledToFit()
                  .frame(width: 20, height: 20)
                Text("\(rescued, places:1)")
                  .inkFont(.Splatoon1, size: 12, relativeTo: .body)

              }
              HStack(spacing: 3){
                Image(systemName: "eraser")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 20, height: 20)
                  .foregroundStyle(Color.waveClear)
                Text("\(wave, places:1)")
                  .inkFont(.Splatoon1, size: 12, relativeTo: .body)

              }

            }

          }
        }

        Spacer()

        VStack(alignment: .trailing,spacing: 10){
          Text(stage.localizedString)
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(.secondary)

          HStack{
            ForEach(0..<4,id: \.self){ i in
              KFImage(URL(string: weapons[i]))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            }
          }
          .padding([.leading, .trailing], 10)
          .padding([.top, .bottom], 6)
          .background(Color(.sRGB, white: 151 / 255.0, opacity: 0.1))
          .continuousCornerRadius(7)
        }
        .padding(.bottom, 2)
      }
      .padding([.leading, .top, .trailing], 13)
      .padding(.bottom, 11)
      .frame(height: 79)
      .background(
        GrayscaleTextureView(
          texture: .bubble,
          foregroundColor: AppColor.battleDetailStreakForegroundColor,
          backgroundColor: AppColor.listItemBackgroundColor
        )
        .frame(height: 100),
        alignment: .topLeading
      )
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

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
                Image(.jobShiftCardTail)
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
    .frame(height: 97)
    .padding(.top, 5)

  }
}

#Preview {
  CoopSummaryCard(details: [MockData.getCoopHistoryDetail()])
    .preferredColorScheme(.dark)
}
