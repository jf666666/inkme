//
//  FriendsView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//

import SwiftUI
import CoreData

struct FriendsView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: FriendEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FriendEntity.nickname, ascending: true)]
    ) var friends: FetchedResults<FriendEntity>
    
    @State private var liveFriendsData: [FriendListResult.Data.Friends.Node] = []
    @State private var expandedFriendId: String? // 这里存储当前展开的FriendView的id

    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(liveFriendsData, id: \.id) { liveFriend in
                        FriendView(friend: liveFriend, expandedFriendId: $expandedFriendId)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                    }
                }
                .padding()
                .onAppear {
                    fetchFriendsList()
                }
            }
            .animation(.easeInOut, value: liveFriendsData) // 这里添加动画效果
        }
    

    
    func fetchFriendsList() {
        if let webServiceToken: WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),
           let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken) {
            FetchGraphQl(
                webServiceToken: webServiceToken,
                bulletToken: bulletToken,
                language: httpAcceptLanguageFormat(),
                hash: .FriendListQuery, variables: nil
            ) { (result: Result<FriendListResult, Error>) in
                switch result {
                case .success(let FriendListResult):
                    self.liveFriendsData = FriendListResult.data.friends?.nodes ?? []
                    updateFriendsInDatabase(with: FriendListResult.data.friends?.nodes ?? [], in: managedObjectContext)
                    print("Friends updated")
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Failed to retrieve web service token or bullet token")
        }
    }
}


struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
