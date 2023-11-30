//
//  RotationSection.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/30/23.
//

import SwiftUI

struct CustomSection<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content

    init(@ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            header()
                .foregroundColor(.secondary)
                .padding(.bottom, 5)

            content()
        }
        .padding()
    }
}

#Preview {
  NavigationStack {
      CustomSection(header: {
          Text("这里是 Header")
              .font(.headline)
      }, content: {
          Text("这里是内容...")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .textureBackground(texture: .bubble, radius: 18)
      })
      .navigationTitle("自定义 Section")
  }
}

