//
//  FriendsView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//

import SwiftUI
import CoreData

struct FriendsView: View {
  @State private var liveFriendsData: [FriendListResult.Data.Friends.Node] = []
  @State private var expandedFriendId: String? // 这里存储当前展开的FriendView的id
  var inkNet = InkNet.shared
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 3) {
        ForEach(liveFriendsData, id: \.id) { liveFriend in
          FriendView(friend: liveFriend, expandedFriendId: $expandedFriendId)
            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
        }
      }
      .frame(height: 50)
      .task {
        let friend = await inkNet.fetchFriend()
        DispatchQueue.main.async {
          self.liveFriendsData = friend?.data.friends?.nodes ?? []
        }
      }
    }
    .animation(.easeInOut, value: liveFriendsData) // 这里添加动画效果
  }
}
struct FriendsView_Previews: PreviewProvider {
  static var previews: some View {
    FriendsView()
  }
}
