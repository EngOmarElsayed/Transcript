//
//  addBottomLine.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 15/07/2024.
//

import UIKit

extension UIView {
  func addBottomLine(with color: UIColor, and width: CGFloat) {
    let line = CAShapeLayer()
    line.backgroundColor = color.cgColor
    line.frame = CGRect(x: 0, y: CGFloat(self.frame.size.height - width), width: self.frame.size.width, height: width+1)
    
    self.layer.addSublayer(line)
  }
}
