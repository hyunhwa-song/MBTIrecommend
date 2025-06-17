//
//  Waveview.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/16/25.
//

import UIKit

@IBDesignable
class WaveView: UIView {
  @IBInspectable var fillColor: UIColor = .white {
    didSet { setNeedsDisplay() }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = .clear      // 투명해야 아래 그라데이션이 보입니다
    setNeedsDisplay()             // 크기 바뀔 때마다 draw(_:) 다시 호출
  }

  override func draw(_ rect: CGRect) {
    guard rect.height > 40 else { return }  // 안전 장치
    let path = UIBezierPath()
    let w = rect.width
    let h = rect.height

    path.move(to: .zero)
    path.addLine(to: CGPoint(x: 0, y: h - 40))
    path.addCurve(
      to: CGPoint(x: w, y: h - 40),
      controlPoint1: CGPoint(x: w*0.25, y: h + 20),
      controlPoint2: CGPoint(x: w*0.75, y: h - 100)
    )
    path.addLine(to: CGPoint(x: w, y: 0))
    path.close()

    fillColor.setFill()
    path.fill()
  }
}

