//
//  StageProtocol.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/10/23.
//

import Foundation

protocol Stage:Codable{
  var name: String? { get set}
  var image: Icon? { get set}
  var id:String {get set}
}
