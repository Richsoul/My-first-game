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
    var boost: Int {
        get {
            return UserDefaults.standard.integer(forKey: "boost")
        }
        set(boost) {
            UserDefaults.standard.set(money, forKey: "boost")
        }
    }
    var ivul: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ivul")
        }
        set(ivul) {
            UserDefaults.standard.set(money, forKey: "ivul")
        }
    }
}
extension SKNode {
    var positionInScene:CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to:scene)
        } else {
            return nil
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
    enum Hook {
        case connect, noconnect
    }
    let sData = SharedData.data
    var gameState: GameState = .running
    var obstacleKind: Obstacle = .none
    var hookState: Hook = .noconnect
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
    var obstacleNode:   SKNode!
    var fisherBoat:     SKNode!
    var fixedDelta:        CFTimeInterval = 1.0 / 60.0
    var netSpawnTimer:     CFTimeInterval = 4
    var boatSpawnTimer:    CFTimeInterval = 14
    var itemSpawnTimer:    CFTimeInterval = 6
    var seaweedSpawnTimer: CFTimeInterval = 10
    var timer:             CFTimeInterval = 0
    var holding: Bool = false
    var diveForce = 0
    var fishBoatSpeed: CGFloat!
    var scrollSpeed: CGFloat!
    var x: CGFloat = 75
    var maxVelocity: CGFloat!
    let y = -40
    var minVelocity: CGFloat!
    let z: CGFloat = -70
    var fishingNet: SKSpriteNode!
    var boat1:      SKSpriteNode!
    var seaweed:    SKSpriteNode!
    var fisher:     SKSpriteNode!
    var oxygen = 100.00
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
    var timer2: CFTimeInterval = 14.97
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
        fisherBoat = self.childNode(withName: "fisherBoat")
        fishingNet = childNode(withName: "//fishingNet") as! SKSpriteNode
        boat1 = childNode(withName: "//boat") as! SKSpriteNode
        seaweed = childNode(withName: "//seaweed") as! SKSpriteNode
        fisher = childNode(withName: "//origin") as! SKSpriteNode
        item = childNode(withName: "//item") as! SKSpriteNode
        item2 = childNode(withName: "//item2") as! SKSpriteNode
        item3 = childNode(withName: "//item3") as! SKSpriteNode
        pauseWindow.isHidden = true
        hero.position.x = -175
        scrollSpeed = x
        fishBoatSpeed = x
        diveForce = y
        maxVelocity = z
        minVelocity = -z
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        pause = childNode(withName: "//pauseButton") as! MSButtonNode
        pause.selectedHandler = {[unowned self] in
            self.pauseWindow.isHidden = false
            self.isPaused = true
        }
        resume.selectedHandler = {[unowned self] in
            self.pauseWindow.isHidden = true
            self.isPaused = false
        }
        buttonFunc(fileName: "//restartButton", direction: "GameScene")
        buttonFunc(fileName: "//mainMenuButton", direction: "MainMenu")
        
    }
    
    func particleEffect(node:SKSpriteNode) {
        let particles1 = SKEmitterNode(fileNamed: "emitter1")!
        let particles2 = SKEmitterNode(fileNamed: "emitter2")!
        let particles3 = SKEmitterNode(fileNamed: "emitter3")!
        let wait = SKAction.wait(forDuration: 3)
        let removeParticles = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait, removeParticles])
        let positionInScene  = node.positionInScene
        switch node.name{
        case "item"?:
            addChild(particles1)
            particles1.position = positionInScene!
            particles1.run(seq)
            sData.money += 1
        case "item2"?:
            addChild(particles2)
            particles2.position = positionInScene!
            particles2.run(seq)
            sData.money += 2
        case "item3"?:
            addChild(particles3)
            particles3.position = positionInScene!
            particles3.run(seq)
            sData.money += 3
        default:
            break
        }
        node.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        var hero: SKSpriteNode!
        if contactA.categoryBitMask == 1 {
            hero = nodeA
        } else if contactB.categoryBitMask == 1 {
            hero = nodeB
        }
        var seaweed: SKSpriteNode!
        if contactA.categoryBitMask == 16 {
            seaweed = nodeA
        } else if contactB.categoryBitMask == 16 {
            seaweed = nodeB
        }
        var item: SKSpriteNode!
        if contactA.categoryBitMask == 8 {
            item = nodeA
        } else if contactB.categoryBitMask == 8 {
            item = nodeB
        }
        var ground: SKSpriteNode!
        if contactA.categoryBitMask == 32 {
            ground = nodeA
        } else if contactB.categoryBitMask == 32 {
            ground = nodeB
        }
        var fishNet: SKSpriteNode!
        if contactA.categoryBitMask == 2 {
            fishNet = nodeA
        } else if contactB.categoryBitMask == 2 {
            fishNet = nodeB
        }
        var boat: SKSpriteNode!
        if contactA.categoryBitMask == 64 {
            boat = nodeA
        } else if contactA.categoryBitMask == 64 {
            boat = nodeB
        }
        var hook: SKSpriteNode!
        if contactA.categoryBitMask == 128 {
            hook = nodeA
        } else if contactB.categoryBitMask == 128 {
            hook = nodeB
        }
        
        
        
        if let seaweed = seaweed {
            if hero != nil {
                obstacleKind = .seaweed
            }
            if ground != nil {
                seaweed.physicsBody?.isDynamic = false
            }
        }
        if let hero = hero {
            if let item = item {
                particleEffect(node: item)
            }
            if let fishNet = fishNet {
                obstacleKind = .fishNet
                obstacleNode = fishNet
                fishNet.isHidden = true
            }
            if boat != nil {
                hero.physicsBody?.applyImpulse(CGVector(dx:0, dy: -13))
                health -= 0.05
            }
            if let hook = hook {
                hookState = .connect
                hero.move(toParent: hook)
            }
        }
    }
    
    func playersDeath() {
        if let scene = SKScene(fileNamed: "DeathScene") {
            scene.scaleMode = .aspectFit
            view?.presentScene(scene)
        }
    }
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint) {
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
            obstacleLayer.addChild(newNet)
            newNet.position = self.convert(newNPosition, to: obstacleLayer)
            netSpawnTimer = 0
        }
        if itemSpawnTimer >= 10 {
            obstacleLayer.addChild(newItem)
            newItem.position = self.convert(newIPosition, to: obstacleLayer)
            newItem.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))
            itemSpawnTimer = 0
        }
        if seaweedSpawnTimer >= 15 {
            obstacleLayer.addChild(newSeaweed)
            newSeaweed.position = self.convert(newSWPosition, to: obstacleLayer)
            newSeaweed.physicsBody?.velocity.dy = CGFloat(-70)
            seaweedSpawnTimer = 0
        }
    }
    
    func fisherBoatFunc() {
        fisherBoat.position.x -= fishBoatSpeed * CGFloat(fixedDelta)
        
        for fishingRod in fisherBoat.children as! [SKSpriteNode] {
            
            let obstaclePosition = obstacleLayer.convert(fishingRod.position, to: self)
            if hookState == .connect {
                fishingRod.physicsBody?.applyForce(CGVector(dx: 0, dy: 20))
            }
            if obstaclePosition.x <= -320 {
                fishingRod.removeFromParent()
            }
            
        }
        let randomArray: [CGFloat?] = [-100, -50, 0, 50, 100]
        let n = randomArray[Int(arc4random_uniform(4))]
        let newHook = fisher.copy() as! SKSpriteNode
        let newHPosition = CGPoint(x: 600 + n!, y: 305)
        if boatSpawnTimer > 14.01 && boatSpawnTimer < 14.03 {
            obstacleLayer.addChild(newHook)
            newHook.position = self.convert(newHPosition, to: obstacleLayer)
            newHook.physicsBody?.velocity.dy = CGFloat(-70)
        }
    }
    
    func buttonFunc(fileName: String, direction: String) {
        button = childNode(withName: "\(fileName)") as! MSButtonNode
        button.selectedHandler = {[unowned self] in 
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
            if (hero.physicsBody?.velocity.dx)! > CGFloat(13) {
                hero.physicsBody?.velocity.dx = 13
                
            }
            
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
            health += CGFloat(0.24 / 60)
        } else {
            health -= CGFloat(0.08 / 60)
        }
    }
    
    func root(){
        switch obstacleKind{
        case .seaweed:
            scrollSpeed = x/3
            diveForce = y/3
            maxVelocity = z/3
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5/5)
            minVelocity = -z/3
            break
        case .fishNet:
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -1.3)
            minVelocity = 0
            break
        default:
            scrollSpeed = x
            diveForce = y
            maxVelocity = z
            scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
            minVelocity = -z
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
        if hero.parent == self {
            float()
        }
        updateObstacles()
        updateBoat()
        updateDistance()
        scrollWorld()
        scrollShallow()
        fisherBoatFunc()
        timer += fixedDelta
        if timer - timer2 >= 1 && Int(timer.truncatingRemainder(dividingBy: 15)) == 0{
            print(timer, timer2)
                x += 2.5
                print(x)
            timer2 += 15
        }
        if hero.position.x < -350 {
            playersDeath()
        }
        if gameState == .dead {
            playersDeath()
        }
        netSpawnTimer += fixedDelta * CFTimeInterval(x/60)
        boatSpawnTimer += fixedDelta
        itemSpawnTimer += fixedDelta * CFTimeInterval(x/60)
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
        if hookState == .connect {
            if hero.parent!.convert(hero.position, to: self).y < -10 {
                hookState = .noconnect
                hero.move(toParent: self)
            }
        }
        root()
        if let obstacle = obstacleNode {
            if !obstacle.intersects(hero) {
                obstacleKind = .none
                obstacleNode = nil
            }
        }
        moneyCounterScore.text = String(sData.money)
        moneyCounterScore2.text = String(sData.money)
        oxygenlvl()
        if sData.current > sData.high {
            sData.high = sData.current
        }
        highestDistanceScore2.text = String(sData.high)
    }
}
