//
//  EnemyView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/6/23.
//

import SwiftUI
import Kingfisher

extension CoopDetailView{
  
  struct enemyResult:View {
    let result:CoopEnemyResult
    var body: some View {
      HStack{
        KFImage(URL(string: result.enemy.image?.url ?? ""))
          .resizable()
          .scaledToFit()
        Text("\(result.enemy.name)")
          .inkFont(.font1, size: 15, relativeTo: .body)
        Spacer()
        Group{
          Text("\(result.teamDefeatCount)").font(.custom(InkFont.Splatoon1.rawValue, size: 15)) + Text(result.defeatCount == 0 ? "" : "(\(result.defeatCount))").font(.custom(InkFont.Splatoon1.rawValue, size: 12))
          Text("/")
            .inkFont(.Splatoon1, size: 16, relativeTo: .body)
          Text("出现数量x").font(.custom(InkFont.font1.rawValue, size: 12)) + Text("\(result.popCount)").font(.custom(InkFont.Splatoon1.rawValue, size: 15))
        }
        .foregroundStyle(result.popCount == result.teamDefeatCount ? Color.waveClear : Color.coopEnemyNotAllClear)
      }
    }
  }
}
