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
    //@IBOutlet weak var gamePlane: gamePlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        let scene = GameScene(size: view.bounds.size)
        scene.initializeNotifiers()
        let skView = gameView as! SKView
        UserDefaults.standard.set(-1, forKey: "blue")
        UserDefaults.standard.set(-1, forKey: "red")
       //let skView:SKView = gameView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)

        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notifiedEventNextTurn), name: Rules.nextTurn, object: nil)

    }
    
    func notifiedEventNextTurn() {
        print("ViewController:notifiedEventNextTurn")
    }
     
    
    @IBAction func restart(_ sender: UIButton) {
        let scene = GameScene(size: view.bounds.size)
        scene.initializeNotifiers()
        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
        print("reset turn was\(UserDefaults.standard.integer(forKey: "isBluesTurn"))")
        UserDefaults.standard.set(0, forKey: "isBluesTurn")
        UserDefaults.standard.set(-1, forKey: "blue")
        UserDefaults.standard.set(-1, forKey: "red")
        
        for i in 0..<25 {
            UserDefaults.standard.set("Empty", forKey: "gameplan\(i)")
        }

        UserDefaults.standard.set(-1, forKey: "red")
       // [Int](count:25,repeatedValue:0)
        UserDefaults.standard.set([Int](repeating: 0,count: 25), forKey: "gameplan")

//        NSUserDefaults.resetStandardUserDefaults()
        print("reset turn is\(UserDefaults.standard.integer(forKey: "isBluesTurn"))")
    }
}

