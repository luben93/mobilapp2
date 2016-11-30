//
//  HomeViewController.swift
//  labb2
//
//  Created by Carl-Johan Dahlman on 2016-11-23.
//  Copyright © 2016 lucas persson. All rights reserved.
//


import UIKit
class HomeViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var newGame = true
    var gameId = 0
    var selectedGame = GameInfo()
    
    @IBOutlet weak var gamePickerView: UIPickerView!
    var savedGames:[GameInfo] = []
    var savedGameTags:[String] = []
    
    override func viewDidLoad() {
        print("Number Of Games: \(savedGames.count)")
        gamePickerView.delegate = self
        loadGames()
        //gameId = savedGames[gamePickerView.selectedRow(inComponent: 0)].id
        //gamePickerView.reloadAllComponents()
    }
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        newGame = true
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    @IBAction func loadGamePressed(_ sender: UIButton) {
        if savedGames.count > 0 {
            
            newGame = false
            performSegue(withIdentifier: "toGame", sender: nil)
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationView = segue.destination as! ViewController
        destinationView.newGame = self.newGame
        destinationView.savedGames = self.savedGames
        destinationView.savedGameTags = self.savedGameTags
        if !newGame {
            destinationView.gameId = self.gameId
            destinationView.activeGameInfo = selectedGame
        }
    }
    
    func loadGames(){
        var loadedGameTags: [String] = []
        if let loadedTags = UserDefaults.standard.array(forKey: GameInfo.Tags){
            
            loadedGameTags = loadedTags as! [String]
            savedGameTags = loadedGameTags
            
            print("Loading data was succesful")
            print("Games: \(loadedGameTags)")
            
            var tmpGame: GameInfo
            for tag in loadedGameTags {
                if let game = NSKeyedUnarchiver.unarchiveObject(withFile: GameInfo.ArchiveURL.path + tag){
                    print("loaded Game: \(tag)")
                    tmpGame = game as! GameInfo
                    savedGames.append(tmpGame)
                } else {
                    print("could not load Game for tag: \(tag)")
                    
                }
            }
        } else {
            UserDefaults.standard.setValue(loadedGameTags, forKey: GameInfo.Tags)
            UserDefaults.standard.synchronize()
            print("Saved Games was succesfully initiated")
            savedGames = []
            
        }
        
    }
    
    
    // calculating the number of rows for each component in the picker view
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return savedGames.count
    }

   
    // returning the number of columns to display in the pickerview
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    // responsible to print out the values for each item in the columns
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        selectedGame = savedGames[row]
        
        return NSAttributedString(string: selectedGame.date.description)
    }
    
    // action, user selected a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if savedGames.count > 0 {
            //gameId = savedGames[row].id
        }
       
    }
}
