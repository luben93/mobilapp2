//
//  GameInfo.swift
//  labb2
//
//  Created by Carl-Johan Dahlman on 2016-11-23.
//  Copyright © 2016 lucas persson. All rights reserved.
//

import Foundation

enum Tiles: String {
    case Blue
    case Red
    case Empty
}

class GameInfo: NSObject, NSCoding {
    var id = 0
    var name:String = ""
    var gamePlan:[Tiles] = [Tiles](repeating: .Empty, count:25)
    var playerDetailsBlue:Int = 9
    var playerDetailsRed:Int = 9
    var isBlueTurn:Bool = true
    var date:Date = Date()
    var timeStamp = Date().timeIntervalSince1970
    //override var description: String
    
    
    override init() {
        
    }
    
    init?(id:Int, gamePlan:[Tiles],playerDetailsBlue:Int, playerDetailsRed:Int, isBlueTurn:Bool, date:Date, timeStamp:TimeInterval) {
        // Initialize stored properties.
        self.id = id
        self.gamePlan = gamePlan
        self.playerDetailsBlue = playerDetailsBlue
        self.playerDetailsRed = playerDetailsRed
        self.isBlueTurn = isBlueTurn
        self.date = date
        self.timeStamp = timeStamp
        //self.description = "TimeStamp: \(timeStamp), Id: \(id), playerDetailsBlue: \(playerDetailsBlue)"
        // Initialization should fail if there is no name or if the rating is negative.
      
    }
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let idKey = "id"
        static let gamePlanKey = "gamePlan"
        static let playerDetailsBlueKey = "detailBlue"
        static let playerDetailsRedKey = "detailRed"
        static let isBlueKey = "isBlue"
        static let dateKey = "date"
        static let timeStamp = "timeStamp"
        
    }
    
    // MARK: NSCoding
    
    internal func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(gamePlan.map{$0.rawValue}, forKey: PropertyKey.gamePlanKey)
        aCoder.encode(playerDetailsBlue, forKey: PropertyKey.playerDetailsBlueKey)
        aCoder.encode(playerDetailsRed, forKey: PropertyKey.playerDetailsRedKey)
        aCoder.encode(isBlueTurn, forKey: PropertyKey.isBlueKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        aCoder.encode(timeStamp, forKey: PropertyKey.timeStamp)
        
        
    }
    
    internal required convenience init?(coder aDecoder: NSCoder) {
        var cId = 0
        var cGamePlan:[Tiles] = [Tiles](repeating: .Empty, count:25)
        var cPlayerDetailsBlue:Int = 9
        var cPlayerDetailsRed:Int = 9
        var cIsBlueTurn:Bool = true
        var cDate:Date = Date()
        var cTimeStamp:TimeInterval = Date().timeIntervalSince1970
        
        if let nId = aDecoder.decodeObject(forKey: PropertyKey.idKey) as? Int {
            cId = nId
        }
        
        if let nGamePlan = aDecoder.decodeObject(forKey: PropertyKey.gamePlanKey) as? [String] {
            cGamePlan = nGamePlan.map({ Tiles.init(rawValue: $0)! })
        }
        if let nPlayerDetailsBlue = aDecoder.decodeObject(forKey: PropertyKey.playerDetailsBlueKey) as? Int {
            cPlayerDetailsBlue = nPlayerDetailsBlue
        }
        
        if let nPlayerDetailsRed = aDecoder.decodeObject(forKey: PropertyKey.playerDetailsRedKey) as? Int {
            cPlayerDetailsRed = nPlayerDetailsRed
        }
        
        if let nIsBlueTurn = aDecoder.decodeObject(forKey: PropertyKey.isBlueKey) as? Bool {
            cIsBlueTurn = nIsBlueTurn
        }
        if let nDate = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? Date {
            cDate = nDate
        }
        if let nTimeStamp = aDecoder.decodeObject(forKey: PropertyKey.timeStamp) as? TimeInterval {
            cTimeStamp = nTimeStamp
        }
        
        
        // Must call designated initializer.
        self.init(id:cId,gamePlan:cGamePlan,playerDetailsBlue:cPlayerDetailsBlue,playerDetailsRed:cPlayerDetailsRed,isBlueTurn:cIsBlueTurn, date:cDate, timeStamp:cTimeStamp)
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("gameInfos")
    static let Tags = "gameTags"

}
