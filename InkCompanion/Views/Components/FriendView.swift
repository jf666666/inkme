//
//  FriendView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//
import SwiftUI
import CoreData
import Kingfisher

struct FriendView: View {
    let friend: FriendListResult.Data.Friends.Node
    @Binding var expandedFriendId: String?
    
    @State private var image: Image?
    @State private var isLoading = true
    @State private var error: Error?
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .fill(Color.gray.opacity(0.3)) // 默认背景色
                    .frame(width: 35, height: 35)
                    .overlay(

                      KFImage(URL(string: friend.userIcon?.url ?? ""))
                        .resizable()
                        .scaledToFit()
                    )
                    .clipShape(Circle())
                    .overlay(
                      Circle().stroke(borderColor(for: friend), lineWidth: 1.2)
                    )
                    .shadow(radius: 3)
                if friend.onlineState != "OFFLINE" && friend.onlineState != "ONLINE"{
                    getStateIcon(friend: friend)
                        .resizable() // 使图标可调整大小
                        .scaledToFit() // 保持图标的宽高比
                        .frame(width: 10, height: 10) // 设置图标的大小
                        .offset(x: 12, y: 12)
                }
            }
            if expandedFriendId == friend.id {
                Text(friend.nickname)
                .inkFont(.font1, size: 12, relativeTo: .body)

                .scaledLimitedLine()
                    .frame(width: 35) // 限制最大宽度

                    .padding(.horizontal, 4)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(5)
            }
            
        }
        .frame(width: 40, height: 50) // 限制FriendView的大小
        .contentShape(Rectangle()) // 确保整个区域都可以点击
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                expandedFriendId = (expandedFriendId == friend.id) ? nil : friend.id
            }
        }
    }

    private func borderColor(for friendEntity: FriendListResult.Data.Friends.Node) -> Color {
        return getFriendColor(friend: friendEntity)
    }

}


func getStateIcon(friend:FriendListResult.Data.Friends.Node)->Image{
    switch friend.onlineState {
    case FriendOnlineState.VS_MODE_FIGHTING.rawValue:
        return getVsModeIcon(mode: friend.vsMode?.id ?? "regular")
    case FriendOnlineState.COOP_MODE_FIGHTING.rawValue:
        return getCoopRuleIcon( rule: CoopRule(rawValue: friend.coopRule!) ?? CoopRule.REGULAR)
    case FriendOnlineState.MINI_GAME_PLAYING.rawValue:
        return Image(.coopRegular)
    case FriendOnlineState.VS_MODE_MATCHING.rawValue, FriendOnlineState.COOP_MODE_MATCHING.rawValue, FriendOnlineState.ONLINE.rawValue:
        return Image(.coopRegular)
    case FriendOnlineState.OFFLINE.rawValue:
        return Image(systemName: "poweroff")
    default:
        return Image(.coopRegular)
    }
    
}

// 定义一个新的视图来展示更多的朋友信息
struct ExpandedFriendInfoView: View {
    let friend: FriendListResult.Data.Friends.Node

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(friend.nickname)")
            Text("\(friend.onlineState)")
        }
        
//        .background(Color.white)
//        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        // 创建一个临时的托管对象上下文
        let context = PersistenceController.preview.container.viewContext
        
        // 创建一个临时的FriendEntity实例来用于预览
        let friendEntity = FriendListResult.Data.Friends.Node(id: "dadadadas", nickname: "Sample Friend", onlineState: "VS_MODE_FIGHTING",userIcon: FriendListResult.Data.Friends.Node.UserIcon(height: 256, url: "https://cdn-image-e0d67c509fb203858ebcb2fe3f88c2aa.baas.nintendo.com/1/133136c9481fa136", width: 256), isFavorite: true)
        
        // 使用该实例来创建预览
        // 创建一个临时的绑定变量，因为预览不需要实际的状态管理
                let expandedFriendId = Binding<String?>.constant("dadadadas") // 假设这个ID是展开的
        
        return FriendView(friend: friendEntity, expandedFriendId: expandedFriendId)
            .environment(\.managedObjectContext, context)
    }
}






