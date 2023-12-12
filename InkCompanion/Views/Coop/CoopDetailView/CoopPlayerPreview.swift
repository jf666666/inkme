//
//  CoopPlayerPreview.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import SwiftUI
import Kingfisher

struct CoopPlayerPreview: View {
  let player:CoopPlayer
  let weapons:[CoopSupplyWeapon]
  let specialWeapon:SpecialWeapon?
    var body: some View {
      GeometryReader{ geo in
        VStack(spacing: geo.size.height*0.03){
            NameplateView(coopPlayer: player)
            KFImage(URL(string: player.uniform.image.url ?? ""))
              .resizable()
              .scaledToFit()
//              .frame(width: geo.size.width*0.5,height: geo.size.width*0.4)
            Text(player.uniform.name)
              .inkFont(.font1, size: geo.size.width*0.04, relativeTo: .body)
            HStack{
              HStack{
                ForEach(0..<weapons.count,id:\.self){ index in
                  KFImage(URL(string: weapons[index].image?.url ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width*0.1,height: geo.size.width*0.1)
                    .clipShape(Capsule())
                }
              }
              .background(Color(.sRGB, white: 221 / 255.0, opacity: 0.1))
              .continuousCornerRadius(7)


              if let sw = specialWeapon{
                KFImage(URL(string: sw.image?.url ?? ""))
                  .resizable()
                  .scaledToFit()
                  .frame(width: geo.size.width*0.09,height: geo.size.width*0.09)
                  .background(Color(.sRGB, white: 221 / 255.0, opacity: 0.1))
                  .clipShape(Capsule())
              }


            }

          }
          .padding(.all)
          .textureBackground(texture: .bubble, radius: 18)
      }
    }
}

struct CoopPlayerPreview_Preview:PreviewProvider{
  static var previews: some View {
    let detail = MockData.getCoopHistoryDetail()
    CoopPlayerPreview(player: detail.myResult.player, weapons: detail.myResult.weapons, specialWeapon: detail.myResult.specialWeapon!)
      .frame(width: 300,height: 300)
  }
}
