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
    var gameInfo = GameInfo()
    var rule = Rules()

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
        case waiting
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
        print("Notified: Next Player turn")
        eventMode = .normal
        setTurnText()
    }
    func notifiedEventPlaced(){
        print("Notified: Placed")
        //TODO place
    }
    func notifiedEventRemoved(){
        print("Notified: Removed")
        //eventMode = .normal
        //setTurnText()
    }
    func notifiedEventMill(){
        print("Notified: Mill")
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
        case .waiting:
            print("Waiting for consequence")
            return
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
                
            case .waiting:
                return
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
                    if let tile =  currentTiles[selectedNodeIndex]{
                        if rule.phaseOne {
                            // phase one
                            // checking if selected place is available. Because of phase one we set from index to 0, it is not in use in this phase.
                            if rule.checkIfPlaceIsAvailable(to: selectedPlace,from: 0){
                                eventMode = .waiting
                                print("Waiting for consequece from normal move, phase one")
                                
                                moveTile(tile: tile, place: places[closestPlaces(touchLocation)])
                                
                                // placing selected tile on selected place
                                rule.place(to: selectedPlace, from: 0)
                                tile.currentPlace = selectedPlace
                                selectedNodeIndex = -1
                                
                            }else {
                                print("Selected place was not available: \(selectedPlace)")
                            }
                        } else {
                            // phase two
                            if rule.checkIfPlaceIsAvailable(to: selectedPlace,from: tile.currentPlace){
                                eventMode = .waiting
                                print("Waiting for consequece from normal move, phase two")
                                
                                moveTile(tile: tile, place: places[closestPlaces(touchLocation)])
                                // placing selected tile on selected place
                                rule.place(to: selectedPlace, from: tile.currentPlace)
                                tile.currentPlace = selectedPlace
                                selectedNodeIndex = -1
                            }else {
                                print("Selected place was not available: \(selectedPlace)")
                            }
                        }
                    }
                }
                
            case .mill:
                // implement something nice where the user gets to remove opponents tile
                eventMode = .waiting
                print("Waiting for consequece from mill move")
                removeTile(tile: currentTiles.remove(at: selectedNodeIndex)!)
                rule.remove(tile: selectedPlace)
                selectedNodeIndex = -1
            
            case .waiting:
                return
            }
        }
    }  

    
    
    
    
    
    private func removeTile(tile:PlayerTile){
    
        tile.isDeleted = true
        tile.isPlaced = false
        tile.currentPlace = 0
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
        
        
        if size.height + 70 < size.width {
        if tile.isBlue {
            return CGPoint(x:  size.width * 0.95, y: size.height  * CGFloat(Double( tile.number ) * 0.1  ))
        } else {
            return CGPoint(x:size.width * 0.05 , y: size.height * (CGFloat( abs( Double( tile.number ) * 0.1 - 1)) ))
        }
        }else{
            if tile.isBlue {
                return CGPoint(x: size.width * CGFloat(Double( tile.number ) * 0.1  ), y: size.height - tileDefaultOffset * 0.4)
            } else {
                return CGPoint(x: size.width * (CGFloat( abs( Double( tile.number ) * 0.1 - 1)) ), y: tileDefaultOffset * 0.4)
            }
        }
    }
    
    func alotOfStuff(){
        
        
        
        //let x =  xo!
        //let y =  yo!
        let x = size.width
        let y = size.height
       
        let innerX:CGFloat = 0.1
        let middleX:CGFloat = 0.25
        let outerX:CGFloat = 0.4
        let halfX:CGFloat = 0.5
        
        let innerY:CGFloat = 0.9
        let middleY:CGFloat = 0.6
        let outerY:CGFloat = 0.25
        let halfY:CGFloat = 0.5

        
        let portait=[0:["x":x/2,"y":y/2],
                     3	:["x":x * innerX,             "y":y/2 + x/2 * innerY ],
                     2	:["x":x * middleX,            "y":y/2 + x/2 * middleY],
                     1	:["x":x * outerX,             "y":y/2 + x/2 * outerY ],
                     6	:["x":x * halfX,             "y":y/2 + x/2 * innerY ],
                     5	:["x":x * halfX,             "y":y/2 + x/2 * middleY],
                     4	:["x":x * halfX,             "y":y/2 + x/2 * outerY ],
                     9	:["x":x * (1 - innerX),      "y":y/2 + x/2 * innerY ],
                     8	:["x":x * (1 - middleX),     "y":y/2 + x/2 * middleY],
                     7	:["x":x * (1 - outerX),      "y":y/2 + x/2 * outerY ],
                     12	:["x":x * (1 - innerX),       "y":y * halfY          ],
                     11	:["x":x * (1 - middleX),      "y":y * halfY          ],
                     10	:["x":x * (1 - outerX),       "y":y * halfY          ],
                     15	:["x":x * (1 - innerX),       "y":y/2 - x/2 * innerY ],
                     14	:["x":x * (1 - middleX),      "y":y/2 - x/2 * middleY],
                     13	:["x":x * (1 - outerX),       "y":y/2 - x/2 * outerY ],
                     18	:["x":x * halfX,              "y":y/2 - x/2 * innerY ],
                     17	:["x":x * halfX,              "y":y/2 - x/2 * middleY],
                     16	:["x":x * halfX,              "y":y/2 - x/2 * outerY ],
                     21	:["x":x * innerX,             "y":y/2 - x/2 * innerY ],
                     20	:["x":x * middleX,            "y":y/2 - x/2 * middleY],
                     19	:["x":x * outerX,             "y":y/2 - x/2 * outerY ],
                     24	:["x":x * innerX,             "y":y/2                ],
                     23	:["x":x * middleX,            "y":y/2                ],
                     22	:["x":x * outerX,             "y":y/2                ]
            , ]
        
        let innerXL:CGFloat = 0.12   //1
        let middleXL:CGFloat = 0.25 //25
        let outerXL:CGFloat = 0.4   //4
        let halfXL:CGFloat = 0.5    //5

        let innerYL:CGFloat = 0.9   //9
        let middleYL:CGFloat = 0.6  //6
        let outerYL:CGFloat = 0.25 //25
        let halfYL:CGFloat = 0.5    //5
        let landscape=[
            0      :["x":y/2,"y":x/2],
            3      :["x":y * innerXL,             "y":x/2 + y/2 * innerYL ],
            2      :["x":y * middleXL,            "y":x/2 + y/2 * middleYL],
            1      :["x":y * outerXL,             "y":x/2 + y/2 * outerYL ],
            6      :["x":y * halfXL,              "y":x/2 + y/2 * innerYL ],
            5      :["x":y * halfXL,              "y":x/2 + y/2 * middleYL],
            4      :["x":y * halfXL,              "y":x/2 + y/2 * outerYL ],
            9      :["x":y * (1 - innerXL),       "y":x/2 + y/2 * innerYL ],
            8      :["x":y * (1 - middleXL),      "y":x/2 + y/2 * middleYL],
            7      :["x":y * (1 - outerXL),       "y":x/2 + y/2 * outerYL ],
            12     :["x":y * (1 - innerXL),       "y":x * halfYL          ],
            11     :["x":y * (1 - middleXL),      "y":x * halfYL          ],
            10     :["x":y * (1 - outerXL),       "y":x * halfYL          ],
            15     :["x":y * (1 - innerXL),       "y":x/2 - y/2 * innerYL ],
            14     :["x":y * (1 - middleXL),      "y":x/2 - y/2 * middleYL],
            13     :["x":y * (1 - outerXL),       "y":x/2 - y/2 * outerYL ],
            18     :["x":y * halfXL,              "y":x/2 - y/2 * innerYL ],
            17     :["x":y * halfXL,              "y":x/2 - y/2 * middleYL],
            16     :["x":y * halfXL,              "y":x/2 - y/2 * outerYL ],
            21     :["x":y * innerXL,             "y":x/2 - y/2 * innerYL ],
            20     :["x":y * middleXL,            "y":x/2 - y/2 * middleYL],
            19     :["x":y * outerXL,             "y":x/2 - y/2 * outerYL ],
            24     :["x":y * innerXL,             "y":x/2                ],
            23     :["x":y * middleXL,            "y":x/2                ],
            22     :["x":y * outerXL,             "y":x/2                ]
            , ]
        
        
        
        var orientation = ("x","y")
        var tmpPlace = portait
        var landscaped = false
        if UIDevice.current.orientation.isLandscape {
            orientation = ("y","x")
            tmpPlace = landscape
            landscaped = true
        }
        print(orientation)
        
        for i in 0...24{
            if let tmpX:CGFloat = tmpPlace[i]?[orientation.0]{
                if let tmpY:CGFloat = tmpPlace[i]?[orientation.1]{
                    places[i] = CGPoint(x:tmpX,y:tmpY)
                }
            }
        }
        
        
        
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
            
            var blueTilesPosition = CGPoint(x: size.width * (CGFloat( abs( Double( i ) * 0.1 - 1)) ), y: tileDefaultOffset)
            var redTilesPosition = CGPoint(x: size.width * CGFloat(Double( i ) * 0.1  ), y: size.height - tileDefaultOffset )
            
            
            if landscaped && size.height + 70 < size.width{
                blueTilesPosition = CGPoint(x:size.width*0.15, y:  size.height * (CGFloat( abs( Double( i ) * 0.1 - 1)) ))
                redTilesPosition = CGPoint(x:size.width * 0.85 , y: size.height  * CGFloat(Double( i ) * 0.1  )  )
            }
            
            
            
            blueTiles[i]!.position = blueTilesPosition
            redTiles[i]!.position = redTilesPosition
            blueTiles[i]?.zPosition = 2
            redTiles[i]?.zPosition = 2
                
            addChild(blueTiles[i]!)
            addChild(redTiles[i]!)
        }
        print("did allot of stuff  in portait: \(UIDevice.current.orientation.isPortrait)")

        
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
