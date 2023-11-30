//
//  TextureBackGround.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/26/23.
//

import Foundation
import SwiftUI

extension View {
  func textureBackground(texture:GrayscaleTextureView.Texture, radius: CGFloat) -> some View {
    self.modifier(TextureBackgroundModifier(texture: texture, radius: radius))
  }
}



struct TextureBackgroundModifier: ViewModifier {
  let texture:GrayscaleTextureView.Texture
  let radius: CGFloat
  func body(content: Content) -> some View {
    ZStack {
      GrayscaleTextureView(
        texture: texture,
        foregroundColor: AppColor.battleDetailStreakForegroundColor,
        backgroundColor: AppColor.listItemBackgroundColor
      )
      .continuousCornerRadius(radius)
      content

    }
  }
}
