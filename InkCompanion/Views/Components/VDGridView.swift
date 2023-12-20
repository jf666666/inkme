//
//  VDGridView.swift
//  imink
//
//  Created by Jone Wang on 2020/10/8.
//

import SwiftUI

struct VDGridView: View {
    
    enum VDResult: Int, CaseIterable {
        case victory
        case defeat
        case none
    }
    
    var data: [Judgement]
    @Binding var height: CGFloat
    @Binding var lastBlockWidth: CGFloat
  var isCoop:Bool = true

    private var dataSource: [VDResult] {
      let data = Array(self.data)

        let indexs = (0..<Int(count))
        return indexs.map { i in
            var itemStatus = VDResult.none
          if i < data.count && data[i] != .DRAW{
              itemStatus = data[i] == .WIN ? .victory : .defeat
          }
            return itemStatus
        }
    }
    
    private var columns: [GridItem] {
        (0..<10).map { _ in GridItem(.adaptive(minimum: 6), spacing: 1) }
    }
    
    private let count: Int = 500
    
    private let rowCount: Int = 10
    
    private let blockCount: Int = 10
    private let blockMargin: CGFloat = 2
    
    private var columnCount: Int {
        count / rowCount
    }
    
    var body: some View {
        GeometryReader { geo in
            makeGrid(geo: geo)
        }
    }
    
    private func makeGrid(geo: GeometryProxy) -> some View {
        let width = geo.size.width
        let itemSize = (width - CGFloat(columnCount - 1) - CGFloat(blockCount - 1) * blockMargin) / CGFloat(columnCount)
        self.height = itemSize * CGFloat(rowCount) + CGFloat((rowCount - 1))
        
        let numberOfRectanglesInEachBlock = CGFloat(count / rowCount / blockCount)
        self.lastBlockWidth = itemSize * numberOfRectanglesInEachBlock + (numberOfRectanglesInEachBlock - 1)
        
        return ZStack {
            drawRects(geo: geo, drawResult: .none, itemSize: itemSize)
            .foregroundColor(self.isCoop ? VDResult.none.coopColor : VDResult.none.battleColor)
            drawRects(geo: geo, drawResult: .defeat, itemSize: itemSize)
                .foregroundColor(self.isCoop ? VDResult.defeat.coopColor : VDResult.defeat.battleColor)
            drawRects(geo: geo, drawResult: .victory, itemSize: itemSize)
                .foregroundColor(self.isCoop ? VDResult.victory.coopColor : VDResult.victory.battleColor)
        }
    }
    
    private func drawRects(geo: GeometryProxy, drawResult: VDResult, itemSize: CGFloat) -> Path {
        Path { path in
            var itemIndex = 0
            for column in 0..<columnCount {
                for row in 0..<rowCount {
                    let result = dataSource[itemIndex]
                    
                    if result == drawResult {
                        let startX = itemSize * CGFloat(column) + CGFloat(column) + CGFloat(column / 5) * blockMargin
                        let startY = itemSize * CGFloat(row) + CGFloat(row)
                        
                        let rect = CGRect(x: startX, y: startY, width: itemSize, height: itemSize)
                        path.addRect(rect)
                    }
                    
                    itemIndex += 1
                }
            }
        }
    }
}

extension VDGridView.VDResult {
    
    var coopColor: Color {
        switch self {
        case .victory:
            return AppColor.waveClearColor.opacity(0.8)
        case .defeat:
            return AppColor.waveDefeatColor.opacity(0.8)
        case .none:
            return Color.primary.opacity(0.15)
        }
    }

  var battleColor:Color{
    switch self {
    case .victory:
        return AppColor.spPink.opacity(0.8)
    case .defeat:
        return AppColor.spLightGreen.opacity(0.8)
    case .none:
        return Color.primary.opacity(0.15)
    }
  }

}
