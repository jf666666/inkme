//
//  CoopListItem.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/17/23.
//

import SwiftUI
import Combine
import CoreData
import Foundation


struct CoopView: View {
  @Environment(\.managedObjectContext) var context
  @EnvironmentObject var model: CoopModel
  @Namespace var namespace
  @State private var showingDateRangePicker = false
  @Environment(\.scenePhase) private var phase

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack {
          ForEach(0..<model.rows.count, id: \.self) { index in
            NavigationLink(value: index) {
              CoopSummaryCard(details: model.rows[index])
                .rotationEffect(.degrees(-1))
                .clipped(antialiased: true)
                .padding([.leading, .trailing])
                .padding(.top, 15)
                .padding(.bottom, 0.1)

            }
            .buttonStyle(PlainButtonStyle())

            ForEach(model.rows[index]){ detail in
              NavigationLink(value: detail.id) {
                CoopItem(historyDetail: detail, namespace: namespace)
                  .padding([.leading, .trailing])
                  .padding(.top,3)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          Button {
            Task{
             await model.reloadFromData()
            }
          } label: {
            Text("加载更多")
              .inkFont(.font1, size: 12, relativeTo: .body)
          }

        }
        .padding(.bottom, 16)
      }
      .fixSafeareaBackground()
      .navigationBarTitle(model.navigationTitle, displayMode: .inline)
      .navigationDestination(for: String.self) { id in
        if let detail = model.rows.first(where: { $0.contains(where: {$0.id == id}) })?.first(where: {$0.id == id}) {
          CoopDetailView(detail: detail, namespace: namespace)
        }
      }
      .navigationDestination(for: Int.self){ index in
        CoopSummaryDetail(details: model.rows[index])
      }
      .toolbarTitleMenu{
        titleMenu
      }
      .toolbar {
        toolbarMenu
      }
    }
    .sheet(isPresented: $showingDateRangePicker) {
      DatePickerView { start, end in
        Task{
          await model.selectTimeRange(start: start, end: end)
        }
      }
      .presentationDetents([.medium, .large])
      .padding()
    }
    .task {

      model.rows = []

      await model.loadFromData(length: 500)
      await model.loadFromNet()
    }
    .refreshable {
            await model.loadFromNet()

    }
    .onChange(of: phase) { newPhase in
         switch newPhase {
         case .active:
           Task{
             await model.loadFromNet()
           }
         default: break
         }
     }

  }

  var coopDetail:some View {
    CoopDetailView(detail: model.selectedHistory ?? MockData.getCoopHistoryDetail(),namespace: namespace)
  }

  @ViewBuilder
  private var titleMenu: some View {
    ForEach(CoopRule.allCases, id:\.rawValue) { rule in
      Button {
        DispatchQueue.main.async {
          model.selectedRule = rule
        }
        model.navigationTitle = rule.name
        Task{
          await model.selectRule(rule: rule)
        }
      } label: {
        Label(
          title: { Text("\(rule.name)") },
          icon: { rule.icon }
        )
      }
    }
  }

  @ToolbarContentBuilder
  private var toolbarMenu: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      Button {
        showingDateRangePicker = true
      } label: {
        Label("MainView.NavigationButton.Settings", systemImage: "calendar")
      }
    }
  }

}



#Preview {
  CoopView()
    .environmentObject(CoopModel())
}

struct DatePickerView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var startDate = Date()
  @State private var endDate = Date()

  // 定义闭包类型
  var onDateSelected: (Date, Date) -> Void

  var body: some View {
    VStack {
      DatePicker("起始日期", selection: $startDate, displayedComponents: .date)
      DatePicker("结束日期", selection: $endDate, displayedComponents: .date)
      Button("确定") {
        presentationMode.wrappedValue.dismiss()
        onDateSelected(startDate, endDate) //调用闭包并传递日期
      }
    }
  }
}



