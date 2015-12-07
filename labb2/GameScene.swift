//
//  GameScene.swift
//  labb2sprite
//
//  Created by lucas persson on 2015-12-01.
//  Copyright (c) 2015 lucas persson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
   
    
    var blueTiles = [Int : SKSpriteNode]()
    //let blueTiles = [SKSpriteNode](count: 9, repeatedValue:  SKSpriteNode(imageNamed: "blueTile"))
    var redTiles = [Int : SKSpriteNode]()
    var places = [CGPoint](count: 25, repeatedValue: CGPoint())
    var redIndex = 1
    var blueIndex = 1

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.clearColor()
        alotOfStuff()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //TODO here
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        print("touch\(touchLocation)")
        redTiles[redIndex]!.removeFromParent()
        redTiles[redIndex]!.position = touchLocation
        addChild(redTiles[redIndex]!)
        
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
        
        places[3] = CGPoint(x:size.width * 0.01,y:size.height/2 + size.width/2 * 0.9)
        places[2] = CGPoint(x:size.width * 0.2,y:size.height/2 + size.width/2 * 0.5)
        places[1] = CGPoint(x:size.width * 0.4,y:size.height/2 + size.width/2 * 0.2)
        
        places[6] = CGPoint(x:size.width * 0.5 ,y:size.height/2 + size.width/2 * 0.9)
        places[5] = CGPoint(x:size.width * 0.5,y:size.height/2 + size.width/2 * 0.5)
        places[4] = CGPoint(x:size.width * 0.5,y:size.height/2 + size.width/2 * 0.2)
        
        places[9] = CGPoint(x:size.width * 0.99,y:size.height/2 + size.width/2 * 0.9)
        places[8] = CGPoint(x:size.width * 0.8,y:size.height/2 + size.width/2 * 0.5)
        places[7] = CGPoint(x:size.width * 0.6,y:size.height/2 + size.width/2 * 0.2)
        
        places[12] = CGPoint(x:size.width * 0.99,y:size.height/2 )
        places[11] = CGPoint(x:size.width * 0.8,y:size.height/2 )
        places[10] = CGPoint(x:size.width * 0.6,y:size.height/2 )
        
        places[15] = CGPoint(x:size.width * 0.99, y:size.height/2 - size.width/2 * 0.9)
        places[14] = CGPoint(x:size.width * 0.8, y:size.height/2 - size.width/2 * 0.5)
        places[13] = CGPoint(x:size.width * 0.6, y:size.height/2 - size.width/2 * 0.2)
        
        places[18] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.9)
        places[19] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.5)
        places[16] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.2)
        
        places[21] = CGPoint(x:size.width * 0.01,y:size.height/2 - size.width/2 * 0.9)
        places[20] = CGPoint(x:size.width * 0.2,y:size.height/2 - size.width/2 * 0.5)
        places[19] = CGPoint(x:size.width * 0.4,y:size.height/2 - size.width/2 * 0.2)
        
        places[24] = CGPoint(x:size.width * 0.01,y:size.height/2 )
        places[23] = CGPoint(x:size.width * 0.2,y:size.height/2)
        places[22] = CGPoint(x:size.width * 0.4,y:size.height/2 )
        
        
        
        let outer = CGPathCreateMutable()
        
        CGPathMoveToPoint(outer, nil, places[3].x, places[3].y)
        CGPathAddLineToPoint(outer, nil, places[9].x,places[9].y)
        CGPathAddLineToPoint(outer, nil, places[15].x,places[15].y)
        CGPathAddLineToPoint(outer, nil, places[21].x,places[21].y)
        drawRect(outer)
        
        let middle = CGPathCreateMutable()
        CGPathMoveToPoint(middle, nil, places[2].x, places[2].y)
        CGPathAddLineToPoint(middle, nil, places[8].x,places[8].y)
        CGPathAddLineToPoint(middle, nil, places[14].x,places[14].y)
        CGPathAddLineToPoint(middle, nil, places[20].x,places[20].y)
        drawRect(middle)
        
        let inner = CGPathCreateMutable()
        CGPathMoveToPoint(inner, nil, places[1].x, places[1].y)
        CGPathAddLineToPoint(inner, nil, places[7].x,places[7].y)
        CGPathAddLineToPoint(inner, nil, places[13].x,places[13].y)
        CGPathAddLineToPoint(inner, nil, places[19].x,places[19].y)
        drawRect(inner)
        
        let up = CGPathCreateMutable()
        CGPathMoveToPoint(up,nil,places[6].x,places[6].y)
        CGPathAddLineToPoint(up, nil, places[4].x,places[4].y)
        drawRect(up)
        
        let down = CGPathCreateMutable()
        CGPathMoveToPoint(down,nil,places[16].x,places[16].y)
        CGPathAddLineToPoint(down, nil, places[18].x,places[18].y)
        drawRect(down)
        
        let rigth = CGPathCreateMutable()
        CGPathMoveToPoint(rigth,nil,places[12].x,places[12].y)
        CGPathAddLineToPoint(rigth, nil, places[10].x,places[10].y)
        drawRect(rigth)
        
        let left = CGPathCreateMutable()
        CGPathMoveToPoint(left,nil,places[24].x,places[24].y)
        CGPathAddLineToPoint(left, nil, places[22].x,places[22].y)
        drawRect(left)
        

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
