//
//  addCoopStatus.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/11/23.
//

import Foundation

func addCoopStatus(coops:[CoopStatus]) -> CoopsStatus{
  let selfStatus = coops.map{$0.myself}.sum()
  let teamStatus = coops.map{$0.team}.sum()
  let member = coops.map{$0.member}.sum()
  let hazardLevel = coops.map{$0.dangerRate}.sum()
  let wave = coops.map{$0.wave}.sum()
  let clear = coops.filter{$0.clear}.count
  let exempt = coops.filter{$0.exempt}.count
  let bosses = coops.flatMap{$0.bosses}.sum()
  let kings = coops.compactMap {$0.king}.sum()
  let scales = coops.compactMap { $0.scale }.sum()
  let waves = coops.flatMap{$0.waves}.sum()
  let stages = [CoopsStatus.Stage(id: coops[0].stage, count: coops.count)]
  let weapons = coops.flatMap{$0.weapons}.countWeapons()
  let specialWeapons = coops.compactMap { $0.specialWeapon }.countSpecialWeapons()
  return CoopsStatus(count: coops.count,
                     exempt: exempt,
                     clear: clear,
                     wave: wave,
                     hazardLevel: hazardLevel,
                     selfStats: selfStatus,
                     member: member,
                     team: teamStatus,
                     bosses: bosses,
                     kings: kings,
                     scales: scales,
                     waves: waves,
                     stages: stages,
                     weapons: weapons,
                     specialWeapons: specialWeapons)
}


struct CoopsStatus {
    var count: Int
    var exempt: Int
    var clear: Int
    var wave: Int
    var hazardLevel: Double
    var selfStats: CoopPlayerStats
    var member: Int
    var team: CoopPlayerStats
    var bosses: [BossSalmonidStats]
    var kings: [King]
    var scales: CoopStatus.Scale
    var waves: [WaveStats]
    var stages: [Stage]
    var weapons: [Weapon]
    var specialWeapons: [SpecialWeapon]





  struct Stage {
      var id: String
      var count: Int
  }

  struct Weapon {
      var id: String
      var count: Int
  }

  struct SpecialWeapon {
      var id: String
      var count: Int
  }

  struct King {
      var id: String
      var appear: Int
      var defeat: Int
  }

}



