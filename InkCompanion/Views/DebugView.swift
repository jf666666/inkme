import SwiftUI
import AuthenticationServices
import CoreData
import AlertToast
//import UniformTypeIdentifiers
import SPAlert

struct SettingView: View {

  @State private var got:Bool = false
  @State private var isPickerPresented = false
  
  let Nintendo = InkNet.NintendoService()
  var isLoggedin:Bool{AppUserDefaults.shared.sessionToken != nil}

  var body: some View {
    NavigationStack {
      List{
        if isLoggedin {
          Section {
            Text("sessionToken")
              .onTapGesture {
                UIPasteboard.general.string = AppUserDefaults.shared.sessionToken
                SPAlert.present(title: "Copied", preset: .done)
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
        } else {
          /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
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

        Button("导入数据") {
            isPickerPresented = true
        }
        .sheet(isPresented: $isPickerPresented) {
          DocumentPicker { url in
            importJsonData(from: url)
          }
        }

        Button("删除前10个Detail"){
          Task{
           await InkData.shared.deleteDetail(count: 50)
          }
        }




      
      }
      .toast(isPresenting: self.$got, tapToDismiss: true){
        AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Update Successful!")
    }
    }

  }
}










struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}




