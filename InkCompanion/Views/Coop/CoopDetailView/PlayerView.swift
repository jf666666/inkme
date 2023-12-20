//
//  PlayerView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import Foundation
import SwiftUI
import Kingfisher

extension CoopDetailView{

  struct playerResult:View {
    let result:CoopPlayerResult
    var showName:Bool = true
    var body: some View {
      HStack{
        VStack(alignment: .leading, spacing:5){
          Text(showName ? result.player.name : "------")
            .inkFont(.font1, size: 15, relativeTo: .body)
          Text("巨大鲑鱼 x\(result.defeatEnemyCount)")
            .inkFont(.font1, size: 10, relativeTo: .body)
            .foregroundStyle(.secondary)
        }

        Spacer()
        VStack(alignment: .trailing,spacing: 0){
          HStack {
            HStack{
              ForEach(0..<result.weapons.count,id: \.self){ index in
                KFImage(URL(string: result.weapons[index].image?.url ?? ""))
                  .resizable()
                  .scaledToFit()
                  .frame(width: 20,height: 20)
                  .clipShape(Capsule())
              }
            }
            .background(Color(.sRGB, white: 221 / 255.0, opacity: 0.1))
            .continuousCornerRadius(7)

            KFImage(URL(string: result.specialWeapon?.image?.url ?? ""))
              .resizable()
              .scaledToFit()
              .frame(width: 15,height: 15)
              .clipShape(Capsule())
          }
          .frame(height: 24)

          HStack{
            HStack(spacing:2){
              Image(.golden)
                .resizable()
                .scaledToFit()
                .frame(height: 12)
              Text("\(result.goldenDeliverCount)").font(.custom(InkFont.Splatoon1.rawValue, size: 12))+Text("+\(result.goldenAssistCount)").font(.custom(InkFont.Splatoon1.rawValue, size: 9))
            }

            Group {
              HStack(spacing:2){
                Image(.egg)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 12)
                Text("\(result.deliverCount)")
              }
              HStack(spacing:2){
                Image(result.player.species == .INKLING ? .helpSquid : .helpOcto)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 12)
                Text("\(result.rescueCount)")
              }
              HStack(spacing:2){
                Image(result.player.species == .INKLING ? .helpedSquid : .helpedOcto)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 12)
                Text("\(result.rescuedCount)")
              }
            }
            .inkFont(.Splatoon1, size: 12, relativeTo: .body)
          }
          .scaledLimitedLine()

        }
      }
      .frame(height: 45)
      .contextMenu{
        Button(action: {
          let image = imageFromView(CoopPlayerPreview(player: result.player, weapons: result.weapons, specialWeapon: result.specialWeapon), size: CGSize(width: 300, height: 300))
          UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }) {
          Text("保存至相册")
        }

        Button(action: {

        }) {
          Text("关闭")
        }

      } preview: {
        CoopPlayerPreview(player: result.player, weapons: result.weapons, specialWeapon: result.specialWeapon)
          .frame(width: 300,height: 300)
      }
    }
  }
}


func imageFromView<V: View>(_ view: V, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
    let controller = UIHostingController(rootView: view)
    controller.view.bounds = CGRect(origin: .zero, size: size)

    let rendererFormat = UIGraphicsImageRendererFormat()
    rendererFormat.scale = scale
    let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)

    return renderer.image { _ in
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
}



func scrollViewToImage(scrollView: UIScrollView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)
    let savedContentOffset = scrollView.contentOffset
    let savedFrame = scrollView.frame

    scrollView.contentOffset = .zero
    scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    scrollView.layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()

    scrollView.contentOffset = savedContentOffset
    scrollView.frame = savedFrame
    UIGraphicsEndImageContext()

    return image
}
