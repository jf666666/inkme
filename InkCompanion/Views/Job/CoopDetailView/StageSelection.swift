//
//  StageSelection.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/25/23.
//

import Foundation
import SwiftUI

enum StageSelection:String {
  case MaroonersBay = "Q29vcFN0YWdlLTY="
  case SalmonidSmokeyard = "Q29vcFN0YWdlLTQ="
  case GoneFissionHydropplant = "Q29vcFN0YWdlLTc="
  case JamminSalmonJunction = "Q29vcFN0YWdlLTg="
  case SpawningGrounds = "Q29vcFN0YWdlLTE="
  case SockeyeStation = "Q29vcFN0YWdlLTI="
  case BarnacleDime = "Q29vcFN0YWdlLTEwNQ=="

}

extension StageSelection {
  var image:Image{
    switch self {
    case .MaroonersBay:
      return Image(.copShakeship)
    case .SalmonidSmokeyard:
      return Image(.copShakelift)
    case .GoneFissionHydropplant:
      return Image(.copShakedent)
    case .JamminSalmonJunction:
      return Image(.copShakehighway)
    case .SpawningGrounds:
      return Image(.copShakeup)
    case .SockeyeStation:
      return Image(.copShakespiral)
    case .BarnacleDime:
      return Image(.vssSection)
    }
  }
}

extension StageSelection{
  var name:String{
    self.rawValue.localizedString
  }
}
