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

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var upsideDown: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.upsideDown.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2*2));
//        let scene = gamePlan(size: view.bounds.size)
//        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .ResizeFill
//        skView.presentScene(scene)
        let scene = GameScene(size: view.bounds.size)
        let skView = gameView as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
//        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)

    }

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBOutlet weak var upsideDown: UILabel!

    
}

