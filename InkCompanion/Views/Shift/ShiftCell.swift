//
//  ShiftCell.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/3/23.
//

import SwiftUI
import Kingfisher

struct ShiftCell: View {
  let shift:CoopSchedule
  var stage:StageSelection{StageSelection(rawValue: shift.setting.coopStage.id) ?? .unknown}
  var timeString:String{
    shift.startTime.asDate.toSalmonTimeString() + " - " + shift.endTime.asDate.toSalmonTimeString()
  }
  var weapons:[String]{shift.setting.weapons.map{$0.image?.url ?? ""}}
  var boss:CoopEnemy{shift.setting.boss}
  var rule:CoopRule{shift.setting.rule}
  var body: some View {
    VStack{
      titleSection
      stageAndWeaponSection
    }
  }

  var titleSection:some View{
    HStack{
      rule.icon
        .resizable()
        .scaledToFit()
        .frame(width: 35)
      Spacer()
      Text(timeString)
        .colorInvert()
//        .scaledLimitedLine()
        .inkFont(.font1, size: 15, relativeTo: .body)
        .padding(5)
        .background(Color.secondary)
        .continuousCornerRadius(4)
    }
  }
  var stageSection:some View{
    VStack{
      stage.image
        .resizable()
        .scaledToFit()
        .clipped(antialiased: true)
        .continuousCornerRadius(3)
        .overlay(
          bossSection,
          alignment: .bottomTrailing
        )
      Text(stage.name)
        .inkFont(.font1, size: 18, relativeTo: .body)
        .foregroundStyle(.secondary)
    }
  }

  private var stageAndWeaponSection: some View {
    SalmonStageAndWeaponsLayout {
      stage.image
        .antialiased(true)
        .resizable()
        .scaledToFit()
        .continuousCornerRadius(4)
        .overlay(
          bossSection,
          alignment: .bottomTrailing
        )
      weaponSection
    }
  }
  var weaponSection:some View{
    LazyVGrid(columns: [
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]){
      ForEach(0..<weapons.count, id:\.self){index in
        KFImage(URL(string: weapons[index]))
          .resizable()
          .resizedToFit()
//          .frame(width: 50)
//          .background(.red)
          .background(.ultraThinMaterial)
          .continuousCornerRadius(5)
      }
    }
  }

  var line:some View{
    GeometryReader { geo in
      Path { path in
        path.move(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: geo.size.width, y: 0))
      }
      .stroke(style: StrokeStyle(lineWidth: 1))
      .foregroundColor(Color.waveDefeat)
    }
    .frame(height: 1)
  }
  var bossSection:some View{
//    VStack{
//      Text(boss.name)
//        .inkFont(.font1, size: 18, relativeTo: .body)
    GeometryReader{geo in
      VStack {
        Spacer()
        HStack(alignment: .bottom) {
          Text(stage.name)
            .inkFont(.font1, size: geo.size.height*0.12, relativeTo: .body)
            .padding(geo.size.height*0.02)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 3))
          Spacer()
          boss.enemy.image
            .resizable()
            .scaledToFit()
            .padding(geo.size.height*0.008)
            .background(.ultraThinMaterial)
            .continuousCornerRadius(geo.size.height*0.03)
          .frame(height: geo.size.height*0.25)
        }
      }
      .padding(geo.size.height*0.025)
    }

//    }

  }
}

#Preview {
  ShiftCell(shift: MockData.getStageQuery().data.coopGroupingSchedule!.bigRunSchedules.nodes![0])
    .padding(8)
    .textureBackground(texture: .bubble, radius: 18)
    .frame(width: 366,height: 180)
}
