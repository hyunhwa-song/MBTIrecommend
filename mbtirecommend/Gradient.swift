//
//  ViewController.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/16/25.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  @IBInspectable var topColor: UIColor = .systemPurple
  @IBInspectable var bottomColor: UIColor = .systemBlue

  override func layoutSubviews() {
    super.layoutSubviews()
    let grad = CAGradientLayer()
    grad.frame = bounds
    grad.colors = [topColor.cgColor, bottomColor.cgColor]
    grad.startPoint = CGPoint(x: 0.5, y: 0)
    grad.endPoint   = CGPoint(x: 0.5, y: 1)
    layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
    layer.insertSublayer(grad, at: 0)
  }
}


