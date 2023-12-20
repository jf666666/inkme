//
//  SalmonRunStatsPage.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/16/23.
//

import SwiftUI

struct SalmonRunStatsPage: View {
  @StateObject var model = SalmonRunStatsViewModel()
  var body: some View {
    VStack {
      if let coopRecord = model.coopRecord {
        ScrollView{
          HStack {
            Spacer()
            VStack(spacing:20){
//              Picker{
//                
//              }

              VStack(spacing: 5){

                HStack {
                  Image(.salmonRun)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                  Text("最高分数")
                    .inkFont(.font1, size: 25, relativeTo: .title)
                    .foregroundStyle(.salmonRunTheme)
                }

                StageRecord(stageHighestRecords: coopRecord.stageHighestRecords)
                  .padding(.leading, 0)
                  .padding(.vertical,0)
                  .textureBackground(texture: .streak, radius: 18)
              }

              VStack{
                HStack {
                  Image(.salmonRun)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                  Text("击倒数量")
                    .inkFont(.font1, size: 25, relativeTo: .title)
                    .foregroundStyle(.salmonRunTheme)
                }
                HStack(spacing:20){
                  ForEach(coopRecord.defeatBossRecords, id:\.enemy.id){boss in
                    VStack{
                      boss.enemy.enemy.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                      Text("\(boss.defeatCount)")
                        .inkFont(.font1, size: 15, relativeTo: .body)
                    }
                  }
                }

                EnemyView(defeatEnemyRecords: coopRecord.defeatEnemyRecords)
                  .padding(.all)
                  .background(.listItemBackground)
                  .continuousCornerRadius(18)
              }



            }
            Spacer()
          }
          .padding(.horizontal,8)
        }
        .frame(maxWidth: .infinity)
        .fixSafeareaBackground()
      } else {
        ProgressView()
      }
    }
  }


  struct EnemyView:View {
    let defeatEnemyRecords:[DefeatEnemyRecord]
    var body: some View {
      VStack {
        DividerViewBuilder(items: defeatEnemyRecords){enemy in
          HStack{
            enemy.enemy.enemy.image
              .resizable()
              .scaledToFit()
              .frame(width:35, height: 35)
            Text("\(enemy.enemy.enemy.rawValue.localizedString)")
              .inkFont(.font1, size: 15, relativeTo: .body)
            Spacer()
            Text("\(enemy.defeatCount)")
              .inkFont(.font1, size: 15, relativeTo: .body)
          }
        }
      }
    }
  }

  struct StageRecord:View {
    let stageHighestRecords:[StageHighestRecord]
    var body: some View {
      VStack{
        DividerViewBuilder(items: stageHighestRecords) { stageRecord in
          HStack(spacing:0){
            Spacer()
            VStack(alignment:.leading,spacing: 10){
              HStack {
                Text("\(stageRecord.coopStage.stage.name)")
                  .inkFont(.font1, size: 15, relativeTo: .body)
                  .scaledLimitedLine()
                Spacer()
              }

              HStack(spacing:5){
                Text("最高评价")
                  .foregroundStyle(.secondary)
                Text("\(stageRecord.grade.id ?? "")".localizedString)
                Text("\(stageRecord.gradePoint)")
              }
              .inkFont(.font1, size: 15, relativeTo: .body)
            }
            stageRecord.coopStage.stage.image
              .resizable()
              .scaledToFit()
              .continuousCornerRadius(10)
              .frame(width:150, height: 80)




          }
        }
      }
    }
  }
}

#Preview {
  SalmonRunStatsPage(model: SalmonRunStatsViewModel(preview: true))
}

class SalmonRunStatsViewModel:ObservableObject{
  @Published var coopRecord:CoopRecord?

  private let inkNet:InkNet = .shared

  init() {
    Task{@MainActor in
      await loadCoopRecord()
    }
  }

  init(preview:Bool){
    if preview{
      self.coopRecord = MockData.getCoopRecord()
    }
  }

  @MainActor
  func loadCoopRecord() async {
    self.coopRecord = await inkNet.fetchCoopRecord()
  }
}
