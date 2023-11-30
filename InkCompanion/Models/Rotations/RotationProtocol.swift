//
//  RotationProtocol.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import Foundation

// MARK: - Rotation

/// Protocol that defines the requirements for a rotation.
///
/// A rotation event has a unique identifier, a time range during which it occurs,
/// and should be describable, equatable, and hashable.
///
/// Conforming types should primarily implement the `description` property and set
/// the values for `startTime` and `endTime`.
protocol Rotation: Identifiable, CustomStringConvertible, Equatable, Hashable {
  /// Uniquely identifies a rotation event based on its time range.
  ///
  /// The default implementation combines the Unix timestamps of the `startTime` and `endTime`.
  var id: String { get }

  /// Provides a string representation of a rotation event.
  ///
  /// This is primarily used for debugging and also serves as the basis for generating hash values.
  var description: String { get }

  /// The time when the rotation event starts.
  var startTime: Date { get }

  /// The date and time when the rotation event ends.
  var endTime: Date { get }
}

extension Rotation {
  /// Default implementation of the `id` property.
  ///
  /// Constructs the ID by combining the Unix timestamps of the `startTime` and `endTime` properties.
  var id: String { "\(startTime)-\(endTime)" }

  // MARK: Internal

  /// Equates two `Rotation` instances based on their `hashValue`s.
  ///
  /// - Parameters:
  ///   - lhs: The `Rotation` instance on the left-hand side of the operator.
  ///   - rhs: The `Rotation` instance on the right-hand side of the operator.
  /// - Returns: A Boolean value indicating whether the two instances are equal.
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.hashValue == rhs.hashValue
  }

  /// Computes the hash value for this `Rotation` instance.
  ///
  /// This method is explicitly implemented to support `Hashable` conformance,
  /// particularly when not all properties of the conforming type are hashable.
  /// The hash value is generated using the `description` property.
  ///
  /// - Parameter hasher: The hasher to use for combining the hash components of this instance.
  func hash(into hasher: inout Hasher) {
    hasher.combine(description)
  }
}

extension Rotation {
  /// Determines whether the rotation has expired based on the current time.
  func isExpired(_ currentTime: Date) -> Bool {
    endTime <= currentTime
  }

  /// Determines whether the rotation is currently active based on the current time.
  func isCurrent(_ currentTime: Date) -> Bool {
    startTime <= currentTime &&
      endTime > currentTime
  }

  /// Determines whether the rotation is scheduled for the future based on the current time.
  func isFuture(_ currentTime: Date) -> Bool {
    startTime > currentTime
  }
}

