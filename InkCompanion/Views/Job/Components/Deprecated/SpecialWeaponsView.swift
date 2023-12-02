//
//  SpecialWeaponsView.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/6/23.
//

import SwiftUI
import Kingfisher

struct GridView: View {
    // 假设这是你的图标数组
    let specialWeapon:[SpecialWeapon]
    // 定义网格布局的列
    let columns: [GridItem] = Array(repeating: .init(.flexible(),spacing: 5), count: 4)

    var body: some View {
        GeometryReader{ geometry in
            
            // 使用LazyVGrid创建网格
            LazyVGrid(columns: columns,spacing: 5) {
                // 遍历图标数组
                ForEach((0..<8), id: \.self) { index in
                    if index < specialWeapon.count {
                        // 如果索引在图标数组范围内，显示图标
                        KFImage(URL(string: specialWeapon[index].image?.url ?? ""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } else {
                        // 如果索引超出范围，显示占位符
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 20, height: 20)
                    }
                }
            }
//            .padding()
            .frame(width: geometry.size.width)
        }
    }
}

//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        let fileURL = Bundle.main.url(forResource: "CoopDetailHolder", withExtension: "json")
//            
//        let data = try? Data(contentsOf: fileURL!)
//                
//        let user = try? JSONDecoder().decode(CoopHistoryDetailQuery.self, from: data!)
//                    
//        return GridView(specialWeapon:(user?.data.coopHistoryDetail.waveResults?[3].specialWeapons)! )
//    }
//}
