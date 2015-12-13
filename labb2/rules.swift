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

class rules {

    let emptySpace = 0
    let blueMoves = 1
    let redMoves = 2
    let blueMarker = 4
    let redMarker = 5
    let save = NSUserDefaults.standardUserDefaults()
    var gameplan:[Int]{
        get{
            if let out = save.arrayForKey("gameplan") as? [Int]{
                return out
            }else{
                let tmp = [Int](count:25,repeatedValue:0)
                save.setObject(tmp, forKey: "gameplan")
                return tmp
            }
        }
        set{
            save.setObject(newValue, forKey: "gameplan")
        }
    }
    var blue:Int{
        get{
            let out = save.integerForKey("blue")
            switch out{
            case -1:
                save.setInteger(9, forKey: "blue")
                return 9
            default: return out
            }
        }
        set{
            save.setInteger(newValue, forKey: "blue")
        }
    }
    var red:Int{
        get{
            let out = save.integerForKey("red")
            switch out{
            case -1:
                save.setInteger(9, forKey: "red")
                return 9
            default: return out
            }
        }
        set{
            save.setInteger(newValue, forKey: "red")
        }
    }
    var isBluesTurn:Bool{
        get{
            switch save.integerForKey("isBluesTurn"){
            case 1:  return true
            case 2:  return false
            default:
                save.setInteger(1,forKey: "isBluesTurn")
                return true
            }
        }
        set{
            if newValue{
                save.setInteger(1, forKey: "isBluesTurn")
            }else{
                save.setInteger(2, forKey: "isBluesTurn")
            }
        }
    }
    //end of model

    
    func board(from:Int)->Int?{
        return gameplan[from]
    }
    
   /* func redDoTurn()->Bool{
        if isBluesTurn{
            isBluesTurn = false
            return true
        }
        isBluesTurn = true
        return false
    }
    */
    func win(color:Int)->Bool{
        var markers = 0
        for count in 0...23{
            if gameplan[count] != 0 && gameplan[count] != color{
                markers++
            }
        }
        if(blue <= 0 && red <= 0 && markers < 3){
            return true
        }
        return false
    }
    
    func remove(from:Int,color:Int) -> Bool{
        if gameplan[from] == color {
            gameplan[from] = 0
            return true
        }
        return false
    }
    
    func legalMove(to:Int,from:Int) -> Bool {
        print("before first \n isBlue \(isBluesTurn)")
        if !isBluesTurn {
                if red >= 0 {
                    print("r<=0")
                    if gameplan[to] == emptySpace {
                        print("gameplan empty")
                        gameplan[to] = redMarker
                        red--
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
                    blue--
                    return true
                }
            }

        }else{
            if blue >= 0 {
                print("b<=0")
                if gameplan[to] == emptySpace {
                    print("gameplan empty")
                    gameplan[to] = blueMarker
                    blue--
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
    }
    
    func remove(to:Int) -> Bool? {
        
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
    
    private func isValidMove(to:Int,from:Int)->Bool?{
        if gameplan[to] != 0 {
            return nil
        }
        
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
        default: return nil
        }
        
        return nil
        
    }
    
}