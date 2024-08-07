//
//  RectangleView.swift
//  Transcript
//MIT License
//
//Copyright (c) 2024 Omar Elsayed
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE. on 13/07/2024.
//
//

import UIKit

class RectangleView: UIView {

  override func layoutSubviews() {
    let shapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
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
