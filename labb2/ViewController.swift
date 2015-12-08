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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        let scene = GameScene(size: view.bounds.size)
        let skView = gameView as! SKView
       //let skView:SKView = gameView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
        

    }
     
    
    @IBAction func restart(sender: UIButton) {
        let scene = GameScene(size: view.bounds.size)
        let skView = gameView as! SKView
        //let skView:SKView = gameView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
//        NSUserDefaults.standardUserDefaults().setObject(rules(), forKey: "save")
    }
}

