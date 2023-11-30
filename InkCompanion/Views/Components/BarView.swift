import SwiftUI

struct BarView: View {
    let teamDeliverCount:CGFloat
    let goldenPopCount:CGFloat
    let deliverNorm:CGFloat
    
    static let teamDeliverCountColor:Color = Color(hex: "#A66F00")
    static let goldenPopCountColor:Color = Color(hex: "#FFAA00")
    static let deliverNormColor:Color = Color(hex:"#FFD073")
 
    
    var body: some View {
        GeometryReader { geometry in
//            var maxWidth:CGFloat = max(teamDeliverCount, goldenPopCount,deliverNorm)
            ZStack(alignment: .leading) {
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(BarView.goldenPopCountColor.gradient)
                        .frame(width: goldenPopCount / 120 * geometry.size.width, height: 12) // 假设最大值为200
                        .cornerRadius(2)

                            
                }
                if teamDeliverCount != 0{
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(BarView.teamDeliverCountColor.gradient)
                            .frame(width: teamDeliverCount / 120 * geometry.size.width, height: 4) // 假设最大值为200
                            .cornerRadius(2)
                    }
                }
                
                if deliverNorm != 0{
                    // 标准交付线
                    Rectangle()
                        .fill(Color.red) // 横线颜色
                        .frame(width: 2, height: 15) // 横线的宽度和高度
                        .offset(x: deliverNorm / 120 * geometry.size.width, y: 0) // 根据 deliverNorm 调整偏移量
                }
            }
        }
    }
}

struct StackedBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(teamDeliverCount: 50, goldenPopCount: 80, deliverNorm: 32)
            .frame(width: 200)
    }
}
