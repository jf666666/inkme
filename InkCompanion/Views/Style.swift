//
//  Style.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/2/23.
//

import SwiftUI




enum SplatColor: String {
    // UI.
    case AccentColor = "#6b84f5"
    case LightBackground = "#fafafa"
    case DarkBackground = "#18181b"
    case LightText = "black"
    case DarkText = "white"
    case LightTerritory = "#f4f4f5"
    case MiddleTerritory = "#a1a1aa"
    case DarkTerritory = "#3f3f46"
//    case KillAndRescue = "#22c55e"
    case Death = "#ef4444"
    case Special = "#eab308"
    case UltraSignal = "#06b6d4"
    // Splatoon (UI-adjusted).
    case RegularBattle = "#22c55e"
    case AnarchyBattle = "#ea580c"
    case XBattle = "#34d399"
    case Challenge = "#db2777"
    case PrivateBattle = "#c026d3"
    case SalmonRun = "#f97316"
    case BigRun = "#9333ea"
    case EggstraWork = "#facc15"
    case TableturfBattle = "#6d28d9"
    case Online = "#22d3ee"
    // Splatoon.
    case PowerEgg = "#ff6200"
    case GoldenEgg = "#ffce00"
    case GoldScale = "#e4b23e"
    case SilverScale = "#9c9c9c"
    case BronzeScale = "#c6702f"
}

func getVsModeColor(mode: String) -> SplatColor {
    switch mode {
    case "VnNNb2RlLTE=":
        return .RegularBattle
    case "VnNNb2RlLTI=", "VnNNb2RlLTUx":
        return .AnarchyBattle
    case "VnNNb2RlLTM=":
        return .XBattle
    case "VnNNb2RlLTQ=":
        return .Challenge
    case "VnNNb2RlLTU=":
        return .PrivateBattle
    case "VnNNb2RlLTY=", "VnNNb2RlLTc=", "VnNNb2RlLTg=":
        return .AccentColor
    default:
        return .RegularBattle // or any default color
    }
}

func getVsModeIcon(mode: String) -> Image {
    switch mode {
    case "VnNNb2RlLTE=":
        return Image(.regularBattle)
    case "VnNNb2RlLTI=", "VnNNb2RlLTUx":
        return Image(.anarchy)
    case "VnNNb2RlLTM=":
        return Image(.xBattle)
    case "VnNNb2RlLTQ=":
        return Image(.anarchy)
    case "VnNNb2RlLTU=":
        return Image(.private)
    case "VnNNb2RlLTY=", "VnNNb2RlLTc=", "VnNNb2RlLTg=":
        return Image(.regular)
    default:
        return Image(.regular) // or any default color
    }
}


enum FriendOnlineState: String {
    case OFFLINE = "OFFLINE"
    /**
     * The user is online and selected in *any* game, not just Splatoon 3.
     * Coral may be used to check which game the user is playing.
     */
    case ONLINE = "ONLINE"
    case VS_MODE_MATCHING = "VS_MODE_MATCHING"
    case COOP_MODE_MATCHING = "COOP_MODE_MATCHING"
    case MINI_GAME_PLAYING = "MINI_GAME_PLAYING"
    case VS_MODE_FIGHTING = "VS_MODE_FIGHTING"
    case COOP_MODE_FIGHTING = "COOP_MODE_FIGHTING"
}

func getFriendColor(friend: FriendListResult.Data.Friends.Node) -> Color {
    switch friend.onlineState {
    case FriendOnlineState.VS_MODE_FIGHTING.rawValue:
        return Color(.playing)
    case FriendOnlineState.COOP_MODE_FIGHTING.rawValue:
        return Color(.playing)
    case FriendOnlineState.MINI_GAME_PLAYING.rawValue:
        return Color(.playing)
    case FriendOnlineState.VS_MODE_MATCHING.rawValue, FriendOnlineState.COOP_MODE_MATCHING.rawValue, FriendOnlineState.ONLINE.rawValue:
        return Color(.online)
    case FriendOnlineState.OFFLINE.rawValue:
        return Color(.offline)
    default:
        return Color(.offline)
    }
}




func getCoopRuleColor(rule: CoopRule) -> SplatColor {
    switch rule {
    case .REGULAR, .ALL:
        return .SalmonRun
    case .BIG_RUN:
        return .BigRun
    case .TEAM_CONTEST:
        return .EggstraWork
    }
}

func getCoopRuleIcon(rule: CoopRule) -> Image {
    switch rule {
    case .REGULAR, .ALL:
        return Image(.coopRegular)
    case .BIG_RUN:
        return Image(.coopBigrun)
    case .TEAM_CONTEST:
        return Image(.coopTeamContest)
    }
}
