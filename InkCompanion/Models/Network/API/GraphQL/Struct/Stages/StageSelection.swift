//
//  StageSelection.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import Foundation
import SwiftUI

enum StageSelection:String,CaseIterable {
  case MaroonersBay = "Q29vcFN0YWdlLTY="
  case SalmonidSmokeyard = "Q29vcFN0YWdlLTQ="
  case GoneFissionHydropplant = "Q29vcFN0YWdlLTc="
  case JamminSalmonJunction = "Q29vcFN0YWdlLTg="
  case SpawningGrounds = "Q29vcFN0YWdlLTE="
  case SockeyeStation = "Q29vcFN0YWdlLTI="
  case BarnacleDime = "Q29vcFN0YWdlLTEwNQ=="
  case BonerattleArena = "Q29vcFN0YWdlLTk="
  case ScorchGorge="VnNTdGFnZS0x"
  case MarlinAirport = "VnNTdGFnZS0yMw=="
  case EeltailAlley="VnNTdGFnZS0y"
  case HagglefishMarket="VnNTdGFnZS0z"
  case UndertowSpillway="VnNTdGFnZS00"
  case UmamiRuins="VnNTdGFnZS01"
  case MincemeatMetalworks="VnNTdGFnZS02"
  case BrinewaterSprings="VnNTdGFnZS03"
  case FlounderHeights="VnNTdGFnZS05"
  case HammerheadBridge="VnNTdGFnZS0xMA=="
  case MuseumdAlfonsino="VnNTdGFnZS0xMQ=="
  case MahiMahiResort="VnNTdGFnZS0xMg=="
  case InkblotArtAcademy="VnNTdGFnZS0xMw=="
  case SturgeonShipyard="VnNTdGFnZS0xNA=="
  case MakoMart="VnNTdGFnZS0xNQ=="
  case WahooWorld="VnNTdGFnZS0xNg=="
  case HumpbackPumpTrack="VnNTdGFnZS0xNw=="
  case MantaMaria="VnNTdGFnZS0xOA=="
  case CrablegCapital="VnNTdGFnZS0xOQ=="
  case ShipshapeCargoCo="VnNTdGFnZS0yMA=="
  case RoboROMen="VnNTdGFnZS0yMQ=="
  case BluefinDepot="VnNTdGFnZS0yMg=="
  case unknown = "? ? ?"

  init?(additionalRawValue: String) {
    switch additionalRawValue {
    case "VnNTdGFnZS04":
      self = .BarnacleDime
    default:
      return nil
    }
  }

  static func getStageSelection(from rawValue: String) ->StageSelection{
    if let selection = StageSelection(rawValue: rawValue){
      return selection
    }
    if let selection = StageSelection(additionalRawValue: rawValue){
      return selection
    }
    return .unknown
  }

}

extension StageSelection {
  var image:Image{
    if let _ = UIImage(named: self.rawValue.stageName){
      return Image(self.rawValue.stageName)
    }
    return Image(.unknownStage)
  }
}

extension StageSelection{
  var name:String{
    self.rawValue.localizedString
  }
}
