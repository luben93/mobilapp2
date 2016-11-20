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
    
    
    
    
    var blueTiles = [SKSpriteNode?](repeating: nil, count: 10)
    var redTiles = [SKSpriteNode?](repeating: nil, count: 10)
    var places = [CGPoint](repeating: CGPoint(), count: 25)
    //var tileSelected:Int?
    var blueCan = SKSpriteNode()
    var redCan = SKSpriteNode()
    let label = SKLabelNode()
    let rule = rules()
    var currentTiles:[SKSpriteNode?]{
        get{
            switch rule.currentPlayerTile { //flipped bool
            case .Blue: return blueTiles
            case .Red: return redTiles
            case .Empty: print("currentTitle error"); return redTiles; //ajabaja
            }
        }
    }
    /*var currentCan:SKSpriteNode{
     get{
     if rule.isBluesTurn {
     return blueCan
     }else{
     return redCan
     }
     }
     }*/
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.clear
        alotOfStuff()
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        
        rule.tile = closestTile(touchLocation, cmp:currentTiles)!
        
        switch rule.mode{
        case .place: label.text = "place tile"
        //draw new tile here
        
        if let tileN = rule.selectedTile{
            print("iflet selected")
            if let tile = currentTiles[tileN] {
                print("iflet work on place")//did not work
                tile.removeFromParent()
                tile.position = places[rule.tile!]
                addChild(tile)
            }
        }
            
        case .select: label.text = "select tile" // maybe draw tile in a on hand place
        case .remove: label.text = "remove tile"
        //remove tile here
        if let tileN = rule.selectedTile{
            if let tile = currentTiles[tileN] {
                
                tile.removeFromParent()
            }}
        }
        /*
         print("touch blue \(rule.isBluesTurn )")
         switch mode{
         case .place:
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
         // remove tile if aplicible
         if rules.hasMill(){
         
         label.text = "remove opponents tile"
         // remove title mode TODO
         mode = .remove
         }else{
         mode = .select
         }
         
         
         //rule.isBluesTurn = !rule.isBluesTurn // already doning this
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
         }
         case .select:
         tileSelected = closestTile(touchLocation, cmp:currentTiles)
         print("tileSelected \(tileSelected) ")
         mode = .place
         //label.text = "place tile"
         case .remove:
         if rule.isBluesTurn {
         tile = closestTile(touchLocation, cmp:blueTiles)
         }else{
         tile = closestTile(touchLocation, cmp:blueTiles)
         }
         rule.re
         
         }
         //            print("red \(sqrt(pow(touchLocation.x-redCan.position.x,2)+pow(touchLocation.y-redCan!.position.y,2))) blue \(sqrt(pow(touchLocation.x-blueCan!.position.x,2)+pow(touchLocation.y-blueCan!.position.y,2)))")
         */
        setTurnText()
        
    }
    
    private func setTurnText(){
        /*if tileSelected == nil {
         label.text = "select tile"
         }else{
         label.text = "place tile"
         }*/
        
        switch rule.currentPlayerTile { //was a flipped bool, now normal
        case .Blue:
            label.fontColor = SKColor.blue
            label.zRotation = CGFloat(0)
        case .Red:
            label.fontColor = SKColor.red
            label.zRotation = CGFloat(M_PI)
        case .Empty: print("labelsetter error error"); break;
            
        }
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
    
    
    //TODO  merge closest place and closet tile to one function and verify that it finds the correct CGPoint, and move 10000 to a minimal distance that matters
    func closestPlaces(_ touch:CGPoint) -> Int{
        
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
    
    
    func closestTile(_ touch:CGPoint,cmp:[SKSpriteNode?]) -> Int?{
        
        var diff = CGFloat(10000)
        var out:Int?
        for (i,node) in cmp.enumerated() {
            if let tile = node?.position{
                let tmp = hypot(touch.x-tile.x, touch.y-tile.y)
                if tmp <= diff {
                    diff = tmp
                    out = i
                }
            }
        }
        
        /*for i in 0...cmp.count-1{
         if let cTile = cmp[i]?.position {
         let tmp = sqrt(pow(touch.x-cTile.x,2)+pow(touch.y-cTile.y,2))
         if tmp <= diff {
         diff = tmp
         out = i
         }
         }
         }*/
        
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
        
        
        
        let outer = CGMutablePath()
        outer.move(to: places[3])
        outer.addLine(to: places[9])
        outer.addLine(to: places[15])
        outer.addLine(to: places[21])
        drawRect(outer)
        
        let middle = CGMutablePath()
        middle.move(to: places[2])
        middle.addLine(to: places[8])
        middle.addLine(to: places[14])
        middle.addLine(to: places[20])
        drawRect(middle)
        
        let inner = CGMutablePath()
        inner.move(to: places[1])
        inner.addLine(to: places[7])
        inner.addLine(to: places[13])
        inner.addLine(to: places[19])
        drawRect(inner)
        
        let up = CGMutablePath()
        up.move(to: places[6])
        up.addLine(to: places[4])
        drawRect(up)
        
        let down = CGMutablePath()
        down.move(to: places[16])
        down.addLine(to: places[18])
        drawRect(down)
        
        let rigth = CGMutablePath()
        rigth.move(to: places[12])
        rigth.addLine(to: places[10])
        drawRect(rigth)
        
        let left = CGMutablePath()
        left.move(to:places[24])
        left.addLine(to: places[22])
        drawRect(left)
        
        
        //let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "start"
        label.fontSize = 17
        label.fontColor = SKColor.red
        label.position = places[0]
        label.setScale(1)
        addChild(label)
        setTurnText()
        
    }
    
    func drawRect(_ rect:CGMutablePath){
        
        rect.closeSubpath()
        
        
        let shapeNode = SKShapeNode()
        shapeNode.path = rect
        //        shapeNode.name = rect
        shapeNode.strokeColor = UIColor.gray
        shapeNode.lineWidth = 2
        shapeNode.zPosition = 1
        self.addChild(shapeNode)
    }
    
    
    //    func moveRedTo(point:CGPoint) {
    //        redTiles[1]?.position = point
    //        addChild(redTiles[1]!)
    //    }
    
    
}
