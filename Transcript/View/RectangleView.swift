//
//  RectangleView.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 05/07/2024.
//

import UIKit

@IBDesignable
class RectangleView: UIView {

  override func layoutSubviews() {
    let shapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let framePoint = self.frame.origin
    let rect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    
    shapeLayer.frame = rect
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.systemGray.cgColor
    shapeLayer.lineWidth = 3
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round // To make rounded edges
    shapeLayer.lineDashPattern = [8, 8]
    shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
    
    self.layer.addSublayer(shapeLayer)
  }
}
