//
//  ViewController.swift
//  labb2
//
//  Created by lucas persson on 2015-11-30.
//  Copyright © 2015 lucas persson. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var gamePlane: gamePlan!
    var gameScene:GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2*2));
        let scene = GameScene(size: view.bounds.size)
        let skView = gameView as! SKView
       //let skView:SKView = gameView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
        

    }
     
    @IBAction func button(sender: UIButton) {
        print("title:   \(sender.currentTitle)")
        print("plane xy:\(sender.frame.origin)")
        print("plane xy:\(sender.frame)")
        print("plane xy:\(sender.frame.origin)")
        print("outer xy:\(gamePlane.frame)")
        
        gameScene?.moveRedTo( CGPoint(x:sender.frame.origin.x + gamePlane.frame.origin.x ,y:sender.frame.origin.y + gamePlane.frame.origin.y))
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBOutlet weak var upsideDown: UILabel!

    
}

