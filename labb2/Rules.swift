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
<<<<<<< HEAD:labb2/Rules.swift
    
    private var selectedTile:Int?
    
    var latestTilePlaced:Int? = nil {
        didSet{
            if tile == nil {return}
            place()
        }
    }
    
=======
    var selectedTile:Int?
>>>>>>> 9f5d36041381307b76540d76fd4cdac11f07219b:labb2/rules.swift
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
    }
    
    private var possibleMills = [[3,6,9],[2,5,8],[1,4,7],[24,23,22],[10,11,12],[19,16,13],[20,17,14],[21,18,15],//horizontal
                                [3,24,21],[2,23,20],[1,22,19],[6,5,4],[16,17,18],[7,10,13],[8,11,14],[9,12,15]] //vertical
   
    //end of model
    // ====================================
    // rules
    
    
   // func board(_ from:Int)->Int?{
   //     return gameplan[from]
   //}
    
     var currentPlayerTile:Tiles  {
        get{
            if isBluesTurn{return .Blue}
            return .Red
        }
    }
    
    
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
<<<<<<< HEAD:labb2/Rules.swift
                return true
            } else {
                return false
=======
            }
            if(phaseOne){
                gameplan[tile!] = currentPlayerTile
                return true
            }else{
                if( isValidMove(to:tile!, from: from)){
                    gameplan[tile!] = currentPlayerTile
                }
                
>>>>>>> 9f5d36041381307b76540d76fd4cdac11f07219b:labb2/rules.swift
            }
        } else {
            return isValidMove(to: placeIndex, from: fromPlaceIndex)
        }
    }
    
    // getter for phase
    func isPhaseOne() -> Bool {
        return phaseOne
    }
    
    func placeIt() {
        mode = Modes.select
        NotificationCenter.default.post(name: Rules.notifyEvent, object: nil)
    }
    
    /* func redDoTurn()->Bool{
     if isBluesTurn{
     isBluesTurn = false
     return true
     }
     isBluesTurn = true
     return false
     }
 
    func win(_ color:Int)->Bool{
        var markers = 0
        for count in 0...23{
            if gameplan[count] != 0 && gameplan[count] != color{
                markers += 1
            }
        }
        if(blue <= 0 && red <= 0 && markers < 3){
            return true
        }
        return false
    }
    
    
    func remove(_ from:Int,color:Int) -> Bool{
        if gameplan[from] == color {
            gameplan[from] = 0
            return true
        }
        return false
    }*/
    
    
   
    
    /*
     func legalMove(_ to:Int,from:Int) -> Bool {
     print("before first isBlue \(isBluesTurn)")
     if !isBluesTurn {
     if red >= 0 {
     print("r>=0")
     if gameplan[to] == emptySpace {
     print("gameplan empty")
     gameplan[to] = redMarker
     red -= 1
     isBluesTurn = true
     return true
     }
     }
     if gameplan[to] == emptySpace {
     print("gameplan empty")
     if let tmp = isValidMove(to,from:from){
     print("ris valid \(tmp)")
     
     gameplan[to] = redMarker
     isBluesTurn = true
     blue -= 1
     return true
     }
     }
     }else{
     if blue >= 0 {
     print("b<=0")
     if gameplan[to] == emptySpace {
     print("gameplan empty")
     gameplan[to] = blueMarker
     blue -= 1
     isBluesTurn = false
     return true
     }
     }
     
     if gameplan[to] == emptySpace{
     print("bgameplan empty")
     if let tmp = isValidMove(to,from:from){
     print("is valid \(tmp )")
     gameplan[to] = blueMarker
     isBluesTurn = false
     return true
     }
     }
     }
     return false
     }*/
    
    /*
    func remove(_ to:Int) -> Bool? {
        
        if ((to == 1 || to == 4 || to == 7) && gameplan[1] == gameplan[4]
            && gameplan[4] == gameplan[7]) {
            return true;
        } else if ((to == 2 || to == 5 || to == 8)
            && gameplan[2] == gameplan[5] && gameplan[5] == gameplan[8]) {
            return true;
        } else if ((to == 3 || to == 6 || to == 9)
            && gameplan[3] == gameplan[6] && gameplan[6] == gameplan[9]) {
            return true;
        } else if ((to == 7 || to == 10 || to == 13)
            && gameplan[7] == gameplan[10] && gameplan[10] == gameplan[13]) {
            return true;
        } else if ((to == 8 || to == 11 || to == 14)
            && gameplan[8] == gameplan[11] && gameplan[11] == gameplan[14]) {
            return true;
        } else if ((to == 9 || to == 12 || to == 15)
            && gameplan[9] == gameplan[12] && gameplan[12] == gameplan[15]) {
            return true;
        } else if ((to == 13 || to == 16 || to == 19)
            && gameplan[13] == gameplan[16] && gameplan[16] == gameplan[19]) {
            return true;
        } else if ((to == 14 || to == 17 || to == 20)
            && gameplan[14] == gameplan[17] && gameplan[17] == gameplan[20]) {
            return true;
        } else if ((to == 15 || to == 18 || to == 21)
            && gameplan[15] == gameplan[18] && gameplan[18] == gameplan[21]) {
            return true;
        } else if ((to == 1 || to == 22 || to == 19)
            && gameplan[1] == gameplan[22] && gameplan[22] == gameplan[19]) {
            return true;
        } else if ((to == 2 || to == 23 || to == 20)
            && gameplan[2] == gameplan[23] && gameplan[23] == gameplan[20]) {
            return true;
        } else if ((to == 3 || to == 24 || to == 21)
            && gameplan[3] == gameplan[24] && gameplan[24] == gameplan[21]) {
            return true;
        } else if ((to == 22 || to == 23 || to == 24)
            && gameplan[22] == gameplan[23] && gameplan[23] == gameplan[24]) {
            return true;
        } else if ((to == 4 || to == 5 || to == 6)
            && gameplan[4] == gameplan[5] && gameplan[5] == gameplan[6]) {
            return true;
        } else if ((to == 10 || to == 11 || to == 12)
            && gameplan[10] == gameplan[11] && gameplan[11] == gameplan[12]) {
            return true;
        } else if ((to == 16 || to == 17 || to == 18)
            && gameplan[16] == gameplan[17] && gameplan[17] == gameplan[18]) {
            return true;
        }
        return nil;
    }
 */
    
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
