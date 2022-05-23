//
//  SwitchButton.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 19/01/2022.
//

import UIKit

class SwitchButton: UIView {
  let arrowLayer = CAShapeLayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    setup()
//  }
  
  func setup(){
    let path = UIBezierPath(ovalIn: CGRect(origin: center, size: CGSize(width: bounds.width/2, height: bounds.width/2)))
    self.layer.addSublayer(arrowLayer)
    
//    let center = self.center
//    path.move(to: center)
//    path.addLine(to: CGPoint(x: center.x, y: 10))
//    path.addLine(to: CGPoint(x: center.x + 25, y: 158))
//    path.move(to: CGPoint(x: center.x, y: 130))
//    path.addLine(to: CGPoint(x: center.x - 25, y: 158))
//
//    path.move(to: CGPoint(x: center.x + 30, y: center.y))
//    path.addLine(to: CGPoint(x: center.x + 30, y: 130))
//    path.move(to: CGPoint(x: center.x + 30, y: center.y))
//    path.addLine(to: CGPoint(x: center.x + 10, y: center.y - 30))
//    path.move(to: CGPoint(x: center.x + 30, y: center.y))
//    path.addLine(to: CGPoint(x: center.x + 50, y: center.y - 30))
    
    arrowLayer.position = .zero
    arrowLayer.path = path.cgPath
    arrowLayer.strokeColor = UIColor.black.cgColor
    arrowLayer.lineWidth = 3.0
    
  }

}
