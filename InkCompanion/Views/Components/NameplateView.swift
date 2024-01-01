//
//  Nameplate.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/4/23.
//

import SwiftUI
import Kingfisher

struct NameplateView: View {
  let nameplate: Nameplate
  let playerName: String
  let byName: String
  let nameId: String
  var textColor:Color {nameplate.background?.textColor?.swiftColor ?? .black}

  init(coopPlayer:CoopPlayer){
    self.nameplate = coopPlayer.nameplate
    self.playerName = coopPlayer.name
    self.byName = coopPlayer.byname
    self.nameId = coopPlayer.nameId
  }

  init(currentPlayer:CurrentPlayer){
    self.nameplate = currentPlayer.nameplate
    self.playerName = currentPlayer.name
    self.byName = currentPlayer.byname
    self.nameId = currentPlayer.nameId
  }

    var body: some View {
        GeometryReader { geometry in
            let geometryHeight = geometry.size.height
            let geometryWidth = geometry.size.width

            ZStack(alignment: .topLeading) {
                if let backgroundImageURL = nameplate.background?.image?.url {
                    KFImage(URL(string: backgroundImageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometryWidth, height: geometryHeight)
                        .clipped()
                        .cornerRadius(geometryWidth*0.02)
                }
                
                // 称号位置在左上角
                Text(byName)
                    .inkFont(.font1, size: geometryWidth * 12/284, relativeTo: .body)
                    .foregroundColor(textColor)
                    .padding(.top, geometryWidth * 5/284)
                    .padding(.leading, geometryWidth * 10/284)

                // 玩家名居中
                Text(playerName)
                    .inkFont(.Splatoon2, size: geometryWidth * 26/284, relativeTo: .body)
                    .foregroundColor(textColor)
                    .position(x: geometryWidth / 2, y: geometryHeight / 2) // 根据容器尺寸居中
                
                if nameplate.badges?.count != 0{
                    // 徽章位置在右下角
                    VStack {
                        Spacer()
                      HStack(spacing:geometryWidth*2/284) {
                            Spacer()
                            // 循环显示所有徽章
                            ForEach(nameplate.badges ?? [], id: \.id) { badge in
                                if let badgeImageUrl = badge.image?.url {
                                    KFImage(URL(string: badgeImageUrl))
                                        .resizable()
                                        .scaledToFit()
                                        .padding([.trailing,.bottom],1/284)
                                        .frame(width: geometryHeight * 0.345, height: geometryHeight * 0.345)

                                }
                            }
                        }
                    }

                }
                
                // nameId位置在左下角
                VStack {
                    Spacer() // 这将推动下面的内容到底部
                    HStack {
                        Text("#\(nameId)")
                            .inkFont(.font1, size: geometryWidth*10/284, relativeTo: .body)
                            .foregroundColor(textColor)
                            .padding(.leading, geometryWidth * 10/284)
                            .padding(.bottom, geometryWidth * 5/284)

                        Spacer() // 这将推动左边的内容到左边
                    }

                }

            }
        }
        .aspectRatio(3.5, contentMode: .fit)
        .frame(minWidth: 50) // 可以设置固定高度
    }
}





//struct NameplateView_Previews: PreviewProvider {
//    static var previews: some View {
////      MockData.getCoopHistoryDetail().myResult.player
//        NameplateView(coopPlayer: MockData.getCoopHistoryDetail().myResult.player)
//      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[0].player)
//      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[1].player)
//      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[2].player)
//
//    }
//}
