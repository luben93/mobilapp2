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
    //var gameId = 0
    var selectedGame=""
    var settings = false
    
    @IBOutlet weak var gamePickerView: UIPickerView!
    //var savedGames:[GameInfo] = []
    var savedGameTags:[String] = []
    
    override func viewDidLoad() {
        print("Number Of Games: \(savedGameTags.count)")
        gamePickerView.delegate = self
        loadGames()
        //gameId = savedGames[gamePickerView.selectedRow(inComponent: 0)].id
        //gamePickerView.reloadAllComponents()
    }
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        newGame = true
        updateUI()
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    @IBAction func loadGamePressed(_ sender: UIButton) {
        if savedGameTags.count > 0 {
        
            newGame = false
            performSegue(withIdentifier: "toGame", sender: nil)
            
        }
        updateUI()
    }

    private func updateUI(){
        loadGames()
        //gamePickerView.delegate = self
       
        gamePickerView.reloadAllComponents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !self.settings {
            
            let destinationView = segue.destination as! ViewController
            destinationView.newGame = self.newGame
            //destinationView.savedGames = self.savedGames
            destinationView.savedGameTags = self.savedGameTags
            if !newGame {
                
                
                if let game = NSKeyedUnarchiver.unarchiveObject(withFile: GameInfo.ArchiveURL.path + selectedGame){
                    print("loaded Game: \(selectedGame)")
                    let tmpGame = game as! GameInfo
                    destinationView.activeGameInfo = tmpGame
                } else {
                    print("could not load Game for tag: \(selectedGame)")
                }
            }
        } else {
            
        }
    }
    
    func loadGames(){
        savedGameTags = []
        if let loadedTags = UserDefaults.standard.array(forKey: GameInfo.Tags){
            savedGameTags = loadedTags as! [String]
            print("Loading data was succesful")
            print("Games: \(savedGameTags)")
           
        } else {
            UserDefaults.standard.setValue(savedGameTags, forKey: GameInfo.Tags)
            UserDefaults.standard.synchronize()
            print("Saved Games was succesfully initiated")
            
            
        }
        
    }
    
    @IBAction func settings(_ sender: Any) {
        //performSegue(withIdentifier: "toSettings", sender: )
    }
    @IBAction func deletegame(_ sender: UIBarButtonItem) {
        do {
            if savedGameTags.count == 0 {
                print("empty array")
                return
            }
            savedGameTags.remove(at: savedGameTags.index(of: selectedGame)!)
            UserDefaults.standard.setValue(savedGameTags, forKey: GameInfo.Tags)
            UserDefaults.standard.synchronize()
            let path = URL(fileURLWithPath:GameInfo.ArchiveURL.path + selectedGame)
            print("less: \(FileManager.default.contents(atPath: path.absoluteString)) \n ls \(path)")
            try FileManager.default.removeItem(at:path)
            updateUI()

        } catch {
            print("error did not delete")
        }
    }
    
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem) {
        self.settings = true
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    
    // calculating the number of rows for each component in the picker view
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return savedGameTags.count
    }

   
    // returning the number of columns to display in the pickerview
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    // responsible to print out the values for each item in the columns
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        selectedGame = savedGameTags[row]
        
        return NSAttributedString(string: Date(timeIntervalSince1970: Double(selectedGame)!).description)
    }
    
    // action, user selected a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if savedGameTags.count > 0 {
            //gameId = savedGames[row].id
        }
       
    }
}
