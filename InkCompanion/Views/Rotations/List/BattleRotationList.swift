//
//  BattleRotaionList.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/16/23.
//

import SwiftUI

@MainActor
struct BattleRotationList: View {
  
  @EnvironmentObject private var rotationModel:RotationModel
  @EnvironmentObject private var timePublisher: TimePublisher

  let specifiedMode:BattleMode

  private var rotations: [BattleRotation] {
    (rotationModel.battleRotationDict[specifiedMode] ?? []).filter{!$0.isExpired(timePublisher.currentTime)}
  }

    var body: some View {
      GeometryReader { geo in

        ScrollView {
          ForEach(rotations){rotation in
                BattleRotationRow(rotation: rotation, rowWidth: geo.size.width)
              }

            .animation(
              .bouncy,
            value: rotations.map { $0.startTime })
        }

      }
    }
}

#Preview {
  BattleRotationList(specifiedMode: .anarchy(.CHALLENGE))
    .environmentObject(RotationModel())
}
