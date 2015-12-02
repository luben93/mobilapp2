//
//  GameScene.swift
//  labb2sprite
//
//  Created by lucas persson on 2015-12-01.
//  Copyright (c) 2015 lucas persson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
//        backgroundColor = SKColor.whiteColor()
        backgroundColor = SKColor.clearColor()
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
            ])
        ))
    }
    
    func random()->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min:CGFloat,max:CGFloat)->CGFloat{
        return random() * (max - min) + min
    }
    
    func addMonster(){
        
        let monster = SKSpriteNode(imageNamed: "monster")
        
        let actualY = random(min:monster.size.height/2,max: size.height - monster.size.height/2)
        
        monster.position = CGPoint(x: size.width + monster.size.width/2 , y: actualY)
        
        addChild(monster)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    
    
    
    }
}
