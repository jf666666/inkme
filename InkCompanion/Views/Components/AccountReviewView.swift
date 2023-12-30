//
//  AccountReviewView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/20/23.
//

import SwiftUI
import Kingfisher

struct AccountReviewView: View {
  @StateObject var model = AccountReviewViewModel()

  let coopResult = MockData.getCoopResult()
  var body: some View {
    VStack(alignment:.leading) {
      HStack(alignment: .top, spacing: 6) {
        if let thumbnailUrl = model.historyRecord?.data.currentPlayer.userIcon?.url{
          KFImage(URL(string: thumbnailUrl))
            .resizable()
            .frame(width: 60, height: 60)
            .background(Color.systemGray5)
            .clipShape(Capsule())
        } else {
          Capsule()
            .foregroundColor(.secondary)
            .frame(width: 60, height: 60)
        }

        VStack(alignment: .leading, spacing: 3) {
          HStack(alignment: .lastTextBaseline) {
            Text(model.historyRecord?.data.currentPlayer.name ?? "----")
              .inkFont(.font1, size: 20, relativeTo: .body)
              .scaledLimitedLine()
              .foregroundStyle(.appLabel)
              .frame(width: 50, height: 20)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
              Text("★")
                .inkFont(.font1, size: 15, relativeTo: .body)
                .foregroundStyle(.spYellow)

              Text("\(model.historyRecord?.data.playHistory.rank ?? 0)")
                .inkFont(.font1, size: 13, relativeTo: .body)

            }
            HStack(alignment: .bottom, spacing: 3) {
              Image(.anarchy)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .offset(y:1)
              HStack(alignment: .bottom, spacing:0){
                Text("\(model.historyRecord?.data.playHistory.udemae ?? "-")")
                  .inkFont(.font1, size: 13, relativeTo: .body)
                Text("\(model.historyRecord?.data.playHistory.udemaeMax ?? "-")")
                  .inkFont(.font1, size: 10, relativeTo: .body)
                  .foregroundStyle(.secondary)
              }
            }

          }
          if let player = model.historyRecord?.data.currentPlayer{
            NameplateView(currentPlayer: player)
              .frame(height: 40)
          }
        }
        
      }
      AutoRotatingTabView {
        MedalRow(icon: Image(.anarchy), description: "蛮颓开放", history: model.historyRecord?.data.playHistory.bankaraMatchOpenPlayHistory)
          .tag(0)
        MedalRow(icon: Image(.event), description: "活动比赛", history: model.historyRecord?.data.playHistory.leagueMatchPlayHistory)
          .tag(1)
        MedalRow(icon: Image(.coopTeamContest), description: "打工竞赛", history: model.historyRecord?.data.playHistory.leagueMatchPlayHistory)
          .tag(2)
      }
      .frame(height: 55)

//      FriendsView()
    }
    .padding(.all,10)
    .background(.listItemBackground)
    .continuousCornerRadius(18)
  }

  struct MedalRow:View {
    let icon:Image
    let description:String
    let history:PlayHistoryTrophyRecord?
    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
          Rectangle()
              .frame(maxWidth: .infinity)
              .frame(height: 1.0 / UIScreen.main.scale)
              .foregroundColor(.separator)
              .padding(.leading, 62)
              .padding(.bottom, 12)

          HStack(alignment: .top) {
              HStack {
                Spacer()
                VStack {
                  icon
                    .resizable()
                    .scaledToFit()
                  .frame(width: 32)
                  Text(description)
                    .inkFont(.font1, size: 8, relativeTo: .body)
                    .foregroundStyle(.secondary)
                }
                  Spacer()
              }
              .frame(width: 72)

              VStack(alignment: .leading, spacing: 7) {
                MedalView(history: history ?? PlayHistoryTrophyRecord(), icon: Image(.event))

                HStack(spacing: 5) {
                    Text("参加次数")
                        .font(.system(size: 10))
                        .foregroundColor(.secondaryLabel)

                  Text("\(history?.attend ?? 0)")
                        .font(.system(size: 10, weight: .semibold).monospacedDigit())
                        .foregroundColor(AppColor.appLabelColor)
                }
              }
          }
      }
      .padding(0)
    }
  }
  struct MedalView:View {
    let history:PlayHistoryTrophyRecord
    let icon:Image
    var body: some View {
      VStack(alignment: .trailing) {
        HStack(alignment: .bottom) {
//          icon
//            .resizable()
//            .scaledToFit()
//            .frame(width:20, height: 20)
          HStack(alignment:.bottom, spacing:0){
            Image(.trophyGold)
              .resizable()
              .scaledToFit()
              .frame(width:25, height: 25)
            Text("x\(history.gold)")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }
          HStack(alignment:.bottom, spacing:0){
            Image(.trophySilver)
              .resizable()
              .scaledToFit()
              .frame(width:25, height: 25)

            Text("x\(history.silver)")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }
          HStack(alignment:.bottom, spacing:0){
            Image(.trophyBronze)
              .resizable()
              .scaledToFit()
              .frame(width:25, height: 25)

            Text("x\(history.bronze)")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }
        }
      }

    }
  }
}


#Preview {
  AccountReviewView(model: AccountReviewViewModel(preview:true))
    .padding(.horizontal, 16)
    .fixSafeareaBackground()
}


class AccountReviewViewModel:ObservableObject{
  @Published var historyRecord:HistoryRecordQuery?
  private let inkNet = InkNet.shared
  init() {
    Task{@MainActor in
      self.historyRecord = await inkNet.fetchHistoryRecord()
    }
  }
  init(preview:Bool){
    self.historyRecord = MockData.getHistoryRecord()
  }
}
