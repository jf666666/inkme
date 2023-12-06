//
//  BattleView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import SwiftUI
import AlertToast

struct BattleView: View {
  @EnvironmentObject var model:BattleModel
  
    var body: some View {
      NavigationStack {
        ScrollView {
          LazyVStack {
            ForEach(0..<model.rows.count, id: \.self) { index in

              ForEach(model.rows[index],id:\.id){ detail in
                NavigationLink(value: detail.id) {
                  VStack {
                    BattleItem(detail: detail)
                      .padding([.leading, .trailing])
                      .padding(.top,3)
                  }
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
          .padding(.bottom, 16)
        }
        .fixSafeareaBackground()
        .navigationBarTitle("对战", displayMode: .inline)
        .navigationDestination(for: String.self) { id in
          if let detail = model.rows.first(where: { $0.contains(where: {$0.id == id}) })?.first(where: {$0.id == id}) {
            Text(InkUserDefaults.shared.currentUserKey ?? "no key")

          }
        }
        .navigationDestination(for: Int.self){ index in
          EmptyView()
        }
      }
      .task {
        await model.loadFromData(length: 300, filter: model.ruleFilter)
        await model.loadFromNet()
      }
      .refreshable {
        await model.loadFromNet()
      }
      .toast(isPresenting: $model.fetching, tapToDismiss: true){
        AlertToast(displayMode: .hud, type: .regular, title: "加载记录中")
      }
    }
}

#Preview {
    BattleView()
    .environmentObject(BattleModel())
}
