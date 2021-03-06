//
//  gamePlan.swift
//  labb2
//
//  Created by lucas persson on 2015-12-01.
//  Copyright © 2015 lucas persson. All rights reserved.
//
//
//  03           06           09
//      02       05       08
//          01   04   07
//  24  23  22        10  11  12
//          19   16   13
//      20       17       14
//  21           18           15
//
import UIKit

@IBDesignable
class gamePlan: UIView {
    var planCenter: CGPoint{
        return convert(center, from: superview!)//extra
    }
    
    @IBInspectable var lineWidth:CGFloat = 3 {didSet { setNeedsDisplay()} }
    @IBInspectable var color: UIColor = UIColor.green{didSet { setNeedsDisplay()} }

    
    override func draw(_ rect: CGRect) {
        
        let outer = UIBezierPath(rect: CGRect(x: bounds.midX * 0.1, y: bounds.midY * 0.1, width: bounds.maxX * 0.9, height: bounds.maxY * 0.9))
        let middle = UIBezierPath(rect: CGRect(x: bounds.midX * 0.4, y: bounds.midY * 0.4, width: bounds.maxX * 0.6, height: bounds.maxY * 0.6))
        let inner = UIBezierPath(rect: CGRect(x: bounds.midX * 0.8, y: bounds.midY * 0.8, width: bounds.maxX * 0.2, height: bounds.maxY * 0.2))
        let up = UIBezierPath()
        let down = UIBezierPath()
        let left = UIBezierPath()
        let rigth = UIBezierPath()
        
        up.move(to: CGPoint(x: bounds.midX, y: bounds.minY + bounds.midY * 0.1))
        up.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - bounds.midY * 0.2 ))
        
        down.move(to: CGPoint(x: bounds.midX, y: bounds.maxY - bounds.midY * 0.1))
        down.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + bounds.midY * 0.2))
        
        rigth.move(to: CGPoint(x: bounds.maxX - bounds.maxX * 0.05, y: bounds.midY))
        rigth.addLine(to: CGPoint(x: bounds.midX + bounds.midX * 0.2 , y: bounds.midY))

        left.move(to: CGPoint(x: bounds.minX + bounds.midX * 0.1, y: bounds.midY))
        left.addLine(to: CGPoint(x: bounds.midX - bounds.midX * 0.2, y: bounds.midY))
        
        color.set()
        
        left.lineWidth = lineWidth
        left.stroke()
        
        rigth.lineWidth = lineWidth
        rigth.stroke()
        
        up.lineWidth = lineWidth
        up.stroke()
        
        down.lineWidth = lineWidth
        down.stroke()

        inner.lineWidth = lineWidth
        inner.stroke()
        
        middle.lineWidth = lineWidth
        middle.stroke()
        
        outer.lineWidth = lineWidth
        outer.stroke()
        
}

}
