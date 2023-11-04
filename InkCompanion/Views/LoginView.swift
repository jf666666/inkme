import SwiftUI
import AuthenticationServices
import CoreData
import AlertToast

class AuthSessionManager: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var isLoggingIn = false

    
    private var authSession: ASWebAuthenticationSession?
    var managedObjectContext: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
            self.managedObjectContext = context
        }

    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

    func login() {
        // 假设generateLogIn和getSessionToken已经被转换为Swift函数
        self.isLoggingIn = true
        generateLogIn { loginURL, cv in
            guard let loginURL = loginURL, let cv = cv else {
                self.isLoggingIn = false
                return
            }
            
            DispatchQueue.main.async {
                self.authSession = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, error in
                    if let callbackURL = callbackURL {
                        // 处理认证成功的回调URL
                        getSessionToken(from: callbackURL, cv: cv) { token in
                            print("SessionToken: \(token ?? "")")
                            UserDefaultsManager.set(value: token, forKey: Keys.SessionToken)
                        }
                        updateTokens(){isUpated in 
                            
                        }
                    } else if let error = error {
                        print("error: \(error.localizedDescription)")
                        // 处理错误
                    }
                    self.isLoggingIn = false
                }
                self.authSession?.presentationContextProvider = self
                self.authSession?.start()
            }
        }
    }
    
    

}

struct LoginView: View {
    @StateObject private var authSessionManager: AuthSessionManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var got:Bool = false
    
    init() {
        // 从环境中获取 managedObjectContext 并传递给 AuthSessionManager
        let context = PersistenceController.shared.container.viewContext
        _authSessionManager = StateObject(wrappedValue: AuthSessionManager(context: context))
    }
    
