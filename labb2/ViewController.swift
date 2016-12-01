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
   // var gameId = 0
    var activeGameInfo:GameInfo?{
        didSet{
            if let tmp = sceneOptional{
                tmp.ruleOpt?.info = activeGameInfo!
            }
        }
    }
    var savedGames: [GameInfo] = []
    var savedGameTags: [String] = []
    var rules:Rules {
        return (sceneOptional?.rule)!
    }
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var redLabel: UILabel!
    //@IBOutlet weak var gamePlane: gamePlan!
    var sceneOptional:GameScene?
    override func didRotate(from: UIInterfaceOrientation) {
        print("did rotate")
        if let tmp = sceneOptional{
            tmp.size = view.bounds.size
            tmp.removeAllChildren()
            tmp.alotOfStuff() //todo
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.redLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notifiedEventWin), name: Rules.win, object: nil)
        loadGameTags()
        
        if newGame == true {
            print("New Game choosen")
            startNewGame()
            
            
        } else {
            print("old game choosen \(activeGameInfo?.timeStamp)")
            loadGame()
        }
        
        
    }
    func loadGameTags(){
        if let loadedTags = UserDefaults.standard.array(forKey: GameInfo.Tags){
            savedGameTags = loadedTags as! [String]
            print("ViewController:Loading data was succesful")
            print("ViewController:Games: \(savedGameTags)")
            
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
        sceneOptional = scene
        let gameInfo = GameInfo()
        activeGameInfo = gameInfo
        scene.ruleOpt = Rules(gInfo: gameInfo)
        
        
        print("TimeStamp: \(gameInfo.timeStamp.description)")
        
        savedGameTags.append(gameInfo.timeStamp.description)
        print("gameTagsAfterAppend: \(savedGameTags) ")
        
        UserDefaults.standard.set(savedGameTags, forKey: GameInfo.Tags)
        UserDefaults.standard.synchronize()
        
        NSKeyedArchiver.archiveRootObject(gameInfo, toFile: GameInfo.ArchiveURL.path + gameInfo.timeStamp.description)
    
        
        scene.gameInfoOpt = gameInfo
        scene.initializeNotifiers()
//        gameView.contentMode = .redraw

        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)
        
    }
    
    func loadGame() {
        let scene = GameScene(size: view.bounds.size)
        sceneOptional = scene

        scene.ruleOpt = Rules(gInfo: activeGameInfo)
        scene.gameInfoOpt = activeGameInfo!
        rules.info = activeGameInfo!
        scene.initializeNotifiers()
        
        let skView = gameView as! SKView
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skView.presentScene(scene)

    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func restart(_ sender: UIButton) {//TODO not used anymore remove
        var loadedGameTags: [String] = []
        if let loadedTags = UserDefaults.standard.value(forKey: GameInfo.Tags){
            loadedGameTags = loadedTags as! [String]
            loadedGameTags.remove(at: loadedGameTags.index(of: activeGameInfo!.timeStamp.description)!)
        
            startNewGame()
        }
    }
}

