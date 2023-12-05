//
//  VsStage.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/3/23.
//

import Foundation

struct VsStage: Codable,Stage {
  var id: String
  var name: String
  var image: Icon?
  //    let originalImage:Icon?
  let stats: VsStageRecordStats?
  var localizedName:String{id.localizedString}
}



