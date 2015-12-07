//
//  GameScene.swift
//  labb2sprite
//
//  Created by lucas persson on 2015-12-01.
//  Copyright (c) 2015 lucas persson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
   
    
    var blueTiles=[Int : SKSpriteNode]()
    //let blueTiles = [SKSpriteNode](count: 9, repeatedValue:  SKSpriteNode(imageNamed: "blueTile"))
    var redTiles=[Int : SKSpriteNode]()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.clearColor()
        alotOfStuff()
    }
    
    func alotOfStuff(){
        for i in 1...9 {
            blueTiles[i] = SKSpriteNode(imageNamed: "blueTile")
            redTiles[i] = SKSpriteNode(imageNamed: "redTile")
            blueTiles[i]!.position = CGPoint(x: size.width * (CGFloat( abs( Double( i ) * 0.1 - 1)) ), y: size.height * 0.1)
            redTiles[i]!.position = CGPoint(x: size.width * CGFloat(Double( i ) * 0.1  ), y: size.height * 0.9)
            addChild(blueTiles[i]!)
            addChild(redTiles[i]!)
        }
        
        let tre = CGPoint(x:size.width * 0.01,y:size.height/2 + size.width/2 * 0.9)
        let tva = CGPoint(x:size.width * 0.2,y:size.height/2 + size.width/2 * 0.5)
        let ett = CGPoint(x:size.width * 0.4,y:size.height/2 + size.width/2 * 0.2)
        
        let nio = CGPoint(x:size.width * 0.99,y:size.height/2 + size.width/2 * 0.9)
        let atta = CGPoint(x:size.width * 0.8,y:size.height/2 + size.width/2 * 0.5)
        let sju = CGPoint(x:size.width * 0.6,y:size.height/2 + size.width/2 * 0.2)
        
        let femton = CGPoint(x:size.width * 0.99, y:size.height/2 - size.width/2 * 0.9)
        let fjorton = CGPoint(x:size.width * 0.8, y:size.height/2 - size.width/2 * 0.5)
        let tretton = CGPoint(x:size.width * 0.6, y:size.height/2 - size.width/2 * 0.2)
        
        let tjugoett = CGPoint(x:size.width * 0.01,y:size.height/2 - size.width/2 * 0.9)
        let tjugo = CGPoint(x:size.width * 0.2,y:size.height/2 - size.width/2 * 0.5)
        let nitton = CGPoint(x:size.width * 0.4,y:size.height/2 - size.width/2 * 0.2)
        
        
        
        let outer = CGPathCreateMutable()
        
        CGPathMoveToPoint(outer, nil, tre.x, tre.y)
        CGPathAddLineToPoint(outer, nil, nio.x,nio.y)
        CGPathAddLineToPoint(outer, nil, femton.x,femton.y)
        CGPathAddLineToPoint(outer, nil, tjugoett.x,tjugoett.y)
        drawRect(outer)
        
        let middle = CGPathCreateMutable()
        
        CGPathMoveToPoint(middle, nil, tva.x, tva.y)
        CGPathAddLineToPoint(middle, nil, atta.x,atta.y)
        CGPathAddLineToPoint(middle, nil, fjorton.x,fjorton.y)
        CGPathAddLineToPoint(middle, nil, tjugo.x,tjugo.y)
        drawRect(middle)
        
        let inner = CGPathCreateMutable()
        
        CGPathMoveToPoint(inner, nil, ett.x, ett.y)
        CGPathAddLineToPoint(inner, nil, sju.x,sju.y)
        CGPathAddLineToPoint(inner, nil, tretton.x,tretton.y)
        CGPathAddLineToPoint(inner, nil, nitton.x,nitton.y)
        drawRect(inner)


    }
    
    func drawRect(rect:CGMutablePathRef){
       
        CGPathCloseSubpath(rect)

        
        let shapeNode = SKShapeNode()
        shapeNode.path = rect
//        shapeNode.name = rect
        shapeNode.strokeColor = UIColor.grayColor()
        shapeNode.lineWidth = 2
        shapeNode.zPosition = 1
        self.addChild(shapeNode)
    }
    
    func moveRedTo(point:CGPoint) {
        redTiles[1]?.position = point
        addChild(redTiles[1]!)
    }
    

}
