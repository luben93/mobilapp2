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
    var savedGameTags: [String] = []
    var rules = Rules()
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var redLabel: UILabel!
    //@IBOutlet weak var gamePlane: gamePlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notifiedEventWin), name: Rules.win, object: nil)
        
        if newGame == true {
            print("New Game choosen")
            startNewGame()
            
            
        } else {
            print("old game choosen")
            loadGame()
        }
        
        
    }
    
    func notifiedEventWin(){
        print("Notified: Win")
        // alertbox
        var playerThatWonTheMatch = "RED"
        if rules.isBluesTurn{
            playerThatWonTheMatch = "BLUE"
        }
        let alert = UIAlertController(title: playerThatWonTheMatch + " WON!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: UIAlertActionStyle.default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func startNewGame() {
        let scene = GameScene(size: view.bounds.size)
        let gameInfo = GameInfo()
        self.rules = Rules(gameInfo: gameInfo)
        
        
        print("TimeStamp: \(gameInfo.timeStamp.description)")
        
        savedGameTags.append(gameInfo.timeStamp.description)
        print("gameTagsAfterAppend: \(savedGameTags) ")
        
        UserDefaults.standard.set(savedGameTags, forKey: GameInfo.Tags)
        UserDefaults.standard.synchronize()
        
        NSKeyedArchiver.archiveRootObject(gameInfo, toFile: GameInfo.ArchiveURL.path + gameInfo.timeStamp.description)
    
        
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
        self.rules = Rules(gameInfo: activeGameInfo)
        
        scene.rule = rules
        scene.gameInfo = activeGameInfo
        scene.initializeNotifiers()
        
        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)

    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func restart(_ sender: UIButton) {
        var loadedGameTags: [String] = []
        if let loadedTags = UserDefaults.standard.value(forKey: GameInfo.Tags){
            loadedGameTags = loadedTags as! [String]
            loadedGameTags.remove(at: loadedGameTags.index(of: activeGameInfo.timeStamp.description)!)
        
            startNewGame()
        }
    }
}

