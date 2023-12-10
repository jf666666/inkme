//
//  FestIcon.swift
//  InkCompanion
//
//  Created by 姜锋 on 12/10/23.
//

import SwiftUI


struct FestIcon: View {
  var ratio = 0.41
  var color1:Color = .red
  var color2:Color = .blue
  var color3:Color = .yellow
  var colorCircle:Color = .secondary
    var body: some View {
      GeometryReader { geo in
        Canvas{ context, size in
          context.fill(pathCircle(in: CGRect(x: 0, y: 0, width: size.width, height: size.height)), with: .color(colorCircle))
          context.fill(path3(in: CGRect(x: 0, y: 0, width: size.width*ratio, height: size.height*ratio)), with: .color(color3))
          context.translateBy(x: -geo.size.width*2/350, y: geo.size.width*12/350)
          context.fill(path1(in: CGRect(x: 0, y: 0, width: size.width*ratio, height: size.height*ratio)), with: .color(color1))
          context.translateBy(x: geo.size.width*2/350, y: -geo.size.width*12/350)
          context.fill(path2(in: CGRect(x: 0, y: 0, width: size.width*ratio, height: size.height*ratio)), with: .color(color2))
        }
        .frame(width: geo.size.width , height: geo.size.width)
      }
      .frame(width: 100)
    }
  
