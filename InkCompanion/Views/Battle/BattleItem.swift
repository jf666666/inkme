//
//  BattleItem.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/4/23.
//

import SwiftUI

struct BattleItem: View {
  let detail:VsHistoryDetail
    var body: some View {
      Text(detail.id.base64Decoded())
    }
}

#Preview {
  BattleItem(detail: MockData.getVsHistoryDetail())
}
