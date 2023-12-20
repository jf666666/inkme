//
//  GameMode.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

// MARK: - GameMode

/// Data model for the game modes.
enum GameMode: String, Identifiable, CaseIterable, Equatable {
  static let `default`: Self = .battle

  case battle
  case salmon

  var id: String { rawValue }
}

extension GameMode {
  var name: String {
    switch self {
    case .battle: "Battle"
    case .salmon: "Salmon Run"
    }
  }

  var shortName: String {
    switch self {
    case .battle: "Battle"
    case .salmon: "Salmon"
    }
  }
}

extension GameMode {
  var sfSymbolNameIdle: String {
    switch self {
    case .battle: "flag"
    case .salmon: "lifepreserver"
    }
  }
}

extension GameMode {
  var sfSymbolNameSelected: String {
    switch self {
    case .battle: "flag.fill"
    case .salmon: "lifepreserver.fill"
    }
  }
}
