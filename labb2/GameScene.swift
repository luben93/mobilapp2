//
//  GameScene.swift
//  labb2sprite
//
//  Created by lucas persson on 2015-12-01.
//  Copyright (c) 2015 lucas persson. All rights reserved.
//
/*
* The game board positions
*
* 03           06           09
*     02       05       08
*         01   04   07
* 24  23  22   00   10  11  12
*         19   16   13
*     20       17       14
* 21           18           15
*
*/

import SpriteKit

class GameScene: SKScene {
    
    
    
    
    var blueTiles = [SKSpriteNode?](count: 10, repeatedValue: nil)
    var redTiles = [SKSpriteNode?](count: 10, repeatedValue: nil)
    var places = [CGPoint](count: 25, repeatedValue: CGPoint())
    var tileSelected:Int?
    var blueCan = SKSpriteNode()
    var redCan = SKSpriteNode()
    let label = SKLabelNode()
    let rule = rules()
    var currentTiles:[SKSpriteNode?]{
        get{
            if rule.isBluesTurn {
                return redTiles
            }else{
                return blueTiles
            }
        }
    }
    var currentCan:SKSpriteNode{
        get{
            if rule.isBluesTurn {
                return blueCan
            }else{
                return redCan
            }
        }
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.clearColor()
        alotOfStuff()
        
        
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        print("touch blue \(rule.isBluesTurn )")
        if let tileN = tileSelected{
            
            let diff = sqrt(pow(touchLocation.x-currentCan.position.x,2)+pow(touchLocation.y-currentCan.position.y,2))
            if 30 <= diff {
                
                if rule.legalMove(closestPlaces(touchLocation), from: tileN){
                    if let tile =  currentTiles[tileN]{
                        tile.removeFromParent()
                        tile.position = places[closestPlaces(touchLocation)]
                        addChild(tile)
                    }
                    tileSelected = nil
                    rule.isBluesTurn = !rule.isBluesTurn
                    
                    label.text = "select tile"
                    if rule.isBluesTurn {
                        label.fontColor = SKColor.redColor()
                        label.zRotation = CGFloat(M_PI)
                        
                    }else{
                        label.fontColor = SKColor.blueColor()
                        label.zRotation = CGFloat(0)
                    }
                }
            }else{
                //trashCan
                print("trashcan\(touchLocation)")
                if let cTile = currentTiles[tileN] {
                    cTile.position = CGPoint(x:-100,y:-100)
                    cTile.removeFromParent()
                    if rule.isBluesTurn {
                         blueTiles[tileN]=nil
                    }else{
                         redTiles[tileN]=nil
                    }
                   
                }
                

                
            }
            
            
        }else{
            tileSelected = closestTile(touchLocation, cmp:currentTiles)
            //print("tileSelected \(tileSelected) rule tile \(rule.board(9))")
            label.text = "place tile"
            
        }
        //            print("red \(sqrt(pow(touchLocation.x-redCan.position.x,2)+pow(touchLocation.y-redCan!.position.y,2))) blue \(sqrt(pow(touchLocation.x-blueCan!.position.x,2)+pow(touchLocation.y-blueCan!.position.y,2)))")
        
    }
    
//    
//    func moveFromPile(touchLocation:CGPoint,tileN:Int){
////        let closestIndex = closestPlaces(touchLocation)
//       //        let current = currentTiles[tile]
//        if let tile =  currentTiles[tileN]{
//           tile.removeFromParent()
//            tile.position = places[closestPlaces(touchLocation)]
//            addChild(tile)
//        }
//        
//    }
    
    func closestPlaces(touch:CGPoint) -> Int{
        
        var diff = CGFloat(10000)
        var out = -1
        for i in 1...24{
            let tmp = sqrt(pow(touch.x-places[i].x,2)+pow(touch.y-places[i].y,2))
            if tmp <= diff {
                diff = tmp
                out = i
            }
        }
        
        return out
    }
    