  func path2(in rect: CGRect) -> Path {
      var path = Path()
      let width = rect.size.width
      let height = rect.size.height
      path.move(to: CGPoint(x: 1.20127*width, y: 1.28282*height))
      path.addLine(to: CGPoint(x: 1.20458*width, y: 1.27609*height))
      path.addCurve(to: CGPoint(x: 1.12339*width, y: 1.10323*height), control1: CGPoint(x: 1.14655*width, y: 1.2018*height), control2: CGPoint(x: 1.12339*width, y: 1.10323*height))
      path.addLine(to: CGPoint(x: 1.03109*width, y: 1.05088*height))
      path.addLine(to: CGPoint(x: 0.84707*width, y: 0.94646*height))
      path.addCurve(to: CGPoint(x: 0.80408*width, y: 1.17167*height), control1: CGPoint(x: 0.78453*width, y: 1.04503*height), control2: CGPoint(x: 0.80408*width, y: 1.17167*height))
      path.addCurve(to: CGPoint(x: 1.00072*width, y: 1.25444*height), control1: CGPoint(x: 0.87142*width, y: 1.18308*height), control2: CGPoint(x: 0.97667*width, y: 1.24099*height))
      path.addLine(to: CGPoint(x: 1.00282*width, y: 1.25269*height))
      path.addCurve(to: CGPoint(x: 0.96313*width, y: 1.12049*height), control1: CGPoint(x: 0.97005*width, y: 1.19536*height), control2: CGPoint(x: 0.96313*width, y: 1.12049*height))
      path.addLine(to: CGPoint(x: 0.98839*width, y: 1.13072*height))
      path.addCurve(to: CGPoint(x: 1.00643*width, y: 1.20209*height), control1: CGPoint(x: 0.98629*width, y: 1.15676*height), control2: CGPoint(x: 1.00643*width, y: 1.20209*height))
      path.addLine(to: CGPoint(x: 1.20127*width, y: 1.28282*height))
      path.closeSubpath()
      path.move(to: CGPoint(x: 1.18535*width, y: 1.65778*height))
      path.addLine(to: CGPoint(x: 1.18655*width, y: 1.427*height))
      path.addCurve(to: CGPoint(x: 0.95021*width, y: 1.25415*height), control1: CGPoint(x: 1.13604*width, y: 1.36617*height), control2: CGPoint(x: 1.06267*width, y: 1.31147*height))
      path.addCurve(to: CGPoint(x: 0.62999*width, y: 1.17459*height), control1: CGPoint(x: 0.83325*width, y: 1.19448*height), control2: CGPoint(x: 0.72049*width, y: 1.17459*height))
      path.addCurve(to: CGPoint(x: 0.46612*width, y: 1.20121*height), control1: CGPoint(x: 0.55933*width, y: 1.17459*height), control2: CGPoint(x: 0.5022*width, y: 1.18658*height))
      path.addCurve(to: CGPoint(x: 0.32209*width, y: 1.618*height), control1: CGPoint(x: 0.38013*width, y: 1.23601*height), control2: CGPoint(x: 0.2394*width, y: 1.34979*height))
      path.addCurve(to: CGPoint(x: 0.62518*width, y: 1.94646*height), control1: CGPoint(x: 0.40417*width, y: 1.88416*height), control2: CGPoint(x: 0.62187*width, y: 1.94558*height))
      path.addCurve(to: CGPoint(x: 0.83776*width, y: 1.62268*height), control1: CGPoint(x: 0.80919*width, y: 1.86339*height), control2: CGPoint(x: 0.83776*width, y: 1.62268*height))
      path.addLine(to: CGPoint(x: 0.82754*width, y: 1.61595*height))
      path.addCurve(to: CGPoint(x: 0.75056*width, y: 1.67679*height), control1: CGPoint(x: 0.81761*width, y: 1.63877*height), control2: CGPoint(x: 0.78394*width, y: 1.6762*height))
      path.addCurve(to: CGPoint(x: 0.73222*width, y: 1.67299*height), control1: CGPoint(x: 0.74425*width, y: 1.67679*height), control2: CGPoint(x: 0.73823*width, y: 1.67591*height))
      path.addCurve(to: CGPoint(x: 0.68832*width, y: 1.51124*height), control1: CGPoint(x: 0.67359*width, y: 1.64695*height), control2: CGPoint(x: 0.65405*width, y: 1.55043*height))
      path.addCurve(to: CGPoint(x: 0.78394*width, y: 1.47204*height), control1: CGPoint(x: 0.70366*width, y: 1.4934*height), control2: CGPoint(x: 0.7241*width, y: 1.47175*height))
      path.addCurve(to: CGPoint(x: 0.94179*width, y: 1.50217*height), control1: CGPoint(x: 0.81972*width, y: 1.47204*height), control2: CGPoint(x: 0.86993*width, y: 1.48052*height))
      path.addCurve(to: CGPoint(x: 1.11528*width, y: 1.5981*height), control1: CGPoint(x: 1.0353*width, y: 1.53054*height), control2: CGPoint(x: 1.08672*width, y: 1.56769*height))
      path.addCurve(to: CGPoint(x: 1.13273*width, y: 1.66976*height), control1: CGPoint(x: 1.14475*width, y: 1.6294*height), control2: CGPoint(x: 1.15648*width, y: 1.67035*height))
      path.addCurve(to: CGPoint(x: 1.08762*width, y: 1.64725*height), control1: CGPoint(x: 1.12341*width, y: 1.66976*height), control2: CGPoint(x: 1.10867*width, y: 1.66304*height))
      path.addCurve(to: CGPoint(x: 1.0299*width, y: 1.55891*height), control1: CGPoint(x: 1.05425*width, y: 1.62209*height), control2: CGPoint(x: 1.0353*width, y: 1.58728*height))
      path.addCurve(to: CGPoint(x: 0.87865*width, y: 1.50568*height), control1: CGPoint(x: 1.00584*width, y: 1.53288*height), control2: CGPoint(x: 0.88166*width, y: 1.50627*height))
      path.addCurve(to: CGPoint(x: 1.19677*width, y: 1.86691*height), control1: CGPoint(x: 0.97246*width, y: 1.76716*height), control2: CGPoint(x: 1.1207*width, y: 1.86719*height))
      path.addCurve(to: CGPoint(x: 1.2109*width, y: 1.86544*height), control1: CGPoint(x: 1.20189*width, y: 1.86691*height), control2: CGPoint(x: 1.2067*width, y: 1.86632*height))
      path.addCurve(to: CGPoint(x: 1.28878*width, y: 1.6493*height), control1: CGPoint(x: 1.27345*width, y: 1.85257*height), control2: CGPoint(x: 1.31554*width, y: 1.77916*height))
      path.addCurve(to: CGPoint(x: 1.20429*width, y: 1.65894*height), control1: CGPoint(x: 1.26232*width, y: 1.65573*height), control2: CGPoint(x: 1.23406*width, y: 1.65982*height))
      path.addLine(to: CGPoint(x: 1.18535*width, y: 1.65778*height))
      path.closeSubpath()
      return path
  }

