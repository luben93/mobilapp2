//
//  rules.swift
//  labb2
//
//  Created by lucas persson on 2015-11-30.
//  Copyright © 2015 lucas persson. All rights reserved.
//
/*
 * The game board positions
 *
 * 03           06           09
 *     02       05       08
 *         01   04   07
 * 24  23  22   00   10  11  12
 *         19   16   13
 *     20       17       14
 * 21           18           15
 *
 */

import Foundation



class Rules {
    /*
     let emptySpace = 0
     let blueMoves = 1
     let redMoves = 2
     let blueMarker = 4
     let redMarker = 5
     */
    static let notifyEvent = Notification.Name("notifyEvent")
    private let save = UserDefaults.standard
    private var phaseOne = true
    private var gameplan:[Tiles]{
        get{
            return save.array(forKey: "newGameplan") as? [Tiles] ?? [Tiles](repeating: .Empty,count: 25)
        }
        set{
            save.set(newValue,forKey:"newGameplan")
            phaseOne = !(gameplan.filter({$0 == .Blue}).count == 9 && gameplan.filter({$0 == .Red}).count == 9)
        }
    }
    private var oldGameplan:[Int]{
        get{
            if let out = save.array(forKey: "gameplan") as? [Int]{
                return out
            }else{
                print("as? [int] did not work")
                let tmp = [Int](repeating: 0,count: 25)
                save.set(tmp, forKey: "gameplan")
                return tmp
            }
        }
        set{
            save.set(newValue, forKey: "gameplan")
        }
    }
    private var blue:Int{
        get{
            var out = save.integer(forKey: "blue")
            if out == -1{out = 9}
            return out
        }
        set{
            save.set(newValue, forKey: "blue")
        }
    }
    private var red:Int{
        get{
            var out = save.integer(forKey: "red")
            if out == -1{out = 9}
            return out
        }
        set{
            save.set(newValue, forKey: "red")
        }
    }
    private var isBluesTurn:Bool{
        get{
            return save.bool(forKey: "isBluesTurn")
        }
        set{
            save.set(newValue, forKey: "isBluesTurn")
        }
    }
    enum Tiles: String {
        case Blue  = "b"
        case Red   = "r"
        case Empty = "e"
    }
    
    enum Modes: String {
        case select = "s"
        case place  = "p"
        case remove = "r"
    }
    
    var mode = Modes.select
    
    private var selectedTile:Int?
    
    var latestTilePlaced:Int? = nil {
        didSet{
            if tile == nil {return}
            place()
        }
    }
    
    var tile:Int? = nil {
        didSet{
            if tile == nil {return}
            var out:Bool
            let oldmode = mode
            switch mode{
            case .select: out = select()
            case .place: out = place()
            case .remove: out = remove()
            }
            print("\(oldmode) \(out)")
        }
        //send notify
    }
    
    var currentPlayerTile:Tiles  {
        get{
            if isBluesTurn{return .Blue}
            return .Red
        }
    }
    private var possibleMills = [[3,6,9],[2,5,8],[1,4,7],[24,23,22],[10,11,12],[19,16,13],[20,17,14],[21,18,15],//horizontal
        [3,24,21],[2,23,20],[1,22,19],[6,5,4],[16,17,18],[7,10,13],[8,11,14],[9,12,15]] //vertical
    
    //end of model
    // ====================================
    // rules
    
    
    private func hasMill()-> Bool{
        let player = currentPlayerTile
        for possibleMill in possibleMills {
            if(gameplan[possibleMill[0]] == player && gameplan[possibleMill[1]] == player && gameplan[possibleMill[2]] == player ){
                mode = .remove
                print("located mill for \(player)")
                return true
            }
        }
        return false //todo
    }
    
    func select()-> Bool{
        if (mode == .select){
            print("selcet \(tile!) \(gameplan[tile!]) \(currentPlayerTile)")
            mode = .place
            if (currentPlayerTile == gameplan[tile!]){
                selectedTile = tile
                print("selected tile: \(selectedTile)")
                return true
            }else if(phaseOne){
                selectedTile = tile
                return true
            }
        }
        return false
    }
    
    func place()-> Bool{
        let from = selectedTile
        if(gameplan[tile!] == .Empty){
            
            //has mill should do something
            mode = .select
            // should check for valid move before this
            if !hasMill(){
                isBluesTurn = !isBluesTurn
            }
            if(phaseOne){
                return true
            }else{
                return isValidMove(to:tile!, from: from)
            }
        } else {
            print("invalid move, place not empty")
            return false
        }
    }
    
    func remove()-> Bool{
        
        var opponent = Tiles.Blue
        if (isBluesTurn){ opponent = Tiles.Red }
        if (mode == .remove ){
            if (gameplan[tile!] == opponent ){
                
                mode = .place // this does not seem right, sould be set to .select imo
                isBluesTurn = !isBluesTurn
                gameplan[tile!] = .Empty
                
                return true
            }
        }
        return false
        
    }
    
    
    // checks if the selected place is avaiable and in the case of game beeing in phase two also check  if the move is valid
    func checkIfPlaceIsAvailable(placeIndex:Int, fromPlaceIndex:Int) -> Bool {
        if phaseOne {
            if gameplan[placeIndex] == .Empty {
                isBluesTurn = !isBluesTurn
                return true
            }else{
                return isValidMove(to: placeIndex, from: fromPlaceIndex)
            }
        }
        return false
    }
    
    // getter for phase
    func isPhaseOne() -> Bool {
        return phaseOne
    }
    
    func placeIt() {
        mode = Modes.select
        NotificationCenter.default.post(name: Rules.notifyEvent, object: nil)
    }
    
    fileprivate func isValidMove(to:Int,from:Int?)->Bool{
        if(gameplan[to] != .Empty){
            return false
        }
        
        
        if from == nil {
            print("phase one")
            return true
        }
        
        //opional: if currentPlayer has 3 tiles left he/she may move to any empty space
        
        switch to {
        case 1:
            return (from == 4 || from == 22)
        case 2:
            return (from == 5 || from == 23)
        case 3:
            return (from == 6 || from == 24)
        case 4:
            return (from == 1 || from == 7 || from == 5)
        case 5:
            return (from == 4 || from == 6 || from == 2 || from == 8)
        case 6:
            return (from == 3 || from == 5 || from == 9)
        case 7:
            return (from == 4 || from == 10)
        case 8:
            return (from == 5 || from == 11)
        case 9:
            return (from == 6 || from == 12)
        case 10:
            return (from == 11 || from == 7 || from == 13)
        case 11:
            return (from == 10 || from == 12 || from == 8 || from == 14)
        case 12:
            return (from == 11 || from == 15 || from == 9)
        case 13:
            return (from == 16 || from == 10)
        case 14:
            return (from == 11 || from == 17)
        case 15:
            return (from == 12 || from == 18)
        case 16:
            return (from == 13 || from == 17 || from == 19)
        case 17:
            return (from == 14 || from == 16 || from == 20 || from == 18)
        case 18:
            return (from == 17 || from == 15 || from == 21)
        case 19:
            return (from == 16 || from == 22)
        case 20:
            return (from == 17 || from == 23)
        case 21:
            return (from == 18 || from == 24)
        case 22:
            return (from == 1 || from == 19 || from == 23)
        case 23:
            return (from == 22 || from == 2 || from == 20 || from == 24)
        case 24:
            return (from == 3 || from == 21 || from == 23)
        default: return false
        }
    }
    
}
