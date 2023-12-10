//
//  TextureBackGround.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/26/23.
//

import Foundation
import SwiftUI

extension View {
  func textureBackground(texture:GrayscaleTextureView.Texture, radius: CGFloat,foregroundColor:Color = Color.battleDetailStreakForeground, backgroundColor:Color = Color.listItemBackground) -> some View {
    self.modifier(TextureBackgroundModifier(texture: texture, radius: radius, foregroundColor: foregroundColor, backgroundColor: backgroundColor))
  }
}



struct TextureBackgroundModifier: ViewModifier {
  let texture:GrayscaleTextureView.Texture
  let radius: CGFloat
  let foregroundColor: Color
  let backgroundColor: Color
  func body(content: Content) -> some View {
    ZStack {
      GrayscaleTextureView(
        texture: texture,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor
      )
      .continuousCornerRadius(radius)
      content

    }
  }
}

struct TextureBackground_Preview:PreviewProvider{
  static var previews: some View{
    VStack{

    }
    .textureBackground(texture: .bubble, radius: 18,foregroundColor: Color(#colorLiteral(red: 0.3552145958, green: 0.1489881575, blue: 0.05287599564, alpha: 1)),backgroundColor: Color(#colorLiteral(red: 0.3885090649, green: 0.1678851247, blue: 0.05057295412, alpha: 1)))
      .frame(width: 300,height: 200)
  }
}
