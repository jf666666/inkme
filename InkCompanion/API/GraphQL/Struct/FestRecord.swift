//
//  FestRecord.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/3/23.
//

import Foundation

struct FestRecordQuery: Codable {
    let currentPlayer: CurrentPlayer?
    let festRecords: FestConnection?
}

typealias FestConnection = Connection<Fest>



struct FestRecordResult_splatoon3ink:Codable {

    struct FestRecord:Codable{
        let nodes:[FestDetail]?
    }
    let currentPlayer: CurrentPlayer?
    let festRecords:FestRecord?
    
}


struct Fest_splatoon3ink: Codable {
    let __splatoon3ink_id: String?
    let fest:FestDetail?
}



struct DetailFestRecordDetailQuery: Codable {
    let currentPlayer: CurrentPlayer?
    let fest: FestDetail?
}



struct FestDetail: Codable {
    let __typename: String?
    let id: String?
    let endTime: String?
    let image: Icon?
    let isVotable: Bool?
    let lang: String?
    let myTeam: FestTeamDetail?
    let playerResult: FestPlayerResultDetail?
    let startTime: String?
    let state: String?
    let teams: [FestTeamDetail]?
    let title: String?
    let undecidedVotes: FestVoteConnection?
}

struct FestTeamDetail: Codable {
    let id: String?
    let color: Colour?
    let image: Icon?
    let myVoteState: String?
    let preVotes: FestVoteConnection?
    let result: FestTeamResultDetail?
    let role: String?
    let teamName: String?
    let votes: FestVoteConnection?
}

struct FestPlayerResultDetail: Codable {
    let challengeContributionAverage: Double?
    let challengeContributionTotal: Double?
    let grade: String?
    let horagai: String?
    let maxFestPower: Double?
    let regularContributionAverage: Double?
    let regularContributionTotal: Double?
    let tricolorContributionAverage: Double?
    let tricolorContributionEnabled: Bool?
    let tricolorContributionTotal: Double?
}

struct FestTeamResultDetail: Codable {
    let __typename: String?
    let challengeContributionRatio: Double?
    let horagaiRatio: Double?
    let isChallengeContributionRatioTop: Bool?
    let isHoragaiRatioTop: Bool?
    let isRegularContributionRatioTop: Bool?
    let isTricolorContributionRatioTop: Bool?
    let isVoteRatioTop: Bool?
    let isWinner: Bool?
    let regularContributionRatio: Double?
    let tricolorContributionRatio: Double?
    let voteRatio: Double?
}


struct Festivals: Codable {
    struct FestData: Codable {
        let data: FestRecordResult_splatoon3ink
    }
    let US: FestData
    let EU: FestData
    let JP: FestData
    let AP: FestData
}




