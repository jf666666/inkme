import SwiftUI
import AuthenticationServices
import CoreData
import AlertToast
import UniformTypeIdentifiers

struct LoginView: View {

  @Environment(\.managedObjectContext) var managedObjectContext
  @State private var got:Bool = false
  @State private var isPickerPresented = false
  
  let Nintendo = InkNet.NintendoService()

  var body: some View {
    VStack{
      Button("登录") {
        //                    authSessionManager.login()
        Task{
          await Nintendo.initiateLoginProcess()
        }
      }

      Button("5秒后通知"){

        // 发送一个在5秒后触发的通知
        postUserNotification(title: "Hello", body: "This is a test notification.", interval: 5)

        
      }

      Button("Import JSON Data") {
          isPickerPresented = true
      }
      .sheet(isPresented: $isPickerPresented) {
        DocumentPicker { url in
          // 在这里处理选择的文件
          importJsonData(from: url)
        }
      }


      Button("获取Catalog"){

        FetchGraphQl(

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

      }

      Button("获取WeaponRecord"){

        FetchGraphQl(

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

      }

      Button("获取Eq"){

        FetchGraphQl(

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

      }

      Button("获取LatestBattleHistoriesQuery"){

        FetchGraphQl(

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

      }

      Button("获取RegularBattleHistories"){

        FetchGraphQl(

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

      }

      Button("获取XBattleHistories"){

        FetchGraphQl(

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

      }
      Button("获取EventBattleHistories"){

        FetchGraphQl(
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

      }
      Button("获取PrivateBattleHistories"){

        FetchGraphQl(

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

      }


      Button("获取CoopHistories"){

        FetchGraphQl(

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

      }

      Button("获取Schedules"){

        FetchGraphQl(

          language: "zh-CN",
          hash: .StageScheduleQuery, variables: nil
        ){(result: Result<StageSchedules, Error>) in
          switch result{
          case .success(let historyRecordQuery):
            print("Hitory: \(historyRecordQuery)")

            self.got = true
          case .failure(let error):
            print(error)
          }

        }

      }





      Button("显示字体"){
        for family in UIFont.familyNames.sorted() {
          let names = UIFont.fontNames(forFamilyName: family)
          print("Family: \(family) Font names: \(names)")
        }
      }

      Button("删除前10个Detail"){
        Task{
         await InkData.shared.deleteDetail(count: 3)
        }
      }

      Button("查看data地址"){
        if let url = PersistenceController.shared.container.persistentStoreDescriptions.first?.url {
          print("Database URL: \(url.path)")
        }
      }

      Button("获取VotingStatus"){

        fetchFestival(){ res in
          switch res{
          case .success(let fest):
            FetchGraphQl(

              language: "zh-CN",
              hash: .DetailVotingStatusQuery, variables: [
                "festId":fest.festRecords?.nodes?[0].id ?? ""
              ]

            ){(result: Result<DetailVotingStatusQuery, Error>) in
              switch result{
              case .success(let historyRecordQuery):
                print("Hitory: \(historyRecordQuery)")
                self.got = true
              case .failure(let error):
                print(error)
              }

            }
          case .failure(let error):
            print("fetchFest failed \(error)")
          }

        }


      }

      FriendsView()
      
    
    }
    .toast(isPresenting: self.$got, tapToDismiss: true){
      AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Update Successful!")
    }

  }
}










struct LoginView_Previews: PreviewProvider {
  static var previews: some View {

    // 使用该上下文来创建 LoginView
    LoginView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}




