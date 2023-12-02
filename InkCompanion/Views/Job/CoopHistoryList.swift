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


struct CoopHistoryList: View {
  @Environment(\.managedObjectContext) var context
  @EnvironmentObject var model: CoopModel
  @Namespace var namespace
  @State private var showingDateRangePicker = false

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
                CoopHistoryListItem(historyDetail: detail, namespace: namespace)
                  .padding([.leading, .trailing])
                  .padding(.top,3)
              }
              .buttonStyle(PlainButtonStyle())
            }
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
      await model.loadFromData(length: 500)
      await model.loadFromNet()
    }
    .refreshable {
      await model.loadFromNet()
    }
  }

  var coopDetail:some View {
    CoopDetailView(detail: model.selectedHistory ?? MockData.getCoopHistoryDetail(),namespace: namespace)
  }

  @ViewBuilder
  private var titleMenu: some View {
    ForEach(CoopRule.allCases, id:\.rawValue) { rule in
      Button {
        model.selectedRule = rule
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
        Label("ContentView.NavigationButton.Settings", systemImage: "calendar")
      }
    }
  }

}



#Preview {
  CoopHistoryList()
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



