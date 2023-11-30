//
//  IdealFontLayout.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

/// `IdealFontLayout` is a custom layout designed to optimize the display of text within a parent view.
/// The layout computes the ideal dimensions for the text based on the provided anchor point and scales
/// the text accordingly to have a consistent look.
///
/// The parent view should provide a proposed width and height. The layout scales the text to fit
/// within these bounds while maintaining an ideal font size that allows all possible content to be in
/// and fit within the bounds.
///
/// - Important:
///   - This layout is anchor-agnostic and can align text based on a variety of anchor points.
///
/// - Precondition:
///   - The proposed width and height must already be set.
///   - The first subview is the actual text view that is going to be displayed. The rest of the subviews
///     are considered for computing the ideal size but will not be displayed.
///
struct IdealFontLayout: Layout {

  let anchor: UnitPoint

  // MARK: Internal

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache _: inout ())
    -> CGSize
  {
    let minIdealSize = getMinIdealSize(subviews: subviews, proposal: proposal)
    let maxIdealSize = getMaxIdealSize(subviews: subviews, proposal: proposal)

    return CGSize(
      width: maxIdealSize.width,
      height: minIdealSize.height)
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache _: inout ())
  {
    let minIdealSize = getMinIdealSize(subviews: subviews, proposal: proposal)
    let maxIdealSize = getMaxIdealSize(subviews: subviews, proposal: proposal)

    let contentWidth = maxIdealSize.width
    let contentHeight = minIdealSize.height

    var contentX: CGFloat {
      switch anchor {
      case .topLeading,
           .leading,
           .bottomLeading:
        bounds.minX
      case .top,
           .center,
           .bottom:
        bounds.midX
      case .topTrailing,
           .trailing,
           .bottomTrailing:
        bounds.maxX
      default:
        bounds.midX
      }
    }

    var contentY: CGFloat {
      switch anchor {
      case .topLeading,
           .top,
           .topTrailing:
        bounds.minY
      case .leading,
           .center,
           .trailing:
        bounds.midY
      case .bottomLeading,
           .bottom,
           .bottomTrailing:
        bounds.maxY
      default:
        bounds.minY
      }
    }

    let contentSizeProposal = ProposedViewSize(
      width: contentWidth,
      height: contentHeight)

    for index in subviews.indices {
      if index == 0 {
        // placing title text
        subviews[index].place(
          at: CGPoint(
            x: contentX,
            y: contentY),
          anchor: anchor,
          proposal: contentSizeProposal)
      }
      else {
        // skip all others
        subviews[index].place(
          at: CGPoint(
            x: bounds.midX,
            y: bounds.midY),
          anchor: .center,
          proposal: ProposedViewSize(width: 0, height: 0))
      }
    }
  }

  // MARK: Private

  private func getMinIdealSize(
    subviews: Subviews,
    proposal: ProposedViewSize)
    -> CGSize
  {
    let subviewSizes = subviews.map { $0.sizeThatFits(proposal) }
    let minIdealSize: CGSize = subviewSizes.reduce(
      CGSize(
        width: CGFloat.infinity,
        height: CGFloat.infinity))
    { currentMin, nextSize in
      CGSize(
        width: min(currentMin.width, nextSize.width),
        height: min(currentMin.height, nextSize.height))
    }
    return minIdealSize
  }

  private func getMaxIdealSize(
    subviews: Subviews,
    proposal: ProposedViewSize)
    -> CGSize
  {
    let subviewSizes = subviews.map { $0.sizeThatFits(proposal) }
    let maxIdealSize: CGSize = subviewSizes.reduce(.zero)
    { currentMax, nextSize in
      CGSize(
        width: max(currentMax.width, nextSize.width),
        height: max(currentMax.height, nextSize.height))
    }
    return maxIdealSize
  }

}
