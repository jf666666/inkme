//
//  DatePickerTest.swift
//  InkCompanion
//
//  Created by 姜锋 on 11/29/23.
//

import SwiftUI
import OverlayDatePicker

struct DatePickerTest: View {
  @State var isPresented = false
  @State var range: ClosedRange<Date>? = nil
    var body: some View {
      Button{
        withAnimation(.interactiveSpring) {
          self.isPresented = true
        }

      } label: {
        Text("datepicker")
      }
      .frame(width: 400,height: 400)
        .overlay {
          OverlayDateRangePicker(isPresented: $isPresented, range: range) { range in
            self.range = range
          }
        }

    }
}

#Preview {
    DatePickerTest()
}
