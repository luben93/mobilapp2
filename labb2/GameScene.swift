//
//  GameScene.swift
//  labb2sprite
//
//  Created by lucas persson on 2015-12-01.
//  Copyright (c) 2015 lucas persson. All rights reserved.
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

import SpriteKit

class GameScene: SKScene {
    
    var blueTiles = [PlayerTile?](repeating: nil, count: 10)
    var redTiles = [PlayerTile?](repeating: nil, count: 10)
    
    var tileDefaultOffset:CGFloat = 10
    var selectedNodeIndex = -1
    var places = [CGPoint](repeating: CGPoint(), count: 25)
    var blueCan = SKSpriteNode()
    var redCan = SKSpriteNode()
    let label = SKLabelNode()
    var rule = Rules()
    var gameInfo = GameInfo()
    var eventMode = Event.normal
    
    var playerTiles:[PlayerTile?]{
        get{
            if rule.currentPlayerTile == .Blue {
                return blueTiles
            }
            return redTiles
        }
    }
    var opponentTiles:[PlayerTile?] {
        get{
            if rule.currentPlayerTile == .Blue {
                return redTiles
            }
            return blueTiles
        }
    }
    
    enum Event {
        case normal
        case mill
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.clear
        alotOfStuff()
    }
    
    func initializeNotifiers() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.notifiedEventPlaced), name: Rules.placed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.notifiedEventMill), name: Rules.mill, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.notifiedEventRemoved), name: Rules.removed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.notifiedEventNextTurn), name: Rules.nextTurn, object: nil)
            }

    func notifiedEventNextTurn(){
        eventMode = .normal
        setTurnText()
    }
    func notifiedEventPlaced(){
        //TODO place
    }
    func notifiedEventRemoved(){
        //eventMode = .normal
        //setTurnText()
    }
    func notifiedEventMill(){
        eventMode = .mill
    }

    
    
    
    // this method handles all touch events happening on screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // internet told us to have this
        guard let touch = touches.first else {
            print("returning prematurely")
            return
        }
        
        let touchLocation = touch.location(in: self)
    
        var selectedTileIndex = 0
        var currentTiles:[PlayerTile?]
        // SELECTION OF TILES
        //check for closet tileIndex
        
        switch eventMode {
        case .normal:
            currentTiles = playerTiles
            selectedTileIndex = closestTile(touchLocation, cmp: playerTiles)!
        case .mill:
            currentTiles = opponentTiles
            selectedTileIndex = closestTile(touchLocation, cmp:opponentTiles)!
        }
        
        // if selectedTileIndex is bigger than 0 we have touched a tile
        if  selectedTileIndex > 0 {
            if (currentTiles[selectedTileIndex]?.isDeleted)! {return}
            print("Selected tile: \(selectedTileIndex)")
            
            switch eventMode {
            case .normal:
                // checking if the tile that we selected is allready placed, if phaseOne it's not valid to select tiles that has been placed
                if rule.phaseOne {
                    if (currentTiles[selectedTileIndex]?.isPlaced)! {
                        print("Already placed")
                        return
                    }
                }
            case .mill:
                // if mill we can only select tiles that are already placed
                if !(currentTiles[selectedTileIndex]?.isPlaced)! {
                    print("not a placed tile")
                    return
                }
            }
            
            if selectedNodeIndex != -1{
                currentTiles[selectedNodeIndex]?.alpha=1
            }
            // if the selected tile is the previously selected one, we deselect it else
            if selectedNodeIndex == selectedTileIndex{
                currentTiles[selectedNodeIndex]?.alpha=1
                selectedNodeIndex = -1
            } else {
                // change selected tile
                currentTiles[selectedTileIndex]?.alpha = 0.7
                selectedNodeIndex = selectedTileIndex
            }
        }
        
        
        //if tile is selected then also check for touch places
        if selectedNodeIndex != -1 {
            let selectedPlace = closestPlaces(touchLocation)
            print("Selected place was: \(selectedPlace)")
            switch eventMode {
            case .normal:
                //if touch places was found, place tile and switch turn to next player
                if selectedPlace != -1{
                    // checking if selected place is available. Because of phase one we set from index to -1, it is not in use in this phase.
                    if let tile =  currentTiles[selectedNodeIndex]{
                        if rule.checkIfPlaceIsAvailable(to: selectedPlace,from: selectedNodeIndex){
                            // placing selected tile on selected place
                            moveTile(tile: tile, place: places[closestPlaces(touchLocation)])
                            rule.place(to: selectedPlace, from: selectedNodeIndex)
                            selectedNodeIndex = -1
                        } else {
                            print("Selected place was not available: \(selectedPlace)")
                        }
                    }
                }
                
            case .mill:
                // implement something nice where the user gets to remove opponents tile
                removeTile(tile: currentTiles.remove(at: selectedNodeIndex)!)
                rule.remove(tile: selectedPlace)
                selectedNodeIndex = -1
            }
        }
    }  

    
    
    
    
    
    private func removeTile(tile:PlayerTile){
    
        tile.isDeleted = true
        tile.isPlaced = false
        tile.alpha = 1.0
    
        let place = placeDeletedTile(tile: tile)
        moveTile(tile: tile, place: place)
        
    }
    
    private func moveTile(tile:PlayerTile, place:CGPoint){
        // placing selected tile on selected place
        tile.alpha = 1.0
        tile.isPlaced = true
    
        //get the distance between the destination position and the node's position
        let distance:Double = sqrt(pow(Double((place.x - tile.position.x)), 2.0) + pow(Double((place.y - tile.position.y)), 2.0));
        
        //calculate your new duration based on the distance
        let moveDuration = Float(0.001*distance);
        
        //move the node
        let move = SKAction.move(to: place, duration: TimeInterval(moveDuration))
    
        tile.run(move)
        
    }

    
    
    private func setTurnText(){
        /*if tileSelected == nil {
         label.text = "select tile"
         }else{
         label.text = "place tile"
         }*/
        
        switch rule.currentPlayerTile { //was a flipped bool, now normal
        case .Blue:
            label.fontColor = SKColor.blue
            label.zRotation = CGFloat(0)
        case .Red:
            label.fontColor = SKColor.red
            label.zRotation = CGFloat(M_PI)
        case .Empty: print("labelsetter error error"); break;
            
        }
    }
    
    
    
    //TODO  merge closest place and closet tile to one function and verify that it finds the correct CGPoint, and move 10000 to a minimal distance that matters
    func closestPlaces(_ touch:CGPoint) -> Int{
        
        var diff = CGFloat(30)
        var out = -1
        for i in 1...24{
            let tmp = sqrt(pow(touch.x-places[i].x,2)+pow(touch.y-places[i].y,2))
            if tmp <= diff {
                diff = tmp
                out = i
            }
        }
        
        return out
    }
    
    
    func closestTile(_ touch:CGPoint,cmp:[PlayerTile?]) -> Int?{
        
        var diff = CGFloat(30)
        var out:Int? = 0
        for (i,node) in cmp.enumerated() {
            //print("Tile:\(i), \(node), isPlaced: \(node?.isPlaced)")
            if let tile = node?.position{
                let tmp = hypot(touch.x-tile.x, touch.y-tile.y)
                if tmp <= diff {
                    diff = tmp
                    out = i
                }
            }
        }

        return out
    }
    func placeDeletedTile(tile:PlayerTile) -> CGPoint {
        let tileRemoveOffset = tileDefaultOffset * 0.4
        if tile.isBlue {
            return CGPoint(x: size.width * CGFloat(Double( tile.number ) * 0.1  ), y: size.height - tileRemoveOffset)
        } else {
            return CGPoint(x: size.width * (CGFloat( abs( Double( tile.number ) * 0.1 - 1)) ), y: tileRemoveOffset)
        }
    }
    
    func alotOfStuff(){
        
        
        
        
        
        let innerX:CGFloat = 0.1
        let middleX:CGFloat = 0.25
        let outerX:CGFloat = 0.4
        let halfX:CGFloat = 0.5
        
        let innerY:CGFloat = 0.9
        let middleY:CGFloat = 0.6
        let outerY:CGFloat = 0.25
        let halfY:CGFloat = 0.5
        
        places[0] = CGPoint(x:size.width/2,y:size.height/2)
        
        places[3] = CGPoint(x:size.width * innerX,y:size.height/2 + size.width/2 * innerY)
        places[2] = CGPoint(x:size.width * middleX,y:size.height/2 + size.width/2 * middleY)
        places[1] = CGPoint(x:size.width * outerX,y:size.height/2 + size.width/2 * outerY)
        
        places[6] = CGPoint(x:size.width * halfX,y:size.height/2 + size.width/2 * innerY)
        places[5] = CGPoint(x:size.width * halfX,y:size.height/2 + size.width/2 * middleY)
        places[4] = CGPoint(x:size.width * halfX,y:size.height/2 + size.width/2 * outerY)
        
        places[9] = CGPoint(x:size.width * (1 - innerX),y:size.height/2 + size.width/2 * innerY)
        places[8] = CGPoint(x:size.width * (1 - middleX),y:size.height/2 + size.width/2 * middleY)
        places[7] = CGPoint(x:size.width * (1 - outerX),y:size.height/2 + size.width/2 * outerY)
        
        places[12] = CGPoint(x:size.width * (1 - innerX),y:size.height * halfY )
        places[11] = CGPoint(x:size.width * (1 - middleX),y:size.height * halfY )
        places[10] = CGPoint(x:size.width * (1 - outerX),y:size.height * halfY )
        
        places[15] = CGPoint(x:size.width * (1 - innerX), y:size.height/2 - size.width/2 * innerY)
        places[14] = CGPoint(x:size.width * (1 - middleX), y:size.height/2 - size.width/2 * middleY)
        places[13] = CGPoint(x:size.width * (1 - outerX), y:size.height/2 - size.width/2 * outerY)
        
        places[18] = CGPoint(x:size.width * halfX, y:size.height/2 - size.width/2 * innerY)
        places[17] = CGPoint(x:size.width * halfX, y:size.height/2 - size.width/2 * middleY)
        places[16] = CGPoint(x:size.width * halfX, y:size.height/2 - size.width/2 * outerY)
        
        places[21] = CGPoint(x:size.width * innerX,y:size.height/2 - size.width/2 * innerY)
        places[20] = CGPoint(x:size.width * middleX,y:size.height/2 - size.width/2 * middleY)
        places[19] = CGPoint(x:size.width * outerX,y:size.height/2 - size.width/2 * outerY)
        
        places[24] = CGPoint(x:size.width * innerX,y:size.height/2  )
        places[23] = CGPoint(x:size.width * middleX,y:size.height/2 )
        places[22] = CGPoint(x:size.width * outerX,y:size.height/2 )
        
        
        
        let outer = CGMutablePath()
        outer.move(to: places[3])
        outer.addLine(to: places[9])
        outer.addLine(to: places[15])
        outer.addLine(to: places[21])
        drawRect(outer)
        
        let middle = CGMutablePath()
        middle.move(to: places[2])
        middle.addLine(to: places[8])
        middle.addLine(to: places[14])
        middle.addLine(to: places[20])
        drawRect(middle)
        
        let inner = CGMutablePath()
        inner.move(to: places[1])
        inner.addLine(to: places[7])
        inner.addLine(to: places[13])
        inner.addLine(to: places[19])
        drawRect(inner)
        
        let up = CGMutablePath()
        up.move(to: places[6])
        up.addLine(to: places[4])
        drawRect(up)
        
        let down = CGMutablePath()
        down.move(to: places[16])
        down.addLine(to: places[18])
        drawRect(down)
        
        let rigth = CGMutablePath()
        rigth.move(to: places[12])
        rigth.addLine(to: places[10])
        drawRect(rigth)
        
        let left = CGMutablePath()
        left.move(to:places[24])
        left.addLine(to: places[22])
        drawRect(left)
        
        
        //let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "start"
        label.fontSize = 17
        label.fontColor = SKColor.red
        label.position = places[0]
        label.setScale(1)
        addChild(label)
        setTurnText()
        
         tileDefaultOffset =  places[21].y  * 0.6
        
        for i in 1...9 {
            blueTiles[i] = PlayerTile(imageNamed: "blueTile")
            blueTiles[i]?.number = i
            blueTiles[i]?.isBlue = true
            
            redTiles[i] = PlayerTile(imageNamed: "redTile")
            redTiles[i]?.number = i
            redTiles[i]?.isBlue = false
            
            blueTiles[i]!.position = CGPoint(x: size.width * (CGFloat( abs( Double( i ) * 0.1 - 1)) ), y: tileDefaultOffset)
            redTiles[i]!.position = CGPoint(x: size.width * CGFloat(Double( i ) * 0.1  ), y: size.height - tileDefaultOffset )
            blueTiles[i]?.zPosition = 2
            redTiles[i]?.zPosition = 2
                
            addChild(blueTiles[i]!)
            addChild(redTiles[i]!)
        }

        
    }
    
    func drawRect(_ rect:CGMutablePath){
        
        rect.closeSubpath()
        
        
        let shapeNode = SKShapeNode()
        shapeNode.path = rect
        //        shapeNode.name = rect
        shapeNode.strokeColor = UIColor.gray
        shapeNode.lineWidth = 2
        shapeNode.zPosition = 1
        self.addChild(shapeNode)
    }
    
    
}
