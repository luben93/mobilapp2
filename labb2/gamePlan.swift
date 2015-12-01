//
//  gamePlan.swift
//  labb2
//
//  Created by lucas persson on 2015-12-01.
//  Copyright © 2015 lucas persson. All rights reserved.
//

import UIKit

@IBDesignable
class gamePlan: UIView {
    var planCenter: CGPoint{
        return convertPoint(center, fromCoordinateSpace: superview!)//extra
    }
    
    @IBInspectable var lineWidth:CGFloat = 3 {didSet { setNeedsDisplay()} }
    @IBInspectable var color: UIColor = UIColor.blueColor(){didSet { setNeedsDisplay()} }

    
    override func drawRect(rect: CGRect) {
        
        let outer = UIBezierPath(rect: CGRect(x: bounds.midX * 0.1, y: bounds.midY * 0.1, width: bounds.maxX * 0.9, height: bounds.maxY * 0.9))
        let middle = UIBezierPath(rect: CGRect(x: bounds.midX * 0.4, y: bounds.midY * 0.4, width: bounds.maxX * 0.6, height: bounds.maxY * 0.6))
        let inner = UIBezierPath(rect: CGRect(x: bounds.midX * 0.8, y: bounds.midY * 0.8, width: bounds.maxX * 0.2, height: bounds.maxY * 0.2))
        let up = UIBezierPath()
        let down = UIBezierPath()
        let left = UIBezierPath()
        let rigth = UIBezierPath()
        
        up.moveToPoint(CGPoint(x: bounds.midX, y: bounds.minY + bounds.midY * 0.1))
        up.addLineToPoint(CGPoint(x: bounds.midX, y: bounds.midY - bounds.midY * 0.2 ))
        
        down.moveToPoint(CGPoint(x: bounds.midX, y: bounds.maxY - bounds.midY * 0.1))
        down.addLineToPoint(CGPoint(x: bounds.midX, y: bounds.midY + bounds.midY * 0.2))
        
        rigth.moveToPoint(CGPoint(x: bounds.maxX - bounds.maxX * 0.05, y: bounds.midY))
        rigth.addLineToPoint(CGPoint(x: bounds.midX + bounds.midX * 0.2 , y: bounds.midY))

        left.moveToPoint(CGPoint(x: bounds.minX + bounds.midX * 0.1, y: bounds.midY))
        left.addLineToPoint(CGPoint(x: bounds.midX - bounds.midX * 0.2, y: bounds.midY))
        
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
