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
        case running, dead
    }
    enum Obstacle {
        case fishNet, rock, boat, seaweed, none
    }
    var gameState: GameState = .running
    var obstacleKind: Obstacle = .none
    var ground:      SKSpriteNode!
    var ground2:      SKSpriteNode!
    var water:       SKSpriteNode!
    var hero:        SKSpriteNode!
    var deathWindow: SKSpriteNode!
    var restartButton: MSButtonNode!
    var pauseButton:   MSButtonNode!
    var button:        MSButtonNode!
    var highestDistanceScore: SKLabelNode!
    var currentDistanceScore: SKLabelNode!
    var moneyCounterScore:    SKLabelNode!
    var counter3:             SKLabelNode!
    var counter2:             SKLabelNode!
    var counter1:             SKLabelNode!
    var counterStart:         SKLabelNode!
    var deathSigh:            SKLabelNode!
    var scrollLayer:    SKNode!
    var obstacleLayer:  SKNode!
    var obstacleSource: SKNode!
    var obstacleNode:   SKNode?
    let fixedDelta:        CFTimeInterval = 1.0 / 60.0
    var netSpawnTimer:     CFTimeInterval = 0
    var boatSpawnTimer:    CFTimeInterval = 0
    var rockSpawnTimer:    CFTimeInterval = 0
    var seaweedSpawnTimer: CFTimeInterval = 0
    var holding: Bool = false
    var diveForce = 0
    var scrollSpeed: CGFloat = 0
    var maxVelocity: CGFloat = 0
    var minVelocity: CGFloat = 0
    var fishingNet: SKSpriteNode!
    var boat:       SKSpriteNode!
    var rock:       SKSpriteNode!
    var seaweed:    SKSpriteNode!
    var money = 0
    //var oxygen = 100.00
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        ground = childNode(withName: "//ground") as! SKSpriteNode
        ground2 = childNode(withName: "//ground2") as! SKSpriteNode
        water = childNode(withName: "water") as! SKSpriteNode
        hero = childNode(withName: "hero") as! SKSpriteNode
        deathWindow = childNode(withName: "deathWindow") as! SKSpriteNode
        restartButton = childNode(withName: "//restartButton") as! MSButtonNode
        pauseButton = childNode(withName: "pauseButton") as! MSButtonNode
        highestDistanceScore = childNode(withName: "//highestDistanceScore") as! SKLabelNode
        currentDistanceScore = childNode(withName: "//currentDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "//moneyCounterScoreGS") as! SKLabelNode
        counter3 = childNode(withName: "counter3") as! SKLabelNode
        counter2 = childNode(withName: "counter2") as! SKLabelNode
        counter1 = childNode(withName: "counter1") as! SKLabelNode
        counterStart = childNode(withName: "counterStart") as! SKLabelNode
        deathSigh = childNode(withName: "//deathSign") as! SKLabelNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "obstacle")
        fishingNet = childNode(withName: "//fishingNet") as! SKSpriteNode
        boat = childNode(withName: "//boat") as! SKSpriteNode
        rock = childNode(withName: "//rock") as! SKSpriteNode
        seaweed = childNode(withName: "//seaweed") as! SKSpriteNode
        counterStart.isHidden = true
        counter3.isHidden = true
        counter2.isHidden = true
        counter1.isHidden = true
        deathWindow.isHidden = true
        hero.position.x = -236
        scrollSpeed = 80
        diveForce = -40
        maxVelocity = -70
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        buttonFunc(fileName: "//restartButton", direction: "GameScene")
        buttonFunc(fileName: "//restart2Button", direction: "GameScene")
        buttonFunc(fileName: "//pauseButton", direction: "PauseScene")
        buttonFunc(fileName: "//mainMenuButton", direction: "MainMenu")
        buttonFunc(fileName: "//shopButton", direction: "Shop")
        buttonFunc(fileName: "//settingsButton", direction: "Settings")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            obstacleKind = .fishNet
            if contactA.categoryBitMask == 2 {
                obstacleNode = nodeA
            } else {
                obstacleNode = nodeB
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
    }
    
    func playersDeath() {
        if gameState == .dead {
            deathWindow.isHidden = false
            pauseButton.isUserInteractionEnabled = false
            restartButton.isUserInteractionEnabled = false
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            scrollSpeed = 0
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
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            if obstaclePosition.x <= -500 {
                obstacle.removeFromParent()
            }
            
        }
        if netSpawnTimer >= 16 {
            let newNet = fishingNet.copy() as! SKSpriteNode
            obstacleLayer.addChild(newNet)
            let newPosition = CGPoint(x: 400, y: 8)
            newNet.position = self.convert(newPosition, to: obstacleLayer)
            
            netSpawnTimer = 0
        }
        if boatSpawnTimer >= 24 {
            let newBoat = boat.copy() as! SKSpriteNode
            obstacleLayer.addChild(newBoat)
            let newPosition = CGPoint(x: 800, y: 100)
            newBoat.position = self.convert(newPosition, to: obstacleLayer)
            
            boatSpawnTimer = 0
        }
        if rockSpawnTimer >= 6 {
            let newRock = rock.copy() as! SKSpriteNode
            obstacleLayer.addChild(newRock)
            let newPosition = CGPoint(x: 1000, y: 60)
            newRock.position = self.convert(newPosition, to: obstacleLayer)
            newRock.physicsBody?.velocity.dy = CGFloat(-60)
            
            rockSpawnTimer = 0
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
    
   /* func oxygenlvl() {
        if hero.position.y >= 80 {
            oxygen += 1 / 10
            print(oxygen)
        } else {
            oxygen -= 1 / 15
            print(oxygen)
        }
        if oxygen > 100 {
            oxygen = 100
        }
        if oxygen < 0 {
            oxygen = 0
        }
    }*/
    
    func root(){
        switch obstacleKind{
        case .fishNet:
            scrollSpeed = 20
            diveForce = -40/3
            maxVelocity = -70/3
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5/5)
            minVelocity = 70/3
            break
        default:
            scrollSpeed = 60
            diveForce = -40
            maxVelocity = -70
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
            minVelocity = 70
        }
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
        playersDeath()
        scrollWorld()
        netSpawnTimer += fixedDelta
        boatSpawnTimer += fixedDelta
        rockSpawnTimer += fixedDelta
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
        //oxygenlvl()
       // currentDistanceScore.text = String(Int(oxygen))
       // if oxygen == 0 {
         //   gameState = .dead
        //}

    }
}
