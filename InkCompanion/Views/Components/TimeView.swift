//
//  TimeView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import SwiftUI

struct TimerView: View {
    // 设置起始时间和持续时间
    let startTime = Date()
    let duration: TimeInterval = 60  // 持续时间为60秒

    @State private var timeRemaining: TimeInterval
    @State private var progress: Float = 0

    // 使用Timer创建一个定时器
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init() {
        // 初始化剩余时间
        _timeRemaining = State(initialValue: duration)
    }

    var body: some View {
        VStack {
            // 显示进度条
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 200)
                .animation(.linear(duration: 1), value: progress) // 添加动画
                .onReceive(timer) { _ in
                    // 更新剩余时间
                    let now = Date()
                    let elapsed = now.timeIntervalSince(startTime)
                    timeRemaining = max(duration - elapsed, 0)
                    progress = Float(elapsed / duration)

                    // 如果时间结束，停止定时器
                    if timeRemaining <= 0 {
                        timer.upstream.connect().cancel()
                    }
                }

            // 显示剩余时间
            Text("\(timeRemaining, specifier: "%.0f") seconds remaining")
        }
        .onDisappear {
            // 视图消失时停止定时器
            timer.upstream.connect().cancel()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
