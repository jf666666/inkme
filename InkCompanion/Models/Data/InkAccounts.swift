//
//  Users.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/6/23.
//

import Foundation
import CoreData
import OSLog

struct InkAccount:Codable,Identifiable, Equatable{
  static func == (lhs: InkAccount, rhs: InkAccount) -> Bool {
    lhs.id == rhs.id
  }
  
  var id:Int64
  var avatarUrl:String
  var name:String
  var lastRefreshTime:Date
  var friendCode:String

  var sessionToken:String
  var bulletToken:String
  var webServiceToken:WebServiceTokenStruct
}

struct InkAccounts:Codable{
  var inkAccounts:[InkAccount]
}


extension InkData{

  func addAccount(account:InkAccount) async {

    let entity = AccountEntity(context: context)
    entity.name = account.name
    entity.id = account.id
    entity.avatar = account.avatarUrl
    entity.friendCode = account.friendCode
    entity.sessionToken = account.sessionToken
    entity.lastRefreshTime = account.lastRefreshTime
    entity.bulletToken = account.bulletToken
    entity.webServiceToken = account.webServiceToken.encode()

    await save()
  }

  func updateAccount(account:InkAccount) async {
    let fetchRequest:NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %ld", account.id)
    fetchRequest.fetchLimit = 1

    do {
      let result = try await context.perform {
        try self.context.fetch(fetchRequest)
      }
      if !result.isEmpty{
        result[0].avatar = account.avatarUrl
        result[0].lastRefreshTime = Date.now
        result[0].sessionToken = account.sessionToken
        result[0].webServiceToken = account.webServiceToken.encode()
        result[0].bulletToken = account.bulletToken
        result[0].name = account.name

        await save()
      }
    } catch let error as NSError {
      os_log("更新账户信息失败: \(error.localizedDescription)")
    }
  }
  
  func deleteAccount(accountId: Int64) async {
      let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %ld", accountId)
      fetchRequest.fetchLimit = 1

      do {
          let result = try await context.perform {
              try self.context.fetch(fetchRequest)
          }
          if !result.isEmpty {
              self.context.delete(result[0])
              await save()
          }
      } catch let error as NSError {
          os_log("删除账户信息失败: \(error.localizedDescription)")
      }
  }

  func getAccount(accountId: Int64) async -> InkAccount? {
      let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %ld", accountId)
      fetchRequest.fetchLimit = 1

      do {
          let result = try await context.perform {
              try self.context.fetch(fetchRequest)
          }
          if let entity = result.first {
              guard let sessionToken = entity.sessionToken,
                    let avatar = entity.avatar,
                    let name = entity.name,
                    let lastRefreshTime = entity.lastRefreshTime,
                    let friendCode = entity.friendCode,
                    let webServiceToken = entity.webServiceToken?.decode(WebServiceTokenStruct.self),
                    let bulletToken = entity.bulletToken else {
                        return nil
                    }
              return InkAccount(id: entity.id,
                                avatarUrl: avatar,
                                name: name,
                                lastRefreshTime: lastRefreshTime,
                                friendCode: friendCode,
                                sessionToken: sessionToken,
                                bulletToken:bulletToken,
                                webServiceToken:webServiceToken
                                )
          }
      } catch let error as NSError {
          os_log("查询账户信息失败: \(error.localizedDescription)")
      }
      return nil
  }

  func getAllAccounts() async -> [InkAccount] {
      let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()

      do {
          let result = try await context.perform {
              try self.context.fetch(fetchRequest)
          }

          return result.compactMap { entity in
              // 仅当所有关键属性都存在时，才创建InkAccount实例
              guard let sessionToken = entity.sessionToken,
                    let avatar = entity.avatar,
                    let name = entity.name,
                    let lastRefreshTime = entity.lastRefreshTime,
                    let friendCode = entity.friendCode,
                    let webServiceToken = entity.webServiceToken?.decode(WebServiceTokenStruct.self),
                    let bulletToken = entity.bulletToken else {
                        return nil
                    }

              return InkAccount(id: entity.id,
                                avatarUrl: avatar,
                                name: name,
                                lastRefreshTime: lastRefreshTime,
                                friendCode: friendCode,
                                sessionToken: sessionToken,
                                bulletToken:bulletToken,
                                webServiceToken:webServiceToken
                                )
          }
      } catch let error as NSError {
          os_log("查询所有账户信息失败: \(error.localizedDescription)")
          return []
      }
  }


}