    var body: some View {
            VStack{
                Button("登录") {
                    authSessionManager.login()
                
                }
                Button("获取朋友列表"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: httpAcceptLanguageFormat(),
                            hash: .FriendListQuery, variables: nil
                        ){(result: Result<FriendListResult, Error>) in
                            switch result{
                            case .success(let FriendListResult):
                                updateFriendsInDatabase(with: (FriendListResult.data.friends?.nodes!)!, in: managedObjectContext)
                                print("friends updated")
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取summery"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .HistoryRecordQuery, variables: nil
                        ){(result: Result<HistoryRecordQuery, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                Button("获取Catalog"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .CatalogQuery, variables: nil
                        ){(result: Result<CatalogQuery, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取WeaponRecord"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .WeaponRecordQuery, variables: nil
                        ){(result: Result<WeaponRecordQuery, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取Eq"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .MyOutfitCommonDataEquipmentsQuery, variables: nil
                        ){(result: Result<MyOutfitCommonDataEquipmentsQuery, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取LatestBattleHistoriesQuery"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .LatestBattleHistoriesQuery, variables: nil
                        ){(result: Result<LatestBattleHistoriesQuery, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取RegularBattleHistories"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .RegularBattleHistoriesQuery, variables: nil
                        ){(result: Result<RegularBattleHistories, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取XBattleHistories"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .XBattleHistoriesQuery, variables: nil
                        ){(result: Result<XBattleHistories, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                Button("获取EventBattleHistories"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .EventBattleHistoriesQuery, variables: nil
                        ){(result: Result<EventBattleHistories, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                Button("获取PrivateBattleHistories"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .PrivateBattleHistoriesQuery, variables: nil
                        ){(result: Result<PrivateBattleHistories, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                
                Button("获取CoopHistories"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        FetchGraphQl(
                            webServiceToken: webServiceToken,
                            bulletToken: bulletToken,
                            language: "zh-CN",
                            hash: .CoopHistoryQuery, variables: nil
                        ){(result: Result<CoopHistories, Error>) in
                            switch result{
                            case .success(let historyRecordQuery):
                                print("Hitory: \(historyRecordQuery)")
                                self.got = true
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                Button("获取VotingStatus"){
                    if let webServiceToken:WebServiceTokenStruct = fetchWebServiceToken(in: self.managedObjectContext)?.toWebServiceTokenStruct(),let bulletToken = UserDefaultsManager.string(forKey: Keys.BulletToken){
                        fetchFestival(){ res in
                            switch res{
                            case .success(let fest):
                                FetchGraphQl(
                                    webServiceToken: webServiceToken,
                                    bulletToken: bulletToken,
                                    language: "zh-CN",
                                    hash: .DetailVotingStatusQuery, variables: fest.festRecords?.nodes?[0].id
                                ){(result: Result<DetailVotingStatusQuery, Error>) in
                                    switch result{
                                    case .success(let historyRecordQuery):
                                        print("Hitory: \(historyRecordQuery)")
                                    case .failure(let error):
                                        print(error)
                                    }
                                    
                                }
                            case .failure(let error):
                                print("fetchFest failed \(error)")
                            }
                            
                        }
        
                    }else{
                        print("获取webservicetoken失败 获取bullettoken失败")
                    }
                }
                
                FriendsView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .toast(isPresenting: self.$got, tapToDismiss: true){
                AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Update Successful!")
            }
  
    }
}





func fetchWebServiceToken(in context: NSManagedObjectContext) -> WebServiceTokenEntity? {
    let fetchRequest: NSFetchRequest<WebServiceTokenEntity> = WebServiceTokenEntity.fetchRequest()

    do {
        let results = try context.fetch(fetchRequest)
        return results.first
    } catch {
        // 这里可以选择处理错误，或者将错误抛出给调用者
        // 例如，你可以返回 nil 或者抛出一个自定义错误
        return nil
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        // 使用该上下文来创建 LoginView
        LoginView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



func updateFriendsInDatabase(with newFriendsList: [FriendListResult.Data.Friends.Node], in context: NSManagedObjectContext) {
    // 获取当前数据库中的所有朋友
    let fetchRequest: NSFetchRequest<FriendEntity> = FriendEntity.fetchRequest()
    
    do {
        let existingFriends = try context.fetch(fetchRequest)
        _ = existingFriends.map { $0.id }
        
        // 将新朋友列表转换为ID集合
        let newFriendsIds = Set(newFriendsList.map { $0.id })
        
        // 删除不在新列表中的朋友
        for friend in existingFriends where !newFriendsIds.contains(friend.id ?? "") {
            context.delete(friend)
        }
        
        // 添加或更新朋友
        for newFriend in newFriendsList {
            if let existingFriend = existingFriends.first(where: { $0.id == newFriend.id }) {
                // 更新现有朋友信息
                existingFriend.id = newFriend.id
                existingFriend.onlineState = newFriend.onlineState
                existingFriend.iconURL = newFriend.userIcon?.url
                existingFriend.coopRule = newFriend.coopRule
                existingFriend.nickname = newFriend.nickname
                existingFriend.isVcEnabled = newFriend.isVcEnabled ?? false
                existingFriend.isLocked = newFriend.isLocked ?? false
                existingFriend.playerName = newFriend.playerName
                existingFriend.vsMode = newFriend.vsMode?.id
                if newFriend.onlineState != "OFFLINE"{
                    existingFriend.isOnline = true
                }
            } else {
                // 添加新朋友
                let newFriendEntity = FriendEntity(context: context)
                newFriendEntity.id = newFriend.id
                newFriendEntity.onlineState = newFriend.onlineState
                newFriendEntity.iconURL = newFriend.userIcon?.url
                newFriendEntity.coopRule = newFriend.coopRule
                newFriendEntity.nickname = newFriend.nickname
                newFriendEntity.isVcEnabled = newFriend.isVcEnabled ?? false
                newFriendEntity.isLocked = newFriend.isLocked ?? false
                newFriendEntity.playerName = newFriend.playerName
                newFriendEntity.vsMode = newFriend.vsMode?.id
                if newFriend.onlineState != "OFFLINE"{
                    newFriendEntity.isOnline = true
                }
            }
        }
        
        // 保存更改
        if context.hasChanges {
            try context.save()
        }
    } catch {
        print("Failed to update friends in database: \(error)")
    }
}