  func path1(in rect: CGRect) -> Path {
      var path = Path()
      let width = rect.size.width
      let height = rect.size.height
      path.move(to: CGPoint(x: 1.41533*width, y: 1.49789*height))
      path.addCurve(to: CGPoint(x: 1.40608*width, y: 1.46679*height), control1: CGPoint(x: 1.41175*width, y: 1.48865*height), control2: CGPoint(x: 1.40877*width, y: 1.47799*height))
      path.addCurve(to: CGPoint(x: 1.39117*width, y: 1.30004*height), control1: CGPoint(x: 1.39177*width, y: 1.40569*height), control2: CGPoint(x: 1.39088*width, y: 1.32274*height))
      path.addLine(to: CGPoint(x: 1.38849*width, y: 1.2992*height))
      path.addCurve(to: CGPoint(x: 1.29155*width, y: 1.39476*height), control1: CGPoint(x: 1.35418*width, y: 1.35329*height), control2: CGPoint(x: 1.29155*width, y: 1.39476*height))
      path.addLine(to: CGPoint(x: 1.29155*width, y: 1.39392*height))
      path.addLine(to: CGPoint(x: 1.28796*width, y: 1.3687*height))
      path.addCurve(to: CGPoint(x: 1.34196*width, y: 1.31994*height), control1: CGPoint(x: 1.31212*width, y: 1.35777*height), control2: CGPoint(x: 1.34196*width, y: 1.31994*height))
      path.addLine(to: CGPoint(x: 1.3169*width, y: 1.12488*height))
      path.addLine(to: CGPoint(x: 1.30944*width, y: 1.12545*height))
      path.addCurve(to: CGPoint(x: 1.197*width, y: 1.27397*height), control1: CGPoint(x: 1.27276*width, y: 1.20784*height), control2: CGPoint(x: 1.197*width, y: 1.27397*height))
      path.addLine(to: CGPoint(x: 1.1964*width, y: 1.39168*height))
      path.addLine(to: CGPoint(x: 1.1955*width, y: 1.57132*height))
      path.addCurve(to: CGPoint(x: 1.41563*width, y: 1.49817*height), control1: CGPoint(x: 1.31272*width, y: 1.5744*height), control2: CGPoint(x: 1.41413*width, y: 1.49957*height))
      path.addLine(to: CGPoint(x: 1.41533*width, y: 1.49789*height))
      path.closeSubpath()
      path.move(to: CGPoint(x: 1.60895*width, y: 1.75714*height))
      path.addCurve(to: CGPoint(x: 2.04832*width, y: 1.67362*height), control1: CGPoint(x: 1.68263*width, y: 1.80983*height), control2: CGPoint(x: 1.85235*width, y: 1.86895*height))
      path.addCurve(to: CGPoint(x: 2.18881*width, y: 1.27428*height), control1: CGPoint(x: 2.23086*width, y: 1.49175*height), control2: CGPoint(x: 2.19447*width, y: 1.29978*height))
      path.addCurve(to: CGPoint(x: 2.18821*width, y: 1.27203*height), control1: CGPoint(x: 2.18851*width, y: 1.27288*height), control2: CGPoint(x: 2.18821*width, y: 1.27203*height))
      path.addCurve(to: CGPoint(x: 1.79657*width, y: 1.2555*height), control1: CGPoint(x: 2.02356*width, y: 1.1633*height), control2: CGPoint(x: 1.79657*width, y: 1.2555*height))
      path.addLine(to: CGPoint(x: 1.79567*width, y: 1.26615*height))
      path.addCurve(to: CGPoint(x: 1.89262*width, y: 1.31211*height), control1: CGPoint(x: 1.82461*width, y: 1.26307*height), control2: CGPoint(x: 1.88545*width, y: 1.2754*height))
      path.addCurve(to: CGPoint(x: 1.89321*width, y: 1.31632*height), control1: CGPoint(x: 1.89291*width, y: 1.31351*height), control2: CGPoint(x: 1.89321*width, y: 1.31491*height))
      path.addCurve(to: CGPoint(x: 1.77211*width, y: 1.42925*height), control1: CGPoint(x: 1.89918*width, y: 1.37601*height), control2: CGPoint(x: 1.82371*width, y: 1.43794*height))
      path.addCurve(to: CGPoint(x: 1.63848*width, y: 1.22916*height), control1: CGPoint(x: 1.73453*width, y: 1.42281*height), control2: CGPoint(x: 1.68203*width, y: 1.41132*height))
      path.addCurve(to: CGPoint(x: 1.63729*width, y: 1.04224*height), control1: CGPoint(x: 1.61701*width, y: 1.1392*height), control2: CGPoint(x: 1.62446*width, y: 1.08007*height))
      path.addCurve(to: CGPoint(x: 1.69456*width, y: 1.00076*height), control1: CGPoint(x: 1.65161*width, y: 0.99964*height), control2: CGPoint(x: 1.68651*width, y: 0.96909*height))
      path.addCurve(to: CGPoint(x: 1.69456*width, y: 1.04167*height), control1: CGPoint(x: 1.69694*width, y: 1.00917*height), control2: CGPoint(x: 1.69725*width, y: 1.02262*height))
      path.addCurve(to: CGPoint(x: 1.64505*width, y: 1.13079*height), control1: CGPoint(x: 1.68889*width, y: 1.08063*height), control2: CGPoint(x: 1.66772*width, y: 1.11258*height))
      path.addCurve(to: CGPoint(x: 1.65161*width, y: 1.20366*height), control1: CGPoint(x: 1.64028*width, y: 1.1448*height), control2: CGPoint(x: 1.64505*width, y: 1.17451*height))
      path.addCurve(to: CGPoint(x: 1.67278*width, y: 1.27764*height), control1: CGPoint(x: 1.66056*width, y: 1.24121*height), control2: CGPoint(x: 1.67278*width, y: 1.27764*height))
      path.addCurve(to: CGPoint(x: 1.84698*width, y: 0.88221*height), control1: CGPoint(x: 1.82938*width, y: 1.10669*height), control2: CGPoint(x: 1.86369*width, y: 0.95985*height))
      path.addCurve(to: CGPoint(x: 1.8255*width, y: 0.83766*height), control1: CGPoint(x: 1.84281*width, y: 0.86288*height), control2: CGPoint(x: 1.83535*width, y: 0.84775*height))
      path.addCurve(to: CGPoint(x: 1.5839*width, y: 0.88895*height), control1: CGPoint(x: 1.78136*width, y: 0.79142*height), control2: CGPoint(x: 1.69038*width, y: 0.79478*height))
      path.addCurve(to: CGPoint(x: 1.55884*width, y: 0.91136*height), control1: CGPoint(x: 1.57525*width, y: 0.89539*height), control2: CGPoint(x: 1.5672*width, y: 0.90296*height))
      path.addCurve(to: CGPoint(x: 1.45236*width, y: 1.06185*height), control1: CGPoint(x: 1.51231*width, y: 0.95761*height), control2: CGPoint(x: 1.47682*width, y: 1.00469*height))
      path.addLine(to: CGPoint(x: 1.45295*width, y: 1.06185*height))
      path.addCurve(to: CGPoint(x: 1.41507*width, y: 1.34098*height), control1: CGPoint(x: 1.42253*width, y: 1.13248*height), control2: CGPoint(x: 1.4097*width, y: 1.21935*height))
      path.addCurve(to: CGPoint(x: 1.43029*width, y: 1.45616*height), control1: CGPoint(x: 1.41687*width, y: 1.3819*height), control2: CGPoint(x: 1.42223*width, y: 1.42029*height))
      path.addCurve(to: CGPoint(x: 1.60806*width, y: 1.75658*height), control1: CGPoint(x: 1.46548*width, y: 1.61113*height), control2: CGPoint(x: 1.55109*width, y: 1.71566*height))
      path.addLine(to: CGPoint(x: 1.60895*width, y: 1.75714*height))
      path.closeSubpath()
      return path
  }

