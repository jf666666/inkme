//
//  AutoRotatingTabView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/21/23.
//

import SwiftUI

struct AutoRotatingTabView<Content: View>: View {
    private var content: Content
    private var pauseDuration: TimeInterval

    @StateObject private var timerData: TimerData

    init(pauseDuration: TimeInterval = 5, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.pauseDuration = pauseDuration
        self._timerData = StateObject(wrappedValue: TimerData())
    }

    var body: some View {
        TabView(selection: $timerData.index) {
            content
        }
//        .orientation(.vertical)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            timerData.startTimer()
        }
        .onDisappear {
            timerData.stopTimer()
        }
        .onTapGesture {
            timerData.handleTap(pauseDuration: pauseDuration)
        }
        .onChange(of: timerData.index) { newValue in
          // 当到达最后一个tab时，切换回第一个tab
          if newValue == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 延时以完成滑动动画
              withAnimation(.linear(duration: 2)) {
                timerData.index = 0
              }
            }
          }
        }
    }
}

class TimerData: ObservableObject {
    @Published var index = 0
    var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            withAnimation(.linear(duration: 2)) {
              self?.index = ((self?.index ?? 0) + 1) % 3
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func handleTap(pauseDuration: TimeInterval) {
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) { [weak self] in
            self?.startTimer()
        }
    }
}