    func closestTile(touch:CGPoint,cmp:[SKSpriteNode?]) -> Int{
        
        var diff = CGFloat(10000)
        var out = -1
        for i in 0...cmp.count-1{
            if let cTile = cmp[i]?.position {
            let tmp = sqrt(pow(touch.x-cTile.x,2)+pow(touch.y-cTile.y,2))
            if tmp <= diff {
                diff = tmp
                out = i
                }
            }
        }
        
        return out
    }
    
    
    func alotOfStuff(){
        blueCan=SKSpriteNode(imageNamed: "blueCan")
        blueCan.position=CGPoint(x:size.width*0.9,y:size.height*0.05)
        addChild(blueCan)
        
        redCan=SKSpriteNode(imageNamed: "redCan")
        redCan.position=CGPoint(x:size.width*0.1,y:size.height*0.95)
        addChild(redCan)
        
        
        
        for i in 1...9 {
            blueTiles[i] = SKSpriteNode(imageNamed: "blueTile")
            redTiles[i] = SKSpriteNode(imageNamed: "redTile")
            blueTiles[i]!.position = CGPoint(x: size.width * (CGFloat( abs( Double( i ) * 0.1 - 1)) ), y: size.height * 0.15)
            redTiles[i]!.position = CGPoint(x: size.width * CGFloat(Double( i ) * 0.1  ), y: size.height * 0.85)
            addChild(blueTiles[i]!)
            addChild(redTiles[i]!)
        }
        
        places[0] = CGPoint(x:size.width/2,y:size.height/2)
        
        places[3] = CGPoint(x:size.width * 0.02,y:size.height/2 + size.width/2 * 0.9)
        places[2] = CGPoint(x:size.width * 0.2,y:size.height/2 + size.width/2 * 0.6)
        places[1] = CGPoint(x:size.width * 0.35,y:size.height/2 + size.width/2 * 0.25)
        
        places[6] = CGPoint(x:size.width * 0.5,y:size.height/2 + size.width/2 * 0.9)
        places[5] = CGPoint(x:size.width * 0.5,y:size.height/2 + size.width/2 * 0.6)
        places[4] = CGPoint(x:size.width * 0.5,y:size.height/2 + size.width/2 * 0.25)
        
        places[9] = CGPoint(x:size.width * 0.98,y:size.height/2 + size.width/2 * 0.9)
        places[8] = CGPoint(x:size.width * 0.8,y:size.height/2 + size.width/2 * 0.6)
        places[7] = CGPoint(x:size.width * 0.65,y:size.height/2 + size.width/2 * 0.25)
        
        places[12] = CGPoint(x:size.width * 0.98,y:size.height * 0.5 )
        places[11] = CGPoint(x:size.width * 0.8,y:size.height * 0.5 )
        places[10] = CGPoint(x:size.width * 0.65,y:size.height * 0.5 )
        
        places[15] = CGPoint(x:size.width * 0.98, y:size.height/2 - size.width/2 * 0.9)
        places[14] = CGPoint(x:size.width * 0.8, y:size.height/2 - size.width/2 * 0.6)
        places[13] = CGPoint(x:size.width * 0.65, y:size.height/2 - size.width/2 * 0.25)
        
        places[18] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.9)
        places[17] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.6)
        places[16] = CGPoint(x:size.width * 0.5, y:size.height/2 - size.width/2 * 0.25)
        
        places[21] = CGPoint(x:size.width * 0.02,y:size.height/2 - size.width/2 * 0.9)
        places[20] = CGPoint(x:size.width * 0.2,y:size.height/2 - size.width/2 * 0.6)
        places[19] = CGPoint(x:size.width * 0.35,y:size.height/2 - size.width/2 * 0.25)
        
        places[24] = CGPoint(x:size.width * 0.02,y:size.height/2 )
        places[23] = CGPoint(x:size.width * 0.2,y:size.height/2)
        places[22] = CGPoint(x:size.width * 0.35,y:size.height/2 )
        
        
        
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
        
        
        //let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Your turn"
        label.fontSize = 15
        label.fontColor = SKColor.blueColor()
        label.position = places[0]
        label.setScale(1)
        addChild(label)
        
        
        
        
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
    
    
    //    func moveRedTo(point:CGPoint) {
    //        redTiles[1]?.position = point
    //        addChild(redTiles[1]!)
    //    }

    
}
