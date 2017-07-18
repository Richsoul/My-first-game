//
//  GameScene.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    enum GameState {
        case running, dead, pause
    }
    enum Obstacle {
        case fishNet, boat, seaweed, none
    }
    var gameState: GameState = .running
    var obstacleKind: Obstacle = .none
    var water:        SKSpriteNode!
    var hero:         SKSpriteNode!
    var pauseWindow:  SKSpriteNode!
    var item:         SKSpriteNode!
    var item2:        SKSpriteNode!
    var item3:        SKSpriteNode!
    var oxygenLvl:    SKSpriteNode!
    var pauseButton:   MSButtonNode!
    var button:        MSButtonNode!
    var pause:         MSButtonNode!
    var highestDistanceScore: SKLabelNode!
    var currentDistanceScore: SKLabelNode!
    var moneyCounterScore:    SKLabelNode!
    var scrollLayer:    SKNode!
    var boatLayer:      SKNode!
    var obstacleLayer:  SKNode!
    var obstacleSource: SKNode!
    var obstacleNode:   SKNode?
    var fixedDelta:        CFTimeInterval = 1.0 / 60.0
    var netSpawnTimer:     CFTimeInterval = 8
    var boatSpawnTimer:    CFTimeInterval = 10
    var itemSpawnTimer:    CFTimeInterval = 6
    var seaweedSpawnTimer: CFTimeInterval = 12
    var holding: Bool = false
    var diveForce = 0
    var scrollSpeed: CGFloat = 0
    var maxVelocity: CGFloat = 0
    var minVelocity: CGFloat = 0
    var fishingNet: SKSpriteNode!
    var boat1:       SKSpriteNode!
    var seaweed:    SKSpriteNode!
    var money = 0
    var oxygen = 100.00
    var distance = 0
    var SWRT: Double = 0.0
    var health: CGFloat = 1.0 {
        didSet {
            oxygenLvl.xScale = health
            if health > 1.0 { health = 1.0 }
            if health < 0 {
                health = 0
                gameState = .dead
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        water = childNode(withName: "water") as! SKSpriteNode
        hero = childNode(withName: "hero") as! SKSpriteNode
        pauseWindow = childNode(withName: "pauseWindow") as! SKSpriteNode
        oxygenLvl = childNode(withName: "oxygenLvl") as! SKSpriteNode
        pauseButton = childNode(withName: "pauseButton") as! MSButtonNode
        highestDistanceScore = childNode(withName: "//highestDistanceScore") as! SKLabelNode
        currentDistanceScore = childNode(withName: "//currentDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "//moneyCounterScoreGS") as! SKLabelNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        boatLayer = self.childNode(withName: "boatLayer")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "obstacle")
        fishingNet = childNode(withName: "//fishingNet") as! SKSpriteNode
        boat1 = childNode(withName: "//boat") as! SKSpriteNode
        seaweed = childNode(withName: "//seaweed") as! SKSpriteNode
        item = childNode(withName: "//item") as! SKSpriteNode
        item2 = childNode(withName: "//item2") as! SKSpriteNode
        item3 = childNode(withName: "//item3") as! SKSpriteNode
        pauseWindow.isHidden = true
        hero.position.x = -236
        scrollSpeed = 60
        diveForce = -40
        maxVelocity = -70
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        pause = childNode(withName: "//pauseButton") as! MSButtonNode
        pause.selectedHandler = {
            self.gameState = .pause
        }
        buttonFunc(fileName: "//restartButton", direction: "GameScene")
        buttonFunc(fileName: "//mainMenuButton", direction: "MainMenu")
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        if contactA.categoryBitMask == 16 || contactB.categoryBitMask == 16 {
            obstacleKind = .seaweed
            if contactA.categoryBitMask == 16 {
                obstacleNode = nodeA
            } else {
                obstacleNode = nodeB
            }
            if contactA.categoryBitMask == 32 || contactB.categoryBitMask == 32 {
                if contactA.categoryBitMask == 16 {
                    nodeA.physicsBody?.isDynamic = false
                } else if contactB.categoryBitMask == 16 {
                    nodeB.physicsBody?.isDynamic = false
                }
            }
        }
        if contactA.categoryBitMask == 8 || contactB.categoryBitMask == 8 {
            if contactA.categoryBitMask == 8 {
                nodeA.removeFromParent()
                money += 1
            } else {
                nodeB.removeFromParent()
                money += 1
            }
        }
        if contactA.categoryBitMask == 64 || contactB.categoryBitMask == 64 {
            if contactA.categoryBitMask == 64 {
                nodeA.removeFromParent()
                money += 2
            } else {
                nodeB.removeFromParent()
                money += 2
            }
        }
        if contactA.categoryBitMask == 128 || contactB.categoryBitMask == 128 {
            if contactA.categoryBitMask == 128 {
                nodeA.removeFromParent()
                money += 3
            } else {
                nodeB.removeFromParent()
                money += 3
            }
        }
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            obstacleKind = .fishNet
            if contactA.categoryBitMask == 2 {
                obstacleNode = nodeA
                nodeA.isHidden = true
            } else {
                obstacleNode = nodeB
                nodeB.isHidden = true
            }
        }
    }
    
    func showPauseWindow() {
        pauseWindow.isHidden = false
        scene?.view?.isPaused = true
    }
    
    func playersDeath() {
        guard let skView = self.view as SKView! else {
            return
        }
        guard let scene = SKScene(fileNamed:"DeathScene") else {
            return
        }
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    func scrollWorld() {
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            if groundPosition.x <= -ground.size.width / 2 - 510{
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func updateBoat() {
        boatLayer.position.x -= (scrollSpeed + 100) * CGFloat(fixedDelta)
        for boat in boatLayer.children as! [SKSpriteNode] {
            
            let boatPosition = boatLayer.convert(boat.position, to: self)
            if boatPosition.x <= -530 {
                boat.removeFromParent()
            }
            
        }
        if boatSpawnTimer >= 24 {
            let newBoat = boat1.copy() as! SKSpriteNode
            boatLayer.addChild(newBoat)
            let newPosition = CGPoint(x: 800, y: 100)
            newBoat.position = self.convert(newPosition, to: boatLayer)
            boatSpawnTimer = 0
        }
        
    }
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            if obstaclePosition.x <= -320 {
                obstacle.removeFromParent()
            }
            
        }
        
        if netSpawnTimer >= 19 {
            let newNet = fishingNet.copy() as! SKSpriteNode
            obstacleLayer.addChild(newNet)
            let newPosition = CGPoint(x: 400/* + array[n]*/, y: 8)
            newNet.position = self.convert(newPosition, to: obstacleLayer)
            netSpawnTimer = 0
        }
        
        if itemSpawnTimer >= 11 {
            let n = Int(arc4random_uniform(3))
            let itemArray: [SKSpriteNode?] = [item, item2, item3]
            let newItem = itemArray[n]?.copy() as! SKSpriteNode
            obstacleLayer.addChild(newItem)
            let newPosition = CGPoint(x: 400, y: 60)
            newItem.position = self.convert(newPosition, to: obstacleLayer)
            newItem.physicsBody?.applyForce(CGVector(dx: 0, dy: -60))
            itemSpawnTimer = 0
        }
        if seaweedSpawnTimer >= 17 {
            let newSeaweed = seaweed.copy() as! SKSpriteNode
            obstacleLayer.addChild(newSeaweed)
            let newPosition = CGPoint(x: 500, y: 60)
            newSeaweed.position = self.convert(newPosition, to: obstacleLayer)
            newSeaweed.physicsBody?.velocity.dy = CGFloat(-40)
            seaweedSpawnTimer = 0
        }
    }
    
    func buttonFunc(fileName: String, direction: String) { //custom button transfer, for any situation
        button = childNode(withName: "\(fileName)") as! MSButtonNode
        button.selectedHandler = {
            guard let skView = self.view as SKView! else {
                return
            }
            guard let scene = SKScene(fileNamed:"\(direction)") else {
                return
            }
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
        }
    }
    
    func float() {
        
        hero.position.x = -190
        let heroPositionY = hero.position.y
        let waterSurface = water.size.height/2 - 40
        if heroPositionY > waterSurface + 10 {
            hero.position.y = waterSurface + 10
        }
        if heroPositionY > waterSurface && heroPositionY < waterSurface + 5{
            hero.physicsBody?.applyForce(CGVector(dx:0, dy: 5))
        }
        if heroPositionY > waterSurface + 5{
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: -30))
        }
    }
    
   func oxygenlvl() {
        if hero.position.y >= 80 {
            health += 0.1 / 60
        } else {
            health -= 0.07 / 60
        }
    }
    
    func root(){
        switch obstacleKind{
        case .seaweed:
            scrollSpeed = 20
            diveForce = -40/3
            maxVelocity = -70/3
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5/5)
            minVelocity = 70/3
            break
        case .fishNet:
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            minVelocity = 0
            break
        default:
            scrollSpeed = 60
            diveForce = -40
            maxVelocity = -70
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
            minVelocity = 70
        }
    }
    func updateDistance() {
        distance = Int(abs(scrollLayer.position.x / 50))
        currentDistanceScore.text = String(distance)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)  {
        hero.physicsBody?.applyForce(CGVector(dx:0, dy: diveForce))
        holding = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        holding = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        float()
        updateObstacles()
        updateBoat()
        updateDistance()
        if gameState == .dead {
        playersDeath()
        }
        if gameState == .pause {
            showPauseWindow()
        }
        scrollWorld()
        netSpawnTimer += fixedDelta
        boatSpawnTimer += fixedDelta
        itemSpawnTimer += fixedDelta
        seaweedSpawnTimer += fixedDelta
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        if holding == true {
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: diveForce))
            if velocityY < maxVelocity {
                hero.physicsBody?.velocity.dy = maxVelocity
            }
        }
        if velocityY > minVelocity {
            hero.physicsBody?.velocity.dy = minVelocity
        }
        
        root()
        if let obstacle = obstacleNode {
            if !obstacle.intersects(hero) {
                obstacleKind = .none
                obstacleNode = nil
            }
        }
        moneyCounterScore.text = String(money)
        oxygenlvl()
        }
}
