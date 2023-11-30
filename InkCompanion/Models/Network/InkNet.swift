//
//  InkNetService.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/15/23.
//

import Foundation
import Combine


final class InkNet:ObservableObject {

  static let shared = InkNet()

  private init() {}

  func fetchCoopHistories() async -> CoopResult?{
    do {
      let data = try await fetchGraphQL(hash: .CoopHistoryQuery) as CoopHistories
      return data.data.coopResult
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }

  func fetchCoopHistoryDetail(id:String,diff:CoopGradePointDiff) async -> CoopHistoryDetail?{
    do {
      let data =  try await fetchGraphQL(hash: .CoopHistoryDetailQuery,variables: ["coopHistoryDetailId": id]) as CoopHistoryDetailQuery
      var detail = data.data.coopHistoryDetail
      detail.gradePointDiff = diff
      return detail
    }catch let error as NSError{
      print("failed \(error): \(error.userInfo)")
      return nil
    }
  }

  func fetchSchedule() async->StageSchedules?{
    do{
      return try await fetchGraphQL(hash: .StageScheduleQuery) as StageSchedules
    }catch{
      return nil
    }
  }
  
  func fetchFriend() async -> FriendListResult?{
    do {
      return try await fetchGraphQL(hash: .FriendListQuery) as FriendListResult
    }catch{
      return nil
    }
  }

}

