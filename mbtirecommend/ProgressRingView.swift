//
//  ProgressRingView.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/16/25.
//

import UIKit

@IBDesignable
class ProgressRingView: UIView {

  private var shapeLayer = CAShapeLayer()
  private var progressLayer = CAShapeLayer()

  @IBInspectable var lineWidth: CGFloat = 8 {
    didSet { configure() }
  }
  @IBInspectable var progressColor: UIColor = .systemIndigo {
    didSet { progressLayer.strokeColor = progressColor.cgColor }
  }
  @IBInspectable var trackColor: UIColor = .systemGray5 {
    didSet { shapeLayer.strokeColor = trackColor.cgColor }
  }
  // 0.0 ~ 1.0
  var progress: CGFloat = 0 {
    didSet {
      progressLayer.strokeEnd = progress
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    configure()
  }

  private func configure() {
    layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = min(bounds.width, bounds.height)/2 - lineWidth/2
    let path = UIBezierPath(
      arcCenter: centerPoint,
      radius: radius,
      startAngle: -.pi/2,
      endAngle: 3 * .pi/2,
      clockwise: true
    )

    // 트랙
    shapeLayer.path          = path.cgPath
    shapeLayer.fillColor     = UIColor.clear.cgColor
    shapeLayer.lineWidth     = lineWidth
    shapeLayer.strokeColor   = trackColor.cgColor
    layer.addSublayer(shapeLayer)

    // 프로그레스
    progressLayer.path        = path.cgPath
    progressLayer.fillColor   = UIColor.clear.cgColor
    progressLayer.lineWidth   = lineWidth
    progressLayer.strokeColor = progressColor.cgColor
    progressLayer.strokeEnd   = progress
    layer.addSublayer(progressLayer)
  }

  /// 애니메이션
  func setProgress(_ p: CGFloat, animated: Bool = true) {
    let clamped = max(0, min(1, p))
    if animated {
      let anim = CABasicAnimation(keyPath: "strokeEnd")
      anim.fromValue = progressLayer.strokeEnd
      anim.toValue   = clamped
      anim.duration  = 0.4
      progressLayer.add(anim, forKey: "progress")
    }
    progressLayer.strokeEnd = clamped
  }
}
