//
//  DetailVotingStatusQuery.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation

enum FestState: String,Codable {
    case scheduled = "SCHEDULED"
    case firstHalf = "FIRST_HALF"
    case secondHalf = "SECOND_HALF"
    case closed = "CLOSED"
}

enum FestVoteState: String,Codable {
    case voted = "VOTED"
    case preVoted = "PRE_VOTED"
}

enum FestTeamRole: String,Codable {
    case attack = "ATTACK"
    case defense = "DEFENSE"
}

struct Fest: Codable {
    let __typename: String?
    let id: String?
    let title: String?
    let lang: String?
    let startTime: String?
    let endTime: String?
    let midtermTime: String?
    let state: FestState?
    let image: Icon?
    let teams: [FestTeam]?
    let playerResult: FestPlayerResult?
    let myTeam: FestTeam?
    let isVotable: Bool?
    let undecidedVotes: FestVoteConnection?
    let tricolorStage: VsStage?
}



struct VsStageRecordStats: Codable {
    let lastPlayedTime: String?
    let winRateTw: Double?
    let winRateAr: Double?
    let winRateCl: Double?
    let winRateGl: Double?
    let winRateLf: Double?
}

struct FestVote:Codable{
    let playName:String?
    let userIcon:Icon?
}
typealias FestVoteConnection = Connection<FestVote>


struct FestTeam: Codable {
    let id: String?
    let teamName: String?
    let color: SN3Color?
    let image: Icon?
    let myVoteState: FestVoteState?
    let preVotes: FestVoteConnection?
    let votes: FestVoteConnection?
    let role: FestTeamRole?
    let result: FestTeamResult?
}

struct FestTeamResult: Codable {
    let __typename: String?
    let isWinner: Bool?
    let horagaiRatio: Double?
    let isHoragaiRatioTop: Bool?
    let voteRatio: Double?
    let isVoteRatioTop: Bool?
    let regularContributionRatio: Double?
    let isRegularContributionRatioTop: Bool?
    let challengeContributionRatio: Double?
    let isChallengeContributionRatioTop: Bool?
    let tricolorContributionRatio: Double?
    let isTricolorContributionRatioTop: Bool?
    let rankingHolders: FestRankingHolderConnection?
}

struct FestRankingHolder: Codable {
    let __typename: String?
    let __isPlayer: String?
    let id: String?
    let name: String?
    let nameId: String?
    let byname: String?
    let rank: Double?
    let festPower: Double?
    let weapon: Weapon?
    let nameplate: Nameplate?
}

typealias FestRankingHolderConnection = Connection<FestRankingHolder>

struct FestPlayerResult: Codable {
    let grade: String?
    let horagai: Double?
    let regularContributionAverage: Double?
    let regularContributionTotal: Double?
    let challengeContributionAverage: Double?
    let challengeContributionTotal: Double?
    let tricolorContributionEnabled: Bool?
    let tricolorContributionAverage: Double?
    let tricolorContributionTotal: Double?
    let maxFestPower: Double?
}


struct FestNode: Codable {
    let __typename: String?
    let id: String?
    let lang: String?
    let teams: [FestTeam]?
    let undecidedVotes: FestVoteConnection?
}

struct DetailVotingStatusQuery: Codable {

        let fest: FestNode

}
