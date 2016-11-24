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
    
    var newGame = true
    var gameId = 0
    var gameInfo = GameInfo()
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var redLabel: UILabel!
    //@IBOutlet weak var gamePlane: gamePlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        
        restart(UIButton())
        
    }
    

     
    
    @IBAction func restart(_ sender: UIButton) {
        let scene = GameScene(size: view.bounds.size)
        scene.rule.id = gameId
        scene.initializeNotifiers()
        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
            }
}

