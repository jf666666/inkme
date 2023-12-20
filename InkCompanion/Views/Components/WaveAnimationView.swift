//
//  WaveSinView.swift
//  trafficStat
//
//  Created by Dolor•Sawalon•Zerlz on 2021/9/15.
//

/*
 基础知识：
 y=A*sin(wt±φ)
 A 為波幅/振幅（縱軸）， ω 為角频率， t 為時間（橫軸）， θ 為相偏移（橫軸左右）
 A振幅，离开平衡位置的距离
 以下为左边原点在左下角
 w变大横坐标压缩，w变小横坐标拉伸(相对于sin(x))
 θ为Pi * 1/3,则坐标不变横坐标向左边偏移Pi * 1/3(相对于sin(x))
 θ为-Pi * 1/3,则坐标不变横坐标向右边偏移Pi * 1/3(相对于sin(x))
 A变大则横坐标不变，则纵坐标变为A倍，
 比如A=2,则纵坐标为原来的2倍，A=1/2，则纵坐标为原来的1/2倍
 A=-1，则曲线根据X轴进行了翻转
 A=-2，则在-1的基础上进行拉伸

 https://www.bilibili.com/video/BV1a7411s75L/?spm_id_from=333.788.recommend_more_video.-1


 https://zh.wikipedia.org/wiki/正弦曲線
 y=A*sin(kx-wt - φ) + D
 k 為波數（周期密度）， D 為（直流）偏移量（y軸高低

 https://zh.wikipedia.org/wiki/抛物线
 让波浪不规则
 */
import SwiftUI

public struct SineWaveShape: Shape {

  public var animatableData: Double {
    get { phase }
    set { self.phase = newValue }
  }
  //波浪的高度相对于rect.height的百分比
  var percent: Double

  //波浪振幅
  var strength: Double

  // 频率
  var frequency: Double

  // 波浪的相位
  var phase: Double

  var totalWidth: Double // 新增属性

  public init(
    percent: Double,
    strength: Double,
    frequency: Double,
    phase: Double,
    totalWidth: Double

  ) {
    self.percent = percent
    self.strength = strength
    self.frequency = frequency
    self.phase = phase
    self.totalWidth = totalWidth
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = totalWidth
    let height = Double(rect.height)
    let midWidth = width / 2
    let oneOverMidWidth = 1 / midWidth

    //根据 波的相速度 / 频率 = 波长
    let wavelength = width / frequency

    //从左边的终点开始画
    path.move(to: CGPoint(x: 0, y: height))

    // 根据x轴,计算每个横向点对应的y位置
    for x in stride(from: 0, through: Double(rect.width), by: 1) {
      //找到当前x相对于波长的位置
      let relativeX = x / wavelength

      //当前x距离中心位置多远
      let distanceFromMidWidth = x - midWidth

      // 波浪规则变化系数， 从-1 到 1的变化（让曲线不是一成不变的
      let normalDistance = oneOverMidWidth * distanceFromMidWidth

      let parabola = -(normalDistance * normalDistance) + 1


      //计算那个位置的正弦，加上我们的相位偏移
      let sine = sin(relativeX + phase)

      //将计算出来的正弦乘以我们的波浪振幅然后再乘以规则变化系数以确定最终偏移量，然后将其向下移动到midHeight
      let y = parabola * strength * sine + height * percent

      // 画线
      path.addLine(to: CGPoint(x: x, y: y))
    }

    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
    path.addLine(to: CGPoint(x: 0, y: rect.height))
    path.closeSubpath()
    return path

  }
}



struct WaveBar:View {
  let colors:[Color]
  let proportion:[Int]
  var body: some View {
    GeometryReader{geo in
      HStack(spacing:0){
        
      }
    }
  }
}

struct WaveBarView: View {
    @State  var phase: Double = 0
    @State  var percent: Double = 0.4
    @State  var circleLineWidth: CGFloat = 1.0
    @State  var strokeColor: Color = Color.blue
    @State  var color1: Color = Color.accent
    @State  var color2: Color = .blue

     var body: some View {
        HStack(spacing: 0) {
            WaveBarUnit(
                phase: $phase,
                frequency: 3,
                duration: 2,
                strength: 30,
                percent: $percent,
                circleLineWidth: $circleLineWidth,
                strokeColor: $strokeColor,
                color1: $color1, totalWidth: 350
            )
            .frame(width: 250, height: 30)
            WaveBarUnit(
                phase: $phase,
                frequency: 3,
                duration: 2,
                strength: 30,
                percent: $percent,
                circleLineWidth: $circleLineWidth,
                strokeColor: $strokeColor,
                color1: $color2, totalWidth: 350
            )
            .frame(width: 100, height: 30)

        }
        .onAppear {
          withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            phase = .pi * 2
          }
        }
    }
}

struct WaveBarUnit: View {
  @Binding var phase: Double
      let frequency: Double
      let duration: Double
      let strength: Double
      @Binding var percent: Double
      @Binding var circleLineWidth: CGFloat
      @Binding var strokeColor: Color
      @Binding var color1: Color
  var totalWidth: CGFloat


  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 0, style: .continuous)
        .stroke(.clear, lineWidth: circleLineWidth)
        .background(
          ZStack {
            Color(.white)
            SineWaveShape(percent: percent, strength: strength * 0.5, frequency: frequency + 2, phase: self.phase, totalWidth: Double(totalWidth))
              .fill(color1)
              .offset(y: CGFloat(1) * 1)
              .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: self.phase)

            SineWaveShape(percent: percent, strength: strength * 0.4, frequency: frequency + 1, phase: self.phase, totalWidth: Double(totalWidth))
              .fill(color1.opacity(0.7))
              .offset(y: CGFloat(2) * 1)

              .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: self.phase)
            SineWaveShape(percent: percent, strength: strength * 0.2, frequency: frequency, phase: self.phase, totalWidth: Double(totalWidth))
              .fill(color1.opacity(0.4))
              .offset(y: CGFloat(3) * 1)
              .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: self.phase)
          }
            .clipShape(RoundedRectangle(cornerRadius: 0))

        )
    }
  }
}

struct ContentViews_Previews: PreviewProvider {
    static var previews: some View {
        WaveBarView()
    }
}
