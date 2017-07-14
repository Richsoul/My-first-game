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
        case start, running, pause, dead, mainMenu
    }
    enum Obstacle {
        case fishNet, rock, boat, seaweed, none
    }
    enum HeroState {
        case rooted, swimming
    }
    var gameState: GameState = .running
    var heroState: HeroState = .swimming
    var obstacleKind: Obstacle = .none
    var ground:      SKSpriteNode!
    var ground2:      SKSpriteNode!
    var water:       SKSpriteNode!
    var hero:        SKSpriteNode!
    var deathWindow: SKSpriteNode!
    var restartButton: MSButtonNode!
    var pauseButton:   MSButtonNode!
    var button: MSButtonNode!
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
    var scrollSpeed: CGFloat = 80
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var spawnTimer: CFTimeInterval = 3
    var rootTime: CFTimeInterval = 0
    var holding: Bool = false
    var diveForce = -40
    var maxVelocity: CGFloat = -70
    var fishingNet: SKSpriteNode!
    var net1: SKNode!
    var net2: SKNode!
    var net3: SKNode!
    
    override func didMove(to view: SKView) {
        
        gameState = .start
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
        moneyCounterScore = childNode(withName: "//moneyCounterScore") as! SKLabelNode
        counter3 = childNode(withName: "counter3") as! SKLabelNode
        counter2 = childNode(withName: "counter2") as! SKLabelNode
        counter1 = childNode(withName: "counter1") as! SKLabelNode
        counterStart = childNode(withName: "counterStart") as! SKLabelNode
        deathSigh = childNode(withName: "//deathSign") as! SKLabelNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "obstacle")
        fishingNet = childNode(withName: "//fishingNet") as! SKSpriteNode
        net1 = childNode(withName: "//net1")!
        net2 = childNode(withName: "//net2")!
        net3 = childNode(withName: "//net3")!
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
        /* Physics contact delegate implementation */
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        /* Check if either physics bodies was a seal */
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            rootTime = 0
            obstacleKind = .fishNet
                scrollSpeed = 20
                diveForce = -40/3
                maxVelocity = -70/3
                scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5/5)
           
        }
        
    }
    
    
    /* override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     } */
    
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
            if obstaclePosition.x <= -260 {
                obstacle.removeFromParent()
            }
            
        }
        /*if spawnTimer >= 1.5 {
            
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            let randomPosition = CGPoint(x: 352, y: CGFloat.random(min: 234, max: 382))
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            spawnTimer = 0
        }*/
    }


    
    func buttonFunc(fileName: String, direction: String) { //custom button transfer, for any situation я горд собой
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
        /* if direction == "GameScene" {
         scrollSpeed = 100
         } */
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
        if holding == true {
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: diveForce))
            let velocityY = hero.physicsBody?.velocity.dy ?? 0
            if velocityY < maxVelocity {
                hero.physicsBody?.velocity.dy = maxVelocity
            }
        }
        if obstacleKind == .fishNet {
        rootTime += 1.0/60.0
            if rootTime > 5 {
                scrollSpeed = 80
                diveForce = -40
                maxVelocity = -70
                scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
                obstacleKind = .none
            }
            print(rootTime)
        }
    }
}