  func path3(in rect: CGRect) -> Path {
      var path = Path()
      let width = rect.size.width
      let height = rect.size.height
      path.move(to: CGPoint(x: 1.21634*width, y: 1.2178*height))
      path.addLine(to: CGPoint(x: 1.22068*width, y: 1.2244*height))
      path.addCurve(to: CGPoint(x: 1.35635*width, y: 1.1989*height), control1: CGPoint(x: 1.3186*width, y: 1.21182*height), control2: CGPoint(x: 1.35635*width, y: 1.1989*height))
      path.addCurve(to: CGPoint(x: 1.48283*width, y: 1.20805*height), control1: CGPoint(x: 1.35635*width, y: 1.1989*height), control2: CGPoint(x: 1.39851*width, y: 1.20195*height))
      path.addCurve(to: CGPoint(x: 1.60524*width, y: 1.00985*height), control1: CGPoint(x: 1.5098*width, y: 1.1272*height), control2: CGPoint(x: 1.55225*width, y: 1.06711*height))
      path.addCurve(to: CGPoint(x: 1.63003*width, y: 0.98468*height), control1: CGPoint(x: 1.61361*width, y: 1.00104*height), control2: CGPoint(x: 1.62166*width, y: 0.99255*height))
      path.addCurve(to: CGPoint(x: 1.52281*width, y: 0.91768*height), control1: CGPoint(x: 1.57642*width, y: 0.93938*height), control2: CGPoint(x: 1.52281*width, y: 0.91768*height))
      path.addCurve(to: CGPoint(x: 1.34525*width, y: 1.05138*height), control1: CGPoint(x: 1.47757*width, y: 0.97273*height), control2: CGPoint(x: 1.37004*width, y: 1.03691*height))
      path.addLine(to: CGPoint(x: 1.34587*width, y: 1.05453*height))
      path.addCurve(to: CGPoint(x: 1.48779*width, y: 1.08944*height), control1: CGPoint(x: 1.41528*width, y: 1.05547*height), control2: CGPoint(x: 1.48779*width, y: 1.08944*height))
      path.addLine(to: CGPoint(x: 1.46518*width, y: 1.10675*height))
      path.addCurve(to: CGPoint(x: 1.39049*width, y: 1.08472*height), control1: CGPoint(x: 1.44224*width, y: 1.09071*height), control2: CGPoint(x: 1.39049*width, y: 1.08472*height))
      path.addLine(to: CGPoint(x: 1.21634*width, y: 1.2178*height))
      path.closeSubpath()
      path.move(to: CGPoint(x: 0.82023*width, y: 1.09447*height))
      path.addCurve(to: CGPoint(x: 0.85649*width, y: 1.00764*height), control1: CGPoint(x: 0.82797*width, y: 1.06553*height), control2: CGPoint(x: 0.83944*width, y: 1.03564*height))
      path.addLine(to: CGPoint(x: 0.86671*width, y: 0.99097*height))
      path.addLine(to: CGPoint(x: 1.0954*width, y: 1.12656*height))
      path.addCurve(to: CGPoint(x: 1.37275*width, y: 1.00606*height), control1: CGPoint(x: 1.17628*width, y: 1.11303*height), control2: CGPoint(x: 1.26336*width, y: 1.07622*height))
      path.addCurve(to: CGPoint(x: 1.67116*width, y: 0.59584*height), control1: CGPoint(x: 1.57727*width, y: 0.87456*height), control2: CGPoint(x: 1.65908*width, y: 0.68833*height))
      path.addCurve(to: CGPoint(x: 1.36283*width, y: 0.24129*height), control1: CGPoint(x: 1.68356*width, y: 0.49894*height), control2: CGPoint(x: 1.65164*width, y: 0.31082*height))
      path.addCurve(to: CGPoint(x: 0.90514*width, y: 0.33944*height), control1: CGPoint(x: 1.07402*width, y: 0.17176*height), control2: CGPoint(x: 0.90514*width, y: 0.33944*height))
      path.addCurve(to: CGPoint(x: 1.09292*width, y: 0.70626*height), control1: CGPoint(x: 0.88654*width, y: 0.55116*height), control2: CGPoint(x: 1.09292*width, y: 0.70626*height))
      path.addLine(to: CGPoint(x: 1.10439*width, y: 0.70059*height))
      path.addCurve(to: CGPoint(x: 1.10098*width, y: 0.58357*height), control1: CGPoint(x: 1.0858*width, y: 0.67543*height), control2: CGPoint(x: 1.06535*width, y: 0.60905*height))
      path.addCurve(to: CGPoint(x: 1.27203*width, y: 0.63075*height), control1: CGPoint(x: 1.15521*width, y: 0.54455*height), control2: CGPoint(x: 1.25344*width, y: 0.57854*height))
      path.addCurve(to: CGPoint(x: 1.14995*width, y: 0.86513*height), control1: CGPoint(x: 1.28536*width, y: 0.6685*height), control2: CGPoint(x: 1.30178*width, y: 0.72294*height))
      path.addCurve(to: CGPoint(x: 0.97238*width, y: 0.97084*height), control1: CGPoint(x: 1.07557*width, y: 0.93465*height), control2: CGPoint(x: 1.01515*width, y: 0.96108*height))
      path.addCurve(to: CGPoint(x: 0.94139*width, y: 0.91955*height), control1: CGPoint(x: 0.91134*width, y: 0.98467*height), control2: CGPoint(x: 0.85121*width, y: 0.95699*height))
      path.addCurve(to: CGPoint(x: 1.05233*width, y: 0.91483*height), control1: CGPoint(x: 0.98167*width, y: 0.90288*height), control2: CGPoint(x: 1.0232*width, y: 0.90446*height))
      path.addCurve(to: CGPoint(x: 1.17938*width, y: 0.8063*height), control1: CGPoint(x: 1.0889*width, y: 0.90697*height), control2: CGPoint(x: 1.17938*width, y: 0.8063*height))
      path.addCurve(to: CGPoint(x: 0.67799*width, y: 0.91421*height), control1: CGPoint(x: 0.87198*width, y: 0.74684*height), control2: CGPoint(x: 0.70092*width, y: 0.8428*height))
      path.addCurve(to: CGPoint(x: 0.82054*width, y: 1.0951*height), control1: CGPoint(x: 0.65847*width, y: 0.97555*height), control2: CGPoint(x: 0.69969*width, y: 1.04917*height))
      path.addLine(to: CGPoint(x: 0.82023*width, y: 1.09447*height))
      path.closeSubpath()
      return path
  }

