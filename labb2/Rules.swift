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

    static let placed = Notification.Name("placed")
    static let removed = Notification.Name("removed")
    static let win = Notification.Name("win")
    static let mill = Notification.Name("mill")
    static let nextTurn = Notification.Name("nextTurn")
   
    private let save = UserDefaults.standard
    private var playerDefaultTiles:[Tiles:Int]{
        get{
            return [.Blue:info.playerDetailsBlue,.Red:info.playerDetailsRed]
        }
        set{
            info.playerDetailsBlue = newValue[.Blue]!
            info.playerDetailsRed = newValue[.Red]!
            save.set(NSKeyedArchiver.archivedData(withRootObject: info),forKey:"gameInfo\(id!)")
        }
    }
    var phaseOne:Bool{
        get{
            //TODO fix does not work, thinks phase one ends if only one player have 0 left
            let out = (playerDefaultTiles[.Blue]! != 0 && playerDefaultTiles[.Red]! != 0)
            print("phase one is \(out) blue left = \( playerDefaultTiles[.Blue]!)  red left = \( playerDefaultTiles[.Red]!)")
            return out

        }
    }
    private var gameplan:[Tiles]{
        get{
            
            return info.gamePlan
        }
        set{
            print("gameplan set")
            info.gamePlan = newValue
            print("newVal settetd ")

            save.set(NSKeyedArchiver.archivedData(withRootObject: info),forKey:"gameInfo\(id!)")
            didWin()
            print("WHOHOOOO")

        }
    }
   
    
    private var isBluesTurn:Bool {
        get{
            return info.isBlueTurn
        }
        set{
            info.isBlueTurn = newValue
            save.set(NSKeyedArchiver.archivedData(withRootObject: info),forKey:"gameInfo\(id!)")
            NotificationCenter.default.post(name: Rules.nextTurn, object: nil)
        }
    }
    
    
    var id:Int? = nil
    var info:GameInfo = GameInfo(){
        didSet{
            print("setting gInfo")
            //info = save.object(forKey: "gameInfo\(info.timeStamp)")! as! GameInfo
        }
    }
    
    // please make this more beautifully set
    func setGameInfo(info:GameInfo){
        self.info = info
    }
    var currentPlayerTile:Tiles  {
        get{
            if isBluesTurn{return .Blue}
            return .Red
        }
    }
    private var possibleMills = [[3,6,9],[2,5,8],[1,4,7],[24,23,22],[10,11,12],[19,16,13],[20,17,14],[21,18,15],//horizontal
        [3,24,21],[2,23,20],[1,22,19],[6,5,4],[16,17,18],[7,10,13],[8,11,14],[9,12,15]] //vertical
    
    
    // end of model
    // ====================================
    // rules
    
   
    private func didWin(){
        //TODO
        var opponent = Tiles.Blue
        if(isBluesTurn){ opponent = Tiles.Red}
        if(phaseOne && gameplan.filter({opponent == $0}).count <= 3){
            NotificationCenter.default.post(name: Rules.nextTurn, object: nil)
        }
    }
    
    private func hasMill(place:Int)-> Bool{
        //TODO does not detect multiple mills correctly
        let player = currentPlayerTile
        for possibleMill in possibleMills {
            if(possibleMill[0] == place || possibleMill[1] == place || possibleMill[2] == place ){
                if(gameplan[possibleMill[0]] == player && gameplan[possibleMill[1]] == player && gameplan[possibleMill[2]] == player ){
                    //TODO only detect new mills!!!!
                    print("located mill for \(player)")
                    NotificationCenter.default.post(name: Rules.mill, object: nil)
                    return true
                }
            }
        }
        
        return false //todo
    }
    
    
    func place(to:Int,from:Int)-> Bool{
        if(checkIfPlaceIsAvailable(to: to,from: from)){
            if phaseOne {
                gameplan[to] = currentPlayerTile
                playerDefaultTiles[currentPlayerTile]! -= 1
            } else {
                gameplan[to] = gameplan[from]
            }
            
             //   gameplan[to] = currentPlayerTile
            

            
            if !hasMill(place: to){
                isBluesTurn = !isBluesTurn

            }
            //print("gameplan: \(gameplan)")
            NotificationCenter.default.post(name: Rules.placed, object: nil)
            return true
            
        }
            print("invalid move")
            return false
        
    }
    
    func remove(tile:Int)-> Bool{
        
        var opponent = Tiles.Blue
        if (isBluesTurn){ opponent = Tiles.Red }
            print("Opponent: \(opponent)")
            print("GamePlan.Tiel: \(gameplan[tile])")
        
        
            if (gameplan[tile] == opponent ){
                
                isBluesTurn = !isBluesTurn
                gameplan[tile] = .Empty
                NotificationCenter.default.post(name: Rules.removed, object: nil)
                print("remove returning true")
                return true
            }
        print("remove returning false")
        return false
        
    }
    
    
    // checks if the selected place is avaiable and in the case of game beeing in phase two also check  if the move is valid
    func checkIfPlaceIsAvailable(to:Int, from:Int?) -> Bool {
        if gameplan[to] == .Empty {
            
            if phaseOne {
                
                return true
            }else{
                return isValidMove(to: to, from: from)
            }
        }
        return false
    }
    
    // getter for phase
  
    
    func placeIt() {
        NotificationCenter.default.post(name: Rules.placed, object: nil)
    }
    
    fileprivate func isValidMove(to:Int,from:Int?)->Bool{
        if(gameplan[to] != .Empty){
            return false
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
