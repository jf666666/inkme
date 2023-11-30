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
          KFImage(URL(string: stage.image?.url ?? ""))
            .antialiased(true)
            .resizable()
            .scaledToFit()
            .cornerRadius(5)
            .shadow(radius: 4)
            .overlay(
              StageTitleLabel(
                title: stage.name ?? "",
                fontSize: 13,
                relTextStyle: .body)
                .padding(.leading, 20)
                .padding([.bottom, .trailing], 2),
              alignment: .bottomTrailing)
            .animation(
              .snappy,
              value: false)


        }
    }
}



struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: CoopStage(__typename: nil, id: "", name: "比目鱼住宅区", coopStageId: 1, image: Icon(url: "https://api.lp1.av5ja.srv.nintendo.net/resources/prod/v2/stage_img/icon/low_resolution/488017f3ce712fca9fb37d61fe306343054449bb2d2bb1751d95f54a98564cae_1.png?Expires=1704844800&Signature=YdFSE7YYhY7WHK9V9WVKaxmYDA6EyABrvQgZNjFs1aDWyw1HDNdSZ6GfHaz~ldF584zy7nIC6MS~-20grcI1qJHbb77iXDjHMUrONeG-Cu2BMKfRyBZrinhSK2bWpBALQpdWeGRrjb0sMjNuUjJOcBZTm4JzD7aITbrWnOEaUnOpqxHhQxOXkZBPmGwxnPNjCgUHbG9sjq1wngwQ2e32fJY2huJNnciisoak~jLLMu-qP-dqXMcRzZDTjHKAYAAYwbQa8p4yLrZ26uTQSWE~NBtBLVpeV9M2UvuvYUkjXngrMSvCgwcTetNe~qBqlp69qjoc9Wa8lqa7ww~QBee76g__&Key-Pair-Id=KNBS2THMRC385"), thumbnailImage: nil))
    }
}
