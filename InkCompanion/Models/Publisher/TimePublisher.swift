//
//  TimePublisher.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/9/23.
//

import Foundation
import Combine

final class TimePublisher: ObservableObject {

  static let shared: TimePublisher = .init()

  /// Updates every `1` second.
  @Published private(set) var currentTime: Date = .init()
  /// Signals auto-load checks every `2` seconds.
  let autoLoadCheckPublisher: PassthroughSubject<Void, Never> = .init()
  /// Signals icon bounces every `7` seconds.
  let bounceSignalPublisher: PassthroughSubject<Void, Never> = .init()

  /// Contains all the active subscriptions for this object.
  private var cancellables = Set<AnyCancellable>()

  // MARK: Lifecycle

  private init() {
    startPublishingCurrentTime()
    startPublishingAutoLoadChecks()
    startPublishingBounceSignal()
  }

  // MARK: Private

  /// Starts the process of publishing the `currentTime` property every second.
  private func startPublishingCurrentTime() {
    Timer
      .publish(
        every: 1,
        tolerance: 0.1,
        on: .main,
        in: .common)
      .autoconnect()
      .sink { [weak self] time in
        self?.currentTime = time
      }
      .store(in: &cancellables)
  }

  /// Starts the process of publishing auto-load check signals every `autoLoadCheckSignalInterval`.
  private func startPublishingAutoLoadChecks() {
    Timer
      .publish(
        every:5,
        tolerance: 0.1,
        on: .main,
        in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.autoLoadCheckPublisher.send(())
      }
      .store(in: &cancellables)
  }

  /// Starts the process of publishing bounce signals every `bounceSignalInterval`.
  private func startPublishingBounceSignal() {
    Timer
      .publish(
        every: 7,
        tolerance: 0.1,
        on: .main,
        in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.bounceSignalPublisher.send(())
      }
      .store(in: &cancellables)
  }
}
