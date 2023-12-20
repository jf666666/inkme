//
//  LoginView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/5/23.
//

import SwiftUI

struct LoginView: View {
  let nintendo = InkNet.NintendoService()
  var iconName: String? = nil
  var backgroundColor: Color? = nil

    var body: some View {
      VStack{
        Text("立即登陆同步数据")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(AppColor.appLabelColor)
          .padding(.top, 4)
          .padding(.bottom, 7)

        Button {
          Task{
            await nintendo.initiateLoginProcess()
          }
        } label: {
          HStack {
              Text("任天堂账号登陆")
                  .font(.system(size: 13, weight: .semibold))
                  .foregroundColor(.white)
                  .padding(.horizontal, 18)
          }
          .frame(height: 44)
          .frame(minWidth: 223)
          .background(Color.accentColor)
          .continuousCornerRadius(8)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(backgroundColor != nil ? backgroundColor : AppColor.listBackgroundColor.opacity(0.8))
    }
  
}

#Preview {
    LoginView()
}


struct LoginViewModifier: ViewModifier {

    var isLogined: Bool
    var iconName: String? = nil
    var backgroundColor: Color? = nil

    func body(content: Content) -> some View {
        ZStack {
            content
                .grayscale(isLogined ? 0 : 0.9999)

            if !isLogined {
                LoginView(
                    iconName: iconName,
                    backgroundColor: backgroundColor
                )
            }
        }
    }
}
