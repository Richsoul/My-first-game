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
        case running, dead, pause, resume
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
    var resume:        MSButtonNode!
    var highestDistanceScore: SKLabelNode!
    var currentDistanceScore: SKLabelNode!
    var moneyCounterScore:    SKLabelNode!
    var scrollLayer:    SKNode!
    var boatLayer:      SKNode!
    var obstacleLayer:  SKNode!
    var obstacleSource: SKNode!
    var obstacleNode:   SKNode?
    var fixedDelta:        CFTimeInterval = 1.0 / 60.0
    var netSpawnTimer:     CFTimeInterval = 4
    var boatSpawnTimer:    CFTimeInterval = 14
    var itemSpawnTimer:    CFTimeInterval = 6
    var seaweedSpawnTimer: CFTimeInterval = 10
    var holding: Bool = false
    var diveForce = 0
    var scrollSpeed: CGFloat = 0
    var boatSpeed:   CGFloat = 100
    var maxVelocity: CGFloat = 0
    var minVelocity: CGFloat = 0
    var fishingNet: SKSpriteNode!
    var boat1:       SKSpriteNode!
    var seaweed:    SKSpriteNode!
    var money = 0
    var oxygen = 100.00
    var distance = 0
    var SWRT: Double = 0.0
    var x = 0.1
    var y = 0.08
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
        resume = childNode(withName: "//resumeButton") as! MSButtonNode
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
        resume.selectedHandler = {
            self.gameState = .resume
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
                if nodeA.name == "item" {
                    money += 1
                } else if nodeA.name == "item2" {
                    money += 2
                } else if nodeA.name == "item3" {
                    money += 3
                }
                nodeA.removeFromParent()
               
            } else {
                if nodeB.name == "item" {
                    money += 1
                } else if nodeB.name == "item2" {
                    money += 2
                } else if nodeB.name == "item3" {
                    money += 3
                }
                nodeB.removeFromParent()
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
    
    func resumeTheGame() {
        pauseWindow.isHidden = true
        scrollSpeed = 60
        diveForce = -40
        maxVelocity = -70
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        minVelocity = 70
        x = 0.1
        y = 0.08
        boatSpeed = 100
        gameState = .running
    }
    
    func showPauseWindow() {
        pauseWindow.isHidden = false
        scrollSpeed = 0
        diveForce = 0
        maxVelocity = 0
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        minVelocity = 0
        x = 0
        y = 0
        boatSpeed = 0
    }
    
    func playersDeath() {
        if let scene = SKScene(fileNamed: "DeathScene") {
            scene.scaleMode = .aspectFit
            view?.presentScene(scene)
        }
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
        boatLayer.position.x -= (scrollSpeed + boatSpeed) * CGFloat(fixedDelta)
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
        let randomArray: [CGFloat?] = [-100, -50, 0, 50, 100]
        let n = randomArray[Int(arc4random_uniform(4))]
        let newNet = fishingNet.copy() as! SKSpriteNode
        let newNPosition = CGPoint(x: 500 + n!, y: 8)
        let m = Int(arc4random_uniform(3))
        let itemArray: [SKSpriteNode?] = [item, item2, item3]
        let newItem = itemArray[m]?.copy() as! SKSpriteNode
        let newIPosition = CGPoint(x: 600 + m, y: 60)
        let newSeaweed = seaweed.copy() as! SKSpriteNode
        let newSWPosition = CGPoint(x: 600 + n!, y: 60)
        if netSpawnTimer >= 19 {
            if abs(abs(newNPosition.x) - abs(newIPosition.x)) > 50 && abs(abs(newNPosition.x) - abs(newSWPosition.x)) > 50 {
            obstacleLayer.addChild(newNet)
            newNet.position = self.convert(newNPosition, to: obstacleLayer)
            netSpawnTimer = 0
            }
        }
        if itemSpawnTimer >= 11 {
            if abs(abs(newIPosition.x) - abs(newNPosition.x)) > 50 && abs(abs(newIPosition.x) - abs(newSWPosition.x)) > 50 {
            obstacleLayer.addChild(newItem)
            newItem.position = self.convert(newIPosition, to: obstacleLayer)
            newItem.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))
            itemSpawnTimer = 0
            }
        }
        if seaweedSpawnTimer >= 17 {
            if abs(abs(newSWPosition.x) - abs(newNPosition.x)) > 50 && abs(abs(newSWPosition.x) - abs(newIPosition.x)) > 50 {
            obstacleLayer.addChild(newSeaweed)
            newSeaweed.position = self.convert(newSWPosition, to: obstacleLayer)
            newSeaweed.physicsBody?.velocity.dy = CGFloat(-70)
            seaweedSpawnTimer = 0
            }
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
            health += CGFloat(x / 60)
        } else {
            health -= CGFloat(y / 60)
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
        distance = Int(abs(scrollLayer.position.x / 80))
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
        scrollWorld()
        if gameState == .dead {
            playersDeath()
        }
        if gameState == .pause {
            showPauseWindow()
        }
        if gameState == .resume {
            resumeTheGame()
        }
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
        print(gameState)
        }
}
