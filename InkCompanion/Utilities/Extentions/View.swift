//
//  View.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/10/23.
//

import SwiftUI

extension View {
  /// This function will transform a view by the application of a higher order function.
  ///
  /// ### Usage example: ###
  /// ```
  /// var body: some view {
  ///   myView
  ///     .apply { $0.padding(8) }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - transformation: The transform function/modifier.
  ///
  /// - Returns: The resulted view.
  @ViewBuilder
  func apply(
    _ transformation: (Self) -> some View)
    -> some View
  {
    transformation(self)
  }

  /// This function will apply transform to our view when condition is true,
  /// otherwise it will leave the original view untouched.
  ///
  /// ### Usage example: ###
  /// ```
  /// var body: some view {
  ///   myView
  ///     .if(X) { $0.padding(8) }
  ///     .if(Y) { $0.background(Color.blue) }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - condition: The condition for the transform.
  ///   - transformation: The transform function/modifier.
  ///
  /// - Returns: The resulted view.
  @ViewBuilder
  func `if`(
    _ condition: Bool,
    transformation: (Self) -> some View)
    -> some View
  {
    if condition { transformation(self) }
    else { self }
  }

  /// This function will apply a transform to our view when condition is true,
  /// and the another transform to the view otherwise.
  ///
  /// ### Usage example: ###
  /// ```
  /// var body: some view {
  ///   myView
  ///     .if(X) { $0.padding(8) } else: { $0.background(Color.blue) }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - condition: The condition for the transform.
  ///   - trueTransformation: The transform to apply if the condition is true.
  ///   - falseTransformation: The condition to apply for the transform is false.
  ///
  /// - Returns: The resulted view.
  @ViewBuilder
  func `if`(
    _ condition: Bool,
    if trueTransformation: (Self) -> some View,
    else falseTransformation: (Self) -> some View)
    -> some View
  {
    if condition { trueTransformation(self) }
    else { falseTransformation(self) }
  }

  /// This function will apply a transform to our view if the value is non-nil.
  ///
  /// ### Usage example: ###
  /// ```
  /// var body: some view {
  ///   myView
  ///     .ifLet(optionalColor) { $0.foregroundStyle($1) }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - value: The optional value to evaluate.
  ///   - transformation: The transform function/modifier.
  ///
  /// - Returns: The resulted view.
  @ViewBuilder
  func ifLet<V>(
    _ value: V?,
    transformation: (Self, V) -> some View)
    -> some View
  {
    if let value { transformation(self, value) }
    else { self }
  }

  /// This function will apply a transform to our view if the value is nil.
  ///
  /// ### Usage example: ###
  /// ```
  /// var body: some view {
  ///   myView
  ///     .ifNil(optionalValue) { $0.hidden() }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - value: The optional value to evaluate.
  ///   - transformation: The transform function/modifier.
  ///
  /// - Returns: The resulted view.
  @ViewBuilder
  func ifNil(
    _ value: (some Any)?,
    transformation: (Self) -> some View)
    -> some View
  {
    if value == nil { transformation(self) }
    else { self }
  }

}

extension View {
  /// Adjusts the horizontal alignment of the view.
  ///
  /// This function extends the `View` by providing a more readable way to set horizontal alignment.
  /// The view is aligned within an infinite width to achieve the desired horizontal alignment.
  ///
  /// - Parameters:
  ///   - alignment: The horizontal alignment type. Defaults to `.center`.
  ///
  /// - Returns: A view that adjusts its alignment according to the specified parameter.
  @ViewBuilder
  func hAlignment(_ alignment: Alignment = .center) -> some View {
    frame(
      maxWidth: .infinity,
      alignment: alignment)
  }

  /// Adjusts the vertical alignment of the view.
  ///
  /// This function extends the `View` by providing a more readable way to set vertical alignment.
  /// The view is aligned within an infinite height to achieve the desired vertical alignment.
  ///
  /// - Parameters:
  ///   - alignment: The vertical alignment type. Defaults to `.center`.
  ///
  /// - Returns: A view that adjusts its alignment according to the specified parameter.
  @ViewBuilder
  func vAlignment(_ alignment: Alignment = .center) -> some View {
    frame(
      maxHeight: .infinity,
      alignment: alignment)
  }
}

