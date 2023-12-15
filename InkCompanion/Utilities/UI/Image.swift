//
//  Image.swift
//  Ikachan
//
//  Created by Sketch on 2021/11/28.
//

import SwiftUI
import UIKit

extension Image {
  func resizedToFit(_ aspectRatio: CGFloat? = nil) -> some View {
    return self
      .resizable()
      .aspectRatio(aspectRatio, contentMode: .fit)
  }

  func resizedToFill(_ aspectRatio: CGFloat? = nil) -> some View {
    return self
      .resizable()
      .aspectRatio(aspectRatio, contentMode: .fill)
  }
}



extension Image {
  init?(_ name: String, replacingBlackWith color: Color) {
    let uiImage = UIImage(named: name)
    guard let coloredImage = uiImage?.replacingColor(with: UIColor(color)) else { return nil }
    self.init(uiImage: coloredImage)
  }
}



extension UIImage {
  func replacingColor(with newColor: UIColor) -> UIImage? {
    let width = Int(size.width)
    let height = Int(size.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
    context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))

    let pixelBuffer = context.data!.bindMemory(to: UInt32.self, capacity: width * height)
    let targetPixel = 4278190080
    let replacementPixel = newColor.toUInt32()

    var pixelCount = [UInt32: Int]()


    for y in 0..<height {
      for x in 0..<width {
        let pixel = pixelBuffer[y * width + x]

        pixelCount[pixel, default: 0] += 1

        if pixel == targetPixel {
          pixelBuffer[y * width + x] = replacementPixel
        }
      }
    }

        let sortedPixelCount = pixelCount.sorted { $0.value > $1.value }
                for (key, value) in sortedPixelCount {
                    print("\(key) : \(value)")
                }
    return context.makeImage().flatMap(UIImage.init)
  }

}

extension UIColor {
  func toUInt32() -> UInt32 {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 1.0 // 默认为完全不透明

    self.getRed(&blue, green: &green, blue: &red, alpha: &alpha)
    return UInt32(alpha * 255.0) << 24 | UInt32(red * 255.0) << 16 | UInt32(green * 255.0) << 8 | UInt32(blue * 255.0)
  }
}

