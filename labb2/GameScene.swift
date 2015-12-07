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
       
        for i in 1...9 {
            blueTiles[i] = SKSpriteNode(imageNamed: "blueTile")
            redTiles[i] = SKSpriteNode(imageNamed: "redTile")
            blueTiles[i]!.position = CGPoint(x: size.width * (CGFloat( abs( Double( i ) * 0.1 - 1)) ), y: size.height * 0.1)
            redTiles[i]!.position = CGPoint(x: size.width * CGFloat(Double( i ) * 0.1  ), y: size.height * 0.9)
            addChild(blueTiles[i]!)
            addChild(redTiles[i]!)
        }
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, size.width, size.height)
        
        
        let shapeNode = SKShapeNode()
        shapeNode.path = path
        shapeNode.name = "line"
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
