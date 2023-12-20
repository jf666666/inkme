import UIKit

// 自定义的波浪视图
class WaveView: UIView {
    var waveColor: UIColor = .blue // 波浪的颜色
    var frequency: CGFloat = 1.5 // 波动频率
    var amplitude: CGFloat = 20.0 // 振幅
    var waveSpeed: CGFloat = 0.1 // 波动速度
    private var phase: CGFloat = 0 // 相位
    private var displayLink: CADisplayLink?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
      guard UIGraphicsGetCurrentContext() != nil else { return }

        let midY = rect.height / 2
        let path = UIBezierPath()

        // 绘制波浪形状
        path.move(to: CGPoint(x: 0, y: midY))
        for x in 0..<Int(rect.width) {
            let relativeX = CGFloat(x) / rect.width
            let y = amplitude * sin(2 * .pi * frequency * relativeX + phase) + midY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }

        // 完成绘制路径
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()

        // 设置波浪颜色并填充
        waveColor.setFill()
        path.fill()

        // 可以在这里添加代码，根据需求修改波浪的颜色
    }

    func startAnimating() {
        stopAnimating()
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .current, forMode: .common)
    }

    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updateWave() {
        phase += waveSpeed
        self.setNeedsDisplay()
    }
}

// 在你的ViewController中使用WaveView
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let waveView = WaveView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
        view.addSubview(waveView)
        waveView.startAnimating()
    }
}

import SwiftUI

struct WaveViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return WaveView(frame: .zero)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct WaveViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        WaveViewPreview()
            .frame(height: 100)
            .previewLayout(.sizeThatFits)
    }
}
