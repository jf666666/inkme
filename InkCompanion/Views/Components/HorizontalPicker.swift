//
//  SwiftUIView.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/14/23.
//

import SwiftUI


struct HorizontalPicker: View {
  @Binding var selection: ScheduleMode
  @State var selectedX: CGFloat = 0
  @State var x: [CGFloat] = [0, 0, 0, 0]
  @State var color: Color = .teal

  var body: some View {
    HStack {
      ForEach(ScheduleMode.allCases.filter{$0 != .fest}, id: \.self) { mode in
        Button(action: {
          withAnimation {
            Haptics.generateIfEnabled(.selectionChanged)
            self.selection = mode
            color = mode.themeColor
          }
        }) {
          mode.icon

        }
        //        .overlay(
        //            GeometryReader { proxy in
        //                let offset = proxy.frame(in: .global).minX
        //                Color.clear
        //                    .preference(key: PickerPreferenceKey.self, value: offset)
        //                    .onPreferenceChange(PickerPreferenceKey.self) { value in
        //                        x[index] = value
        //                        if selection == index {
        //                            selectedX = x[index]
        //                        }
        //                    }
        //            }
        //        )
      }
    }
    .background(
      HStack{

      }
    )
    .animation(.linear,value: selection)
  }
}

private struct PickerPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}



struct SegmentedPicker<T:IconPicker>: View {
  @Binding var selection: T
  let options:[T]
  @State private var backgroundOffset: CGFloat = 0

  var body: some View {
    GeometryReader { geometry in
      ZStack{
        HStack(spacing: 0) {
          ForEach(options.indices, id: \.self) { index in
            options[index].icon
              .frame(maxWidth: .infinity)
              .onTapGesture {
                Haptics.generateIfEnabled(.selectionChanged)
                withAnimation(.linear(duration: 0.15)) {

                  self.selection = options[index]
                  self.backgroundOffset = geometry.size.width / CGFloat(options.count) * CGFloat(index) - CGFloat(1.5*Double(index))
                }
              }
          }
        }


        .background(
          RoundedRectangle(cornerRadius: 5)
            .fill(.pickerItem)
            .offset(x: self.backgroundOffset, y: 0)
            .frame(width:geometry.size.width / CGFloat(options.count),height: geometry.size.width / CGFloat(options.count)),
          alignment: .leading
        )

        .frame(height: geometry.size.width / CGFloat(options.count))
        .padding(.all , 3)
        .background(.pickerBackground)
        .continuousCornerRadius(8)
      }

    }
    .frame(width: 150, height:30)
    .padding(.vertical, 3)
  }
}

protocol IconPicker{
  var icon:Image { get }
}

extension ScheduleMode:IconPicker {}


