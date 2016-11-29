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
    
    @IBOutlet weak var gamePickerView: UIPickerView!
    var savedGames:[GameInfo] = []
    
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
        newGame = false
        performSegue(withIdentifier: "toGame", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationView = segue.destination as! ViewController
        destinationView.newGame = self.newGame
        destinationView.savedGames = self.savedGames
        if !newGame {
            destinationView.gameId = self.gameId
        }
    }
    
    func loadGames(){
        var loadedGames: [GameInfo]
        if let loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: GameInfo.ArchiveURL.path){
            loadedGames = loadedData as! [GameInfo]
            print("Loading data was succesful")
            print("Games: \(loadedGames)")
            savedGames = loadedGames
            
        } else {
            savedGames = []
            if NSKeyedArchiver.archiveRootObject(savedGames, toFile: GameInfo.ArchiveURL.path){
                print("Saved Games was succesfully initiated")
            }
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
        
        let value: GameInfo = savedGames[row]
        
        return NSAttributedString(string: value.date.description)
    }
    
    // action, user selected a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gameId = savedGames[row].id
       
    }
}
