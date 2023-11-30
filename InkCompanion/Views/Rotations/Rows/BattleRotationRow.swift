//
//  BattleRotationRow.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/16/23.
//

import SwiftUI

struct BattleRotationRow: View {
  @EnvironmentObject private var inkTimePublisher: TimePublisher

  let rotation:BattleRotation
  let rowWidth: CGFloat

  private var rowType: RowType {
    if rotation.isCurrent(inkTimePublisher.currentTime) { return .now }
    else if rotation.isNext(inkTimePublisher.currentTime) { return .next }
    else { return .other }
  }

    var body: some View {
//      Section {
//        BattleRotationCell(
//          type: rowType == .now ? .primary : .secondary,
//          rotation: rotation,
//          rowWidth: rowWidth)
//        .padding(.horizontal,8)
//        .textureBackground(texture: .bubble, radius: 18)
//      } header: {
//        BattleRotationHeader(
//          rotation: rotation,
//          rowType: rowType)
//      }
      CustomSection{
        BattleRotationHeader(
          rotation: rotation,
          rowType: rowType)

      } content: {
        BattleRotationCell(
          type: rowType == .now ? .primary : .secondary,
          rotation: rotation,
          rowWidth: rowWidth)
        .padding(.horizontal, 8)
        .textureBackground(texture: .bubble, radius: 18)
//        .frame(height: 200)
      }

    }
}

extension BattleRotationRow {
  enum RowType {
    typealias Scoped = Constants.Style.Rotation.Header.Battle

    case now
    case next
    case other

    var prefixString: String? {
      switch self {
      case .now:
        Scoped.CURRENT_PREFIX_STRING
      case .next:
        Scoped.NEXT_PREFIX_STRING
      case .other:
        nil
      }
    }
  }
}

struct BattleRotationHeader: View {
  typealias Scoped = Constants.Style.Rotation.Header

  @EnvironmentObject private var timePublisher: TimePublisher

  let rotation: BattleRotation
  let rowType: BattleRotationRow.RowType

  private var startTimeString: String {
    let shouldIncludeDate = Calendar.current.isDateInYesterday(rotation.startTime) ||
      Calendar.current.isDateInTomorrow(rotation.startTime)

    return rotation.startTime.toBattleTimeString(includeDateIf: shouldIncludeDate)
  }

  private var endTimeString: String {
    let shouldIncludeDate = (
      Calendar.current.isDateInYesterday(rotation.startTime) &&
        Calendar.current.isDateInToday(rotation.endTime)) ||
      (
        Calendar.current.isDateInToday(rotation.startTime) &&
          Calendar.current.isDateInTomorrow(rotation.endTime))

    return rotation.endTime.toBattleTimeString(includeDateIf: shouldIncludeDate)
  }

  var body: some View {
    HStack(spacing: Scoped.SPACING) {
      // skip if `prefixString` is nil (case .other)
      if let prefixString = rowType.prefixString {
        Text(prefixString)
          .inkFont(
            .Splatoon2,
            size: Scoped.PREFIX_FONT_SIZE,
            relativeTo: .title2)
          .foregroundStyle(Color.systemBackground)
          .padding(.horizontal, Scoped.PREFIX_PADDING_H)
          .background(Color.secondary)
          .cornerRadius(Scoped.PREFIX_FRAME_CORNER_RADIUS)
      }

      // Battle Time String
      Text("\(startTimeString) - \(endTimeString)")
        .scaledLimitedLine()
        .inkFont(
          .Splatoon2,
          size: Scoped.CONTENT_FONT_SIZE,
          relativeTo: .headline)
    }

  }
}


struct BattleRotationRow_Previews: PreviewProvider {
    static var previews: some View {
      let TimePublisher: TimePublisher = .shared
      let rotation = MockData.getBattleRotation(preferredMode: .event,preferredRule: .turfWar)
      GeometryReader { geo in
        ScrollView{
          BattleRotationRow(rotation: rotation, rowWidth: geo.size.width)
            .environmentObject(TimePublisher)
        }

      }
    }
}
