//
//  SwitchView.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 21/01/2022.
//

import UIKit

@IBDesignable
class SwitchView: UIView {
 let arrowLayer = CAShapeLayer()
  var rect: CGRect?
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    guard let rect = self.rect else {return}
    setup(rect: rect)
  }
  
  override func draw(_ rect: CGRect) {
    setup(rect: rect)
  }
  
  private func setup(rect: CGRect){
    let rect = rect.inset(by: UIEdgeInsets(top: 2,
                                           left: 2,
                                           bottom: 2,
                                           right: 2))
    let circlePath = UIBezierPath(ovalIn: rect)
    UIColor.yellow.setFill()
    UIColor.white.setStroke()
    circlePath.lineWidth = 4.0
    circlePath.stroke()
    circlePath.fill()
   
    
    let path = UIBezierPath()
    
    let sideWing = rect.width / 10
    let side = rect.width / 6
    let center = CGPoint(x: rect.midX - (side/2), y: rect.midY)
    let arrowHeight = rect.height * 0.8
    let halfArrowHeightUp = (center.y - arrowHeight/2)
    let halfArrowHeightDown = (center.y + arrowHeight/2)
    

    path.move(to: center)
    path.addLine(to: CGPoint(x: center.x, y: halfArrowHeightUp))
    path.move(to: center)
    path.addLine(to: CGPoint(x: center.x, y: halfArrowHeightDown))
    path.addLine(to: CGPoint(x: center.x + sideWing,
                             y: halfArrowHeightDown - sideWing))
    path.move(to: CGPoint(x: center.x, y: halfArrowHeightDown))
    path.addLine(to: CGPoint(x: center.x - sideWing,
                             y: halfArrowHeightDown - sideWing))

    path.move(to: CGPoint(x: rect.midX + side, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.midX + side, y: halfArrowHeightUp))
    path.move(to: CGPoint(x: rect.midX + side, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.midX + side, y: halfArrowHeightDown))
    path.move(to: CGPoint(x: rect.midX + side, y: halfArrowHeightUp))
    path.addLine(to: CGPoint(x: rect.midX + side + sideWing,
                             y: halfArrowHeightUp + sideWing))
    path.move(to: CGPoint(x: rect.midX + side, y: halfArrowHeightUp))
    path.addLine(to: CGPoint(x: rect.midX + side - sideWing,
                             y: halfArrowHeightUp + sideWing))
    
    UIColor.black.setStroke()
    path.lineWidth = 2.0
    path.stroke()
   
  }

}
