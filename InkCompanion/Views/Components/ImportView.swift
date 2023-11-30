//
//  ImportView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/28/23.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftyJSON

struct ImportView: View {
  @State private var isPickerPresented = false

      var body: some View {
          Button("Import JSON Data") {
              isPickerPresented = true
          }
          .fileImporter(
              isPresented: $isPickerPresented,
              allowedContentTypes: [UTType.json],
              allowsMultipleSelection: false
          ) { result in
              switch result {
              case .success(let url):
                  importJsonData(from: url[0])
              case .failure(let error):
                  // 处理错误
                  print("Error importing file: \(error.localizedDescription)")
              }
          }
      }


}

#Preview {
    ImportView()
}

func importJsonData(from url: URL) {
  struct temp:Codable{
    struct temp1:Codable{
      let coopHistoryDetail:CoopHistoryDetail
    }
    let coops:[temp1]
  }
    do {
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let data = try decoder.decode(temp.self, from: jsonData)
      for detail in data.coops{
        if !InkData.shared.isExist(id: detail.coopHistoryDetail.id){
          InkData.shared.addCoop(detail: detail.coopHistoryDetail)
        }
      }
    } catch {
        print("Error reading or decoding JSON: \(error)")
    }
}
