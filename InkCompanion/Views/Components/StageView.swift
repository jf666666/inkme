//
//  StageView.swift
//  hailuowan
//
//  Created by 姜锋 on 10/30/23.
//

import SwiftUI
import Kingfisher

struct StageView: View {
    let stage: Stage
    
    var body: some View {
        VStack {
            KFImage(URL(string: stage.imageUrl)!)
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .aspectRatio(16 / 9, contentMode: .fit)
                }
                .resizedToFit(16 / 9)
                .cornerRadius(15)
                .accessibilityLabel(LocalizedStringKey(stage.name))
            
            Text(LocalizedStringKey(stage.name))
                .font(.footnote)
                .lineLimit(1)
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: Splatoon2ScheduleStage.theReef)
    }
}