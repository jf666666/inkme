//
//  Nameplate.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/4/23.
//

import SwiftUI
import Kingfisher

struct NameplateView: View {
    let coopPlayer:CoopPlayer
  var nameplate: Nameplate {coopPlayer.nameplate}
  var playerName: String {coopPlayer.name}
  var byName: String {coopPlayer.byname}
  var nameId: String {coopPlayer.nameId}

    var body: some View {
        GeometryReader { geometry in
            let geometryHeight = geometry.size.height
            let geometryWidth = geometry.size.width
            let textColor:Color = Color(
                red: nameplate.background?.textColor?.r ?? 1,
                green: nameplate.background?.textColor?.g ?? 1,
                blue: nameplate.background?.textColor?.b ?? 1
            )
            ZStack(alignment: .topLeading) { // 设置对齐方式以定位左上角的称号
                // 使用 Kingfisher 加载背景图片
                if let backgroundImageURL = nameplate.background?.image?.url {
                    KFImage(URL(string: backgroundImageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill) // 保持图片的长宽比
                        .frame(width: geometryWidth, height: geometryHeight)
                        .clipped() // 这将确保图片不会超出边界
                        .cornerRadius(geometryHeight/8) // 设置圆角
                }
                
                // 称号位置在左上角
                Text(byName)
                    .inkFont(.font1, size: geometryHeight * 0.2, relativeTo: .body)
                    .foregroundColor(textColor)
                    .padding(.top, geometryWidth * 0.03)
                    .padding(.leading, geometryHeight * 0.08)
                
                // 玩家名居中
                Text(playerName)
                    .inkFont(.Splatoon2, size: geometryHeight * 0.45, relativeTo: .body)
                    .foregroundColor(textColor)
                    .position(x: geometryWidth / 2, y: geometryHeight / 2) // 根据容器尺寸居中
                
                if nameplate.badges?.count != 0{
                    // 徽章位置在右下角
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            // 循环显示所有徽章
                            ForEach(nameplate.badges ?? [], id: \.id) { badge in
                                if let badgeImageUrl = badge.image?.url {
                                    KFImage(URL(string: badgeImageUrl))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometryHeight * 0.33, height: geometryHeight * 0.33)
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
                            .inkFont(.Splatoon2, size: geometryHeight * 0.15, relativeTo: .body)
                            .foregroundColor(textColor)
                            .padding(.leading, geometryWidth * 0.03) // 根据需要设置内边距
                            .padding(.bottom, geometryHeight * 0)
                        Spacer() // 这将推动左边的内容到左边
                    }
                }
            }
        }
        .aspectRatio(3.537, contentMode: .fit)
        .frame(minWidth: 50) // 可以设置固定高度
    }
}





struct NameplateView_Previews: PreviewProvider {
    static var previews: some View {
//      MockData.getCoopHistoryDetail().myResult.player
        NameplateView(coopPlayer: MockData.getCoopHistoryDetail().myResult.player)
      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[0].player)
      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[1].player)
      NameplateView(coopPlayer: MockData.getCoopHistoryDetail().memberResults[2].player)

    }
}
