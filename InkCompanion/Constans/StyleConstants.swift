//
//  StyleConstants.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/11/23.
//

import Foundation
import SwiftUI

extension Constants.Style{
  enum Global {
    static let SHADOW_RADIUS: CGFloat = 4

    static let EXTERNAL_LINK_SFSYMBOL = "link"
    static let EXTERNAL_LINK_JUMP_SFSYMBOL = "arrow.up.forward.app.fill"
    static var EXTERNAL_LINK_JUMP_ICON: some View {
      Image(systemName: EXTERNAL_LINK_JUMP_SFSYMBOL)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color.secondary)
    }
  }

  enum Rotation {
    enum Header {
      static let SPACING: CGFloat = 16

      static let PREFIX_FRAME_CORNER_RADIUS: CGFloat = 8
      static let PREFIX_FONT_SIZE: CGFloat = 16
      static let PREFIX_PADDING_H: CGFloat = 8

      static let CONTENT_FONT_SIZE: CGFloat = 16

      enum Battle {
        static let CURRENT_PREFIX_STRING = "Now:"
        static let NEXT_PREFIX_STRING = "Next:"
      }

      enum Salmon {
        static let FIRST_PREFIX_STRINGS = (pending: "Soon:", active: "Open!")
        static let SECOND_PREFIX_STRING = "Next:"
      }
    }

    enum Label {
      static let TEXT_PADDING_H: CGFloat = 6
      static let TEXT_PADDING_V: CGFloat = 3
      static let BACKGROUND_CORNER_RADIUS: CGFloat = 4
    }

    enum Battle {
      enum Card{
        enum Primary{
          static let IMG_CORNER_RADIUS: CGFloat = 4
          static let LABEL_FONT_SIZE: CGFloat = 13
          static let LABEL_PADDING_LEADING: CGFloat = 20
          static let LABEL_PADDING_BOTTOMTRAILING: CGFloat = 2
        }

        enum Secondary {
          static let SPACING_V: CGFloat = 4
          static let IMG_CORNER_RADIUS: CGFloat = 4
          static let FONT_SIZE: CGFloat = 12
        }

      }
      
      enum Cell {
        enum Primary {
          static let CELL_SPACING_V: CGFloat = 8
          static let PROGRESS_BAR_PADDING_BOTTOM: CGFloat = 8
          static let CELL_PADDING_TOP: CGFloat = 0
          static let CELL_PADDING_BOTTOM: CGFloat = 6

          static let RULE_SECTION_SPACING: CGFloat = 8
          static let RULE_SECTION_PADDING_LEADING: CGFloat = 10

          static let RULE_TITLE_FONT_SIZE_MAX: CGFloat = 48
          static let RULE_TITLE_TEXT_STYLE_RELATIVE_TO: Font.TextStyle = .title
          static let RULE_TITLE_PADDING_V: CGFloat = 4

          static let RULE_SECTION_WIDTH_RATIO: CGFloat = 0.45
          static let RULE_SECTION_HEIGHT_RATIO: CGFloat = 0.115

          static let REMAINING_TIME_FONT_SIZE: CGFloat = 15
          static let REMAINING_TIME_TEXT_STYLE_RELATIVE_TO: Font.TextStyle = .headline
          static let REMAINING_TIME_SECTION_WIDTH_RATIO: CGFloat = 0.32
        }

        enum Secondary {
          static let RULE_SECTION_SPACING: CGFloat = 2

          static let RULE_IMG_HEIGHT_RATIO: CGFloat = 0.12
          static let RULE_IMG_PADDING: CGFloat = 5
          static let RULE_IMG_FRAME_CORNER_RADIUS: CGFloat = 12

          static let RULE_FONT_SIZE: CGFloat = 18
          static let RULE_TITLE_HEIGHT: CGFloat = 24

          static let RULE_SECTION_WIDTH_RATIO: CGFloat = 0.16
          static let RULE_SECTION_PADDING_TRAILING: CGFloat = 10
        }
      }

    }
  }
}