  func pathCircle(in rect: CGRect) -> Path {
      var path = Path()
      let width = rect.size.width
      let height = rect.size.height
      path.move(to: CGPoint(x: 0.5*width, y: 0.99988*height))
      path.addCurve(to: CGPoint(x: 0, y: 0.49988*height), control1: CGPoint(x: 0.22389*width, y: 0.99988*height), control2: CGPoint(x: 0, y: 0.77599*height))
      path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0, y: 0.22377*height), control2: CGPoint(x: 0.22389*width, y: 0))
      path.addCurve(to: CGPoint(x: width, y: 0.5*height), control1: CGPoint(x: 0.77611*width, y: 0), control2: CGPoint(x: width, y: 0.22389*height))
      path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: width, y: 0.77611*height), control2: CGPoint(x: 0.77611*width, y: height))
      path.addLine(to: CGPoint(x: 0.5*width, y: 0.99988*height))
      path.closeSubpath()
      path.move(to: CGPoint(x: 0.90886*width, y: 0.49988*height))
      path.addCurve(to: CGPoint(x: 0.5*width, y: 0.09102*height), control1: CGPoint(x: 0.90886*width, y: 0.27403*height), control2: CGPoint(x: 0.72584*width, y: 0.09102*height))
      path.addCurve(to: CGPoint(x: 0.09114*width, y: 0.49988*height), control1: CGPoint(x: 0.27416*width, y: 0.09102*height), control2: CGPoint(x: 0.09114*width, y: 0.27416*height))
      path.addCurve(to: CGPoint(x: 0.5*width, y: 0.90873*height), control1: CGPoint(x: 0.09114*width, y: 0.7256*height), control2: CGPoint(x: 0.27416*width, y: 0.90873*height))
      path.addCurve(to: CGPoint(x: 0.90886*width, y: 0.49988*height), control1: CGPoint(x: 0.72584*width, y: 0.90873*height), control2: CGPoint(x: 0.90886*width, y: 0.72572*height))
      path.closeSubpath()
      return path
  }
}

#Preview {
  FestIcon()
}
