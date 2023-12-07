import SwiftUI
import AuthenticationServices
import CoreData
import AlertToast
//import UniformTypeIdentifiers
//import SPAlert
import Kingfisher

struct SettingView: View {
  @State private var isPickerPresented = false

  @Binding var showSettings:Bool
  @State var showImportActionSheet:Bool = false
  @State var showLogginActionSheet:Bool = false
  @State var showAlert:Bool = false
  @State var userInput:String = ""

  @ObservedObject var inkUserDefaults = InkUserDefaults.shared

  @EnvironmentObject var accountViewModel:AccountViewModel

  let Nintendo = InkNet.NintendoService()
  var isLoggedin:Bool{InkUserDefaults.shared.sessionToken != nil}

  var body: some View {
    NavigationStack {
      List{

        Section {

          ForEach(accountViewModel.accounts){player in
            AccountRow(player: player)
              .swipeActions{
                Button{
                  DispatchQueue.main.sync {
                    withAnimation {
                      accountViewModel.selectedAccount = player
                    }
                  }
                } label: {
                  Label("删除",systemImage: "trash")
                }
              }
              .tint(.red)
          }


          addAccount
            .onTapGesture {
              showLogginActionSheet = true
            }
            .confirmationDialog("登陆账号", isPresented: $showLogginActionSheet) {
              Button("通过网页登陆"){
                Task{
                 await InkNet.NintendoService().initiateLoginProcess()
                }
              }
              Button("通过会话令牌登陆"){
                if let token = UIPasteboard.general.string{
                  print(token)
                  Task{
                    await accountViewModel.addAccount(sessionToken: token)
                  }
                }
              }
            }

        } header: {
          Text("账号管理")
        }


        if isLoggedin {
          Section {
            Text("sessionToken")
              .onTapGesture {
                UIPasteboard.general.string = InkUserDefaults.shared.sessionToken
//                SPAlert.present(title: "Copied", preset: .done)
              }
            Button {

            } label: {
              Text("退出登陆")
            }

          } header: {
            Text("登陆状态")
          } footer: {
            Text("退出登陆不会清除数据库中的记录")
          }
        }

        Section {
          Text("鲑鱼跑记录数量 ：\(InkData.shared.countDetailsMatchingFilter(filter: FilterProps(modes: ["salmon_run"])))")

          Text("对战记录数量 ：\(InkData.shared.countDetailsMatchingFilter(filter: FilterProps(modes: ["salmon_run"],inverted: true)))")

          if let url = PersistenceController.shared.container.persistentStoreDescriptions.first?.url {
            Text(url.path())
          }
        } header: {
          Text("数据库")
        }


        Button("登录") {
          Task{
            await Nintendo.initiateLoginProcess()
          }
        }

        Button("处理数据"){
          Task{
            await InkData.shared.processOldData()
          }
        }

        Button("导入数据") {
          showImportActionSheet = true
        }
        .actionSheet(isPresented: $showImportActionSheet) {
          ActionSheet(
            title: Text("导入数据"),
            message: Text("导入json数据"),
            buttons: [
              .default(Text("选择文件"), action: {
                isPickerPresented = true
              }),
              .cancel()
            ])
        }
        .sheet(isPresented: $isPickerPresented) {
          FilePickerView(fileType: .json) { url in
            importJsonData(from: url)
          }
        }


        Button("删除前10个Detail"){
          Task{
            await InkData.shared.deleteDetail(count: 50)
          }
        }



      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("设置")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button {
          showSettings = false
        } label: {
          Text("完成")
            .foregroundStyle(.accent)
            .frame(height: 40)
        }
      }


    }
  }

  var addAccount:some View{
    HStack(spacing:10){
      Image(systemName: "plus")
        .resizable()
        .scaledToFit()
        .foregroundStyle(.accent)
        .padding(10)
        .frame(width: 40, height: 40)
        .background(Circle().fill(Color.gray))
        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
        .shadow(radius: 5)
      VStack(alignment: .leading){
        Text("***")
          .font(.system(size: 20))
          .bold()
        Text("SW-XXXX-XXXX-XXXX")
          .foregroundStyle(.secondary)
          .font(.system(size: 12))
      }
      Spacer()
    }
  }
}





struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(true) { showSettings in
      SettingView(showSettings: .constant(true))
        .environmentObject(AccountViewModel())
    }
  }
}




struct AccountRow:View {
  let player:InkAccount
  @ObservedObject var inkUserDefaults = InkUserDefaults.shared
  @EnvironmentObject var accountViewModel:AccountViewModel
  var isSelected:Bool{
    player.sessionToken == inkUserDefaults.sessionToken
  }
  var body: some View {
    HStack(spacing:10){
      KFImage(URL(string: player.avatarUrl))
        .resizable()
        .resizedToFit()
        .clipShape(Circle())
        .frame(width: 40, height: 40)
        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
        .shadow(radius: 5)
      VStack(alignment: .leading){
        Text(player.name)
          .font(.system(size: 20))
          .bold()
        Text("SW-\(player.friendCode)")
          .foregroundStyle(.secondary)
          .font(.system(size: 12))
      }
      Spacer()
      if accountViewModel.selectedAccount == player{
        Image(systemName: "checkmark")
          .foregroundStyle(.spGreen)
      }
    }
    .onTapGesture {
      DispatchQueue.main.async {
        InkUserDefaults.shared.sessionToken = player.sessionToken
        InkUserDefaults.shared.webServiceToken = player.webServiceToken.encode()
        InkUserDefaults.shared.bulletToken = player.bulletToken
        InkUserDefaults.shared.currentUserKey = String(player.id)
      }

      accountViewModel.selectedAccount = player
    }
  }
}
