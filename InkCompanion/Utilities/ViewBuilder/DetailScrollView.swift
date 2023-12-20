//
//  DetailView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/29/23.
//

import Foundation

import SwiftUI

struct DetailScrollView<Content: View>: View {
  let horizontalPadding: CGFloat?
  @ViewBuilder let content: () -> Content

  init(horizontalPadding: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
    self.horizontalPadding = horizontalPadding
    self.content = content
  }

  var body: some View {
    ScrollView {

      HStack {
        Spacer()
        content()
        Spacer()
      }
      .padding(.horizontal, horizontalPadding)
    }
    .frame(maxWidth: .infinity)
    //         .fixSafeareaBackground() // 添加您的自定义方法或视图修饰符
  }
}
