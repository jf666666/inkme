//
//  Haptics.swift
//  CommonKit
//
//  Created by royal on 26/12/2022.
//

import Foundation

// MARK: - Haptics

/// Helper for providing haptic feedback.
public struct Haptics {
	/// Generates a haptic feedback with specified style.
	/// - Parameter style: Haptic feedback style.
	public static func generate(_ style: HapticStyle) {
		generateHapticForCurrentPlatform(style: style)
	}
}

// MARK: - Haptics+HapticStyle

public extension Haptics {
	/// Haptic feedback style.
	enum HapticStyle {
		/// `UINotificationFeedbackGenerator.FeedbackType.error` (`SystemSoundID(1521)` on older devices).
		case error
		/// `UINotificationFeedbackGenerator.FeedbackType.success`
		case success
		/// `UINotificationFeedbackGenerator.FeedbackType.warning`
		case warning
		/// `UIImpactFeedbackGenerator.FeedbackStyle.light` (`SystemSoundID(1519)` on older devices).
		case light
		/// `UIImpactFeedbackGenerator.FeedbackStyle.medium`
		case medium
		/// `UIImpactFeedbackGenerator.FeedbackStyle.heavy` (`SystemSoundID(1520)` on older devices).
		case heavy
		/// `UIImpactFeedbackGenerator.FeedbackStyle.soft`
		case soft
		/// `UIImpactFeedbackGenerator.FeedbackStyle.rigid`
		case rigid
		/// `UISelectionFeedbackGenerator.selectionChanged()` (`SystemSoundID(1519)` on older devices).
		case selectionChanged
	}
}

extension Haptics {
  @inlinable
  static func generateIfEnabled(_ style: HapticStyle) {
//    guard Preferences.shared.enableHaptics else { return }
    generate(style)
  }
}
