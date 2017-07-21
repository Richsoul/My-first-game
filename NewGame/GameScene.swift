//
//  GameScene.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit
import GameplayKit

class SharedData {
    static let data = SharedData()
    var high: Int {
        get {
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        set(high) {
            UserDefaults.standard.set(high, forKey: "highScore")
        }
    }
    var current = 0
    var money: Int {
        get {
            return UserDefaults.standard.integer(forKey: "money")
        }
        set(money) {
            UserDefaults.standard.set(money, forKey: "money")
        }
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    enum GameState {
        case running, dead
    }
    enum Obstacle {
        case fishNet, boat, seaweed, none
    }
    let sData = SharedData.data
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
    var highestDistanceScore2: SKLabelNode!
    var currentDistanceScore2: SKLabelNode!
    var moneyCounterScore2:    SKLabelNode!
    var scrollLayer:    SKNode!
    var shallowLayer:   SKNode!
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
    var maxVelocity: CGFloat = 0
    var minVelocity: CGFloat = 0
    var fishingNet: SKSpriteNode!
    var boat1:       SKSpriteNode!
    var seaweed:    SKSpriteNode!
    var oxygen = 100.00
    var x = 0.08
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
    let float2 = SKAction(named: "float")
    let dive = SKAction(named: "dive")
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        water = childNode(withName: "water") as! SKSpriteNode
        hero = childNode(withName: "hero") as! SKSpriteNode
        pauseWindow = childNode(withName: "pauseWindow") as! SKSpriteNode
        oxygenLvl = childNode(withName: "oxygenLvl") as! SKSpriteNode
        pauseButton = childNode(withName: "pauseButton") as! MSButtonNode
        resume = childNode(withName: "//resumeButton") as! MSButtonNode
        highestDistanceScore = childNode(withName: "highestDistanceScore") as! SKLabelNode
        currentDistanceScore = childNode(withName: "currentDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "moneyCounterScore") as! SKLabelNode
        highestDistanceScore2 = childNode(withName: "//highestDistanceScore2") as! SKLabelNode
        currentDistanceScore2 = childNode(withName: "//currentDistanceScore2") as! SKLabelNode
        moneyCounterScore2 = childNode(withName: "//moneyCounterScore2") as! SKLabelNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        shallowLayer = self.childNode(withName: "shallowLayer")
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
        hero.position.x = -175
        scrollSpeed = 60
        diveForce = -40
        maxVelocity = -70
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        pause = childNode(withName: "//pauseButton") as! MSButtonNode
        pause.selectedHandler = {
            self.pauseWindow.isHidden = false
            self.isPaused = true
        }
        resume.selectedHandler = {
            self.pauseWindow.isHidden = true
            self.isPaused = false
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
            if contactA.categoryBitMask == 1 || contactB.categoryBitMask == 1 {
                //let moneyArray = [item, item2, item3]
                if contactA.categoryBitMask == 8 {
                    //for n in 0...2 {
                    //    if nodeA == moneyArray[n] {
                    //         money.money += n
                    //    }
                    //}
                    if nodeA.name == "item" {
                        sData.money += 1
                    } else if nodeA.name == "item2" {
                        sData.money += 2
                    } else if nodeA.name == "item3" {
                        sData.money += 3
                    }
                    nodeA.removeFromParent()
                    
                } else {
                    //for n in 0...2 {
                    //    if nodeB == moneyArray[n] {
                    //        money.money += n
                    //    }
                    //    }
                    if nodeB.name == "item" {
                        sData.money += 1
                    } else if nodeB.name == "item2" {
                        sData.money += 2
                    } else if nodeB.name == "item3" {
                        sData.money += 3
                    }
                    nodeB.removeFromParent()
                }
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
        if contactA.categoryBitMask == 64 || contactB.categoryBitMask == 64 {
            hero.physicsBody?.applyImpulse(CGVector(dx:0, dy: -13))
            health -= 0.025
        }
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
    func scrollShallow() {
        shallowLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for shallowNode in shallowLayer.children as! [SKSpriteNode] {
            if shallowNode.position.x <= -1000 {
                shallowNode.removeFromParent()
            }
        }
    }
    
    func updateBoat() {
        boatLayer.position.x -= (scrollSpeed + 100) * CGFloat(fixedDelta)
        for boat in boatLayer.children as! [SKSpriteNode] {
            
            let boatPosition = boatLayer.convert(boat.position, to: self)
            if boatPosition.x <= -550 {
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
        let newIPosition = CGPoint(x: 600 + n!, y: 60)
        let newSeaweed = seaweed.copy() as! SKSpriteNode
        let newSWPosition = CGPoint(x: 600 + n!, y: 60)
        if netSpawnTimer >= 20 {
            //if abs(abs(newNPosition.x) - abs(newIPosition.x)) > 50 && abs(abs(newNPosition.x) - abs(newSWPosition.x)) > 50 {
            obstacleLayer.addChild(newNet)
            newNet.position = self.convert(newNPosition, to: obstacleLayer)
            netSpawnTimer = 0
            //}
        }
        if itemSpawnTimer >= 10 {
            //if abs(abs(newIPosition.x) - abs(newNPosition.x)) > 50 && abs(abs(newIPosition.x) - abs(newSWPosition.x)) > 50 {
            obstacleLayer.addChild(newItem)
            newItem.position = self.convert(newIPosition, to: obstacleLayer)
            newItem.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))
            itemSpawnTimer = 0
            //}
        }
        if seaweedSpawnTimer >= 15 {
            //if abs(abs(newSWPosition.x) - abs(newNPosition.x)) > 50 && abs(abs(newSWPosition.x) - abs(newIPosition.x)) > 50 {
            obstacleLayer.addChild(newSeaweed)
            newSeaweed.position = self.convert(newSWPosition, to: obstacleLayer)
            newSeaweed.physicsBody?.velocity.dy = CGFloat(-70)
            seaweedSpawnTimer = 0
            //}
        }
    }
    
    func buttonFunc(fileName: String, direction: String) {
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
        if hero.position.x < -175 {
            hero.physicsBody?.applyForce(CGVector(dx: 10, dy:0))
        } else {
            hero.position.x = -175
        }
        if hero.position.x == -175 {
            hero.physicsBody?.velocity.dx = 0
        }
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
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -1.3)
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
        sData.current = Int(abs(scrollLayer.position.x / 70))
        currentDistanceScore.text = String(sData.current)
        currentDistanceScore2.text = String(sData.current)
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
        scrollShallow()
        if hero.position.x < -350 {
            playersDeath()
        }
        if gameState == .dead {
            playersDeath()
        }
        netSpawnTimer += fixedDelta
        boatSpawnTimer += fixedDelta
        itemSpawnTimer += fixedDelta
        seaweedSpawnTimer += fixedDelta
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        if holding == true {
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: diveForce))
            hero.run(dive!)
            if velocityY < maxVelocity {
                hero.physicsBody?.velocity.dy = maxVelocity
            }
        } else {
            hero.run(float2!)
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
        moneyCounterScore.text = String(sData.money)
        oxygenlvl()
        if sData.current > sData.high {
            sData.high = sData.current
        }
        highestDistanceScore.text = String(sData.high)
        highestDistanceScore2.text = String(sData.high)
    }
}
