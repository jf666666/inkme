//
//  CoopHistoryListitemView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/7/23.
//

import SwiftUI



struct CoopItem: View {
  let historyDetail:CoopHistoryDetail
  var clear:Bool {historyDetail.resultWave == 0}
  var resultColor:Color { clear ? AppColor.waveClearColor : AppColor.waveDefeatColor}
//  var resultColor:Color { clear ? Color(hex: "#32CD32") : Color(hex: "#8E2323")}
  var resultIcon:Image {
    switch historyDetail.gradePointDiff {
    case .UP:
      return Image(.UP)
    case .DOWN:
      return Image(.DOWN)
    case .KEEP:
      return Image(.KEEP)
    case .NONE:
      return Image(.KEEP)
    case .none:
      return Image(.KEEP)
    }
  }
  var waveCount:Int {
    if historyDetail.rule == .TEAM_CONTEST{
      return 5
    }
    return 3
  }
  var failureWave:Int{
    clear ? historyDetail.rule == .TEAM_CONTEST ? 6 : 4 : historyDetail.resultWave
  }
  var dangerRateText:String{
    let dangerRate = historyDetail.dangerRate
    if dangerRate >= 3.33{
      return "MAX!!"
    }
    return "\(Int(dangerRate*100))%"
  }
  var namespace:Namespace.ID

  var specie:[Image]{
    switch historyDetail.myResult.player.species{
    case .OCTOLING:
      return [Image(.helpOcto),Image(.helpedOcto)]
    case .INKLING:
      return [Image(.helpSquid),Image(.helpedSquid)]
    }
  }
  
  var timeText:String {
    historyDetail.playedTime.asDate.toPlayedTimeString()
  }

  var stat:CoopStatus {getCoopStats(coop: historyDetail)}
  @EnvironmentObject var model: CoopModel

  var body: some View {
      item
        .padding(.top, 7.5)
        .padding(.bottom, 7)
        .padding([.leading, .trailing], 8)
        .background(Color(.listItemBackground))
        .frame(height: 85)
        .contextMenu{
          Button(action: {
            let image = imageFromView( CoopDetailView(detail: historyDetail, namespace: namespace), size: CGSize(width: 400, height: stat.rule == CoopRule.TEAM_CONTEST.rawValue ? 1450 : 1300))
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          }) {
            Label("保存至相册", systemImage: "photo.on.rectangle")
          }

          Button(action: {
            let image = imageFromView( CoopDetailView(detail: historyDetail, namespace: namespace,showMemberName: false), size: CGSize(width: 400, height: stat.rule == CoopRule.TEAM_CONTEST.rawValue ? 1450 : 1300))
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          }) {

            Label("保存至相册(打码)", systemImage: "photo.on.rectangle")
          }

          Button(action: {

          }) {
            Label("取消",systemImage: "x.circle")
          }

        }  preview: {
          CoopDetailView(detail: historyDetail, namespace: namespace)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

  }

  var item:some View{
    VStack(spacing: 0){
      
      HStack(spacing:6){
        if let afterGradeName = historyDetail.afterGrade?.id, let afterGradePoint = historyDetail.afterGradePoint{
          Text(afterGradeName.localizedString)
            .inkFont(.font1, size: 12, relativeTo: .body)
          Text("\(Int(afterGradePoint))")
            .inkFont(.Splatoon2, size: 12, relativeTo: .body)
          Rectangle()
            .foregroundColor(.clear)
            .overlay(
              resultIcon,
              alignment: .leading
            )
            .frame(width: 13, height:13)
            .padding([.top, .bottom], 0.5)
        }
        Spacer()
        
        HStack{
          Text(historyDetail.coopStage.id.localizedString)
            .inkFont(.font1, size: 12, relativeTo: .body)
          if let bossResult = historyDetail.bossResult{
            Text("/\(bossResult.boss.id.localizedString)")
              .inkFont(.font1, size: 12, relativeTo: .body)
              .foregroundStyle(bossResult.hasDefeatBoss ? Color.waveClear : Color.waveDefeat)
          }
        }

      }
      .padding(.bottom,3)

      HStack{
        Text(clear ? "Clear!!" : "Failure")
          .inkFont(.Splatoon2, size: 14, relativeTo: .body)

        Spacer()

        HStack{
          HStack(spacing: 3){
            specie[0]
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
            Text("\(historyDetail.myResult.rescueCount)")
              .inkFont(.Splatoon1, size: 10, relativeTo: .body)
          }

          HStack(spacing: 3){
            specie[1]
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
            Text("\(historyDetail.myResult.rescuedCount)")
              .inkFont(.Splatoon1, size: 10, relativeTo: .body)
          }

          HStack(spacing: 3){
            Image(.golden)
              .resizable()
              .scaledToFit()
              .frame(width: 12, height: 12)
            Text("\(stat.team.golden)")
              .inkFont(.Splatoon1, size: 10, relativeTo: .body)
          }

          HStack(spacing: 3){
            Image(.egg)
              .resizable()
              .scaledToFit()
              .frame(width: 12, height: 12)
            Text("\(stat.team.power)")
              .inkFont(.Splatoon1, size: 10, relativeTo: .body)
          }

        }
        .layoutPriority(1)
      }
      .padding(.bottom, 3)

      HStack{
        ForEach(Array(1...waveCount), id: \.self){index in
          Rectangle()
            .foregroundColor(failureWave > index ? resultColor : Color(.systemGray3))
            .frame(height: 5)
            .clipShape(Capsule())
        }
      }
//      .padding(.bottom, 0)

      HStack {
        Text("危险度").font(.custom(InkFont.font1.rawValue, size: 10))+Text(dangerRateText)
          .font(.custom(InkFont.Splatoon1.rawValue, size: 10))
        Spacer()
        Text(timeText)
          .inkFont(.Splatoon1, size: 10, relativeTo: .body)
      }
      .foregroundColor(Color(.systemGray2))

    }
  }
}

struct CoopItemView_Preview:PreviewProvider{
  @Namespace static var namespace
  static var previews: some View {
    CoopItem(historyDetail: MockData.getCoopHistoryDetail(),namespace: namespace)
      .padding(.top, 8)
      .padding([.leading, .trailing])
      .background(.black)
      .frame(width: 300)
      .previewLayout(.sizeThatFits)
      .environmentObject(CoopModel())
  }
}
