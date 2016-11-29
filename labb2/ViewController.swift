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
    var activeGameInfo = GameInfo()
    var savedGames: [GameInfo] = []
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var redLabel: UILabel!
    //@IBOutlet weak var gamePlane: gamePlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        
        if newGame == true {
            print("New Game choosen")
            startNewGame()
            
            
        } else {
            print("old game choosen")
            loadGame()
        }
        
        
    }
    
    func startNewGame() {
        let scene = GameScene(size: view.bounds.size)
        let gameInfo = GameInfo()
        let rules = Rules(gameInfo: gameInfo)
        
        savedGames.append(gameInfo)
        NSKeyedArchiver.archiveRootObject(savedGames, toFile: GameInfo.ArchiveURL.path)
    
        
        scene.rule = rules
        scene.gameInfo = gameInfo
        scene.initializeNotifiers()

        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
        
    }
    
    func loadGame() {
        let scene = GameScene(size: view.bounds.size)
        let rules = Rules(gameInfo: activeGameInfo)
        
        scene.rule = rules
        scene.gameInfo = activeGameInfo
        scene.initializeNotifiers()
        
        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)

    }
    
    
    @IBAction func restart(_ sender: UIButton) {
        savedGames.remove(at: savedGames.index(of: activeGameInfo)!)
        startNewGame()
        
    }
}

