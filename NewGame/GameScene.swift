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
            if User.loggedIn {
                UserService.setCoins(User.current, coins: money)
                UserService.show(forUID: User.current.uid) { user in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)
                    }
                }
            }
        }
    }
    var refill: Int {
        get {
            return UserDefaults.standard.integer(forKey: "refill")
        }
        set(refill) {
            UserDefaults.standard.set(refill, forKey: "refill")
        }
    }
    var ivul: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ivul")
        }
        set(ivul) {
            UserDefaults.standard.set(ivul, forKey: "ivul")
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
    var fishingNet:   SKSpriteNode!
    var boat1:        SKSpriteNode!
    var seaweed:      SKSpriteNode!
    var fisher:       SKSpriteNode!
    var pause:     MSButtonNode!
    var resume:    MSButtonNode!
    var refill:    MSButtonNode!
    var ivul:      MSButtonNode!
    var currentDistanceScore:  SKLabelNode!
    var moneyCounterScore:     SKLabelNode!
    var highestDistanceScore2: SKLabelNode!
    var currentDistanceScore2: SKLabelNode!
    var moneyCounterScore2:    SKLabelNode!
    var countDown:             SKLabelNode!
    var refCounter:            SKLabelNode!
    var ivulCounter:           SKLabelNode!
    var currentDistanceLabel:  SKLabelNode!
    var moneyCounterLabel:     SKLabelNode!
    var scrollLayer:    SKNode!
    var shallowLayer:   SKNode!
    var boatLayer:      SKNode!
    var obstacleLayer:  SKNode!
    var obstacleSource: SKNode!
    var obstacleNode:   SKNode!
    var fisherBoat:     SKNode!
    var waves:          SKNode!
    var background:     SKNode!
    var middleground:   SKNode!
    var foreground:     SKNode!
    var netSpawnTimer:     CFTimeInterval = 4
    var boatSpawnTimer:    CFTimeInterval = 14
    var itemSpawnTimer:    CFTimeInterval = 6
    var seaweedSpawnTimer: CFTimeInterval = 10
    var timer:             CFTimeInterval = 0
    var refillTimer:       CFTimeInterval = 0
    var ivulTimer:         CFTimeInterval = 0
    var deltaTime:         TimeInterval   = 0
    var lastTime:          TimeInterval?
    var holding: Bool = false
    var refillPU: Bool = false
    var ivulPU: Bool = false
    var diveForce = 0
    var fishBoatSpeed: CGFloat!
    var scrollSpeed:   CGFloat!
    var x:             CGFloat = 75
    var maxVelocity:   CGFloat!
    let y = -40
    var minVelocity:   CGFloat!
    let z:             CGFloat = -70
    var oxygen = 100.00
    var health:        CGFloat = 1.0 {
        didSet {
            oxygenLvl.xScale = health
            if health > 1.0 { health = 1.0 }
            if health < 0.15 {
                
            }
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
        water =       childNode(withName: "water")        as! SKSpriteNode
        hero =        childNode(withName: "hero")         as! SKSpriteNode
        pauseWindow = childNode(withName: "pauseWindow")  as! SKSpriteNode
        oxygenLvl =   childNode(withName: "oxygenLvl")    as! SKSpriteNode
        fishingNet =  childNode(withName: "//fishingNet") as! SKSpriteNode
        fisher =      childNode(withName: "//origin")     as! SKSpriteNode
        boat1 =       childNode(withName: "//boat")       as! SKSpriteNode
        seaweed =     childNode(withName: "//seaweed")    as! SKSpriteNode
        item =        childNode(withName: "//item")       as! SKSpriteNode
        item2 =       childNode(withName: "//item2")      as! SKSpriteNode
        item3 =       childNode(withName: "//item3")      as! SKSpriteNode
        refill =      childNode(withName: "refill")         as! MSButtonNode
        ivul =        childNode(withName: "ivulnerable")    as! MSButtonNode
        resume =      childNode(withName: "//resumeButton") as! MSButtonNode
        currentDistanceScore =  childNode(withName: "currentDistanceScore")     as! SKLabelNode
        moneyCounterScore =     childNode(withName: "moneyCounterScore")        as! SKLabelNode
        countDown =             childNode(withName: "//countDown")              as! SKLabelNode
        refCounter =            childNode(withName: "//refCount")               as! SKLabelNode
        ivulCounter =           childNode(withName: "//ivulCount")              as! SKLabelNode
        highestDistanceScore2 = childNode(withName: "//highestDistanceScore2")  as! SKLabelNode
        currentDistanceScore2 = childNode(withName: "//currentDistanceScore2")  as! SKLabelNode
        moneyCounterScore2 =    childNode(withName: "//moneyCounterScore2")     as! SKLabelNode
        moneyCounterLabel = self.childNode(withName: "moneyCounterLabel")       as! SKLabelNode
        currentDistanceLabel = self.childNode(withName: "currentDistanceLabel") as! SKLabelNode!
        scrollLayer =    self.childNode(withName: "scrollLayer")
        shallowLayer =   self.childNode(withName: "shallowLayer")
        boatLayer =      self.childNode(withName: "boatLayer")
        obstacleLayer =  self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "obstacle")
        fisherBoat =     self.childNode(withName: "fisherBoat")
        waves =          self.childNode(withName: "waves")
        background =     self.childNode(withName: "BG")
        middleground =   self.childNode(withName: "MG")
        foreground =     self.childNode(withName: "FG")
        buttonFunc(fileName: "//restartButton", direction: "GameScene")
        buttonFunc(fileName: "//mainMenuButton", direction: "MainMenu")
        pauseWindow.isHidden = true
        countDown.isHidden = true
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 1.5)
        pause = childNode(withName: "//pauseButton") as! MSButtonNode
        pause.selectedHandler = {[unowned self] in
            self.pauseWindow.isHidden = false
            self.isPaused = true
            self.pause.isHidden = true
            self.oxygenLvl.isHidden = true
            self.currentDistanceScore.isHidden = true
            self.moneyCounterScore.isHidden = true
            self.currentDistanceLabel.isHidden = true
            self.moneyCounterLabel.isHidden = true
        }
        resume.selectedHandler = {[unowned self] in
            self.pauseWindow.isHidden = true
            self.isPaused = false
            self.pause.isHidden = false
            self.oxygenLvl.isHidden = false
            self.currentDistanceScore.isHidden = false
            self.moneyCounterScore.isHidden = false
            self.currentDistanceLabel.isHidden = false
            self.moneyCounterLabel.isHidden = false
        }
        refill.selectedHandler = {[unowned self] in
            if self.sData.refill > 0 {
                self.refillPU = true
                self.sData.refill -= 1
            }
        }
        ivul.selectedHandler = {[unowned self] in
            if self.sData.ivul > 0 {
                self.ivulPU = true
                self.countDown.isHidden = false
                self.sData.ivul -= 1
            }
        }
        hero.position.x = -175
        scrollSpeed = x
        fishBoatSpeed = x
        diveForce = y
        maxVelocity = z
        minVelocity = -z
    }//override func didMove
    
    func particleEffect(node:SKSpriteNode) {
        let particles1 = SKEmitterNode(fileNamed: "emitter1")!
        let particles2 = SKEmitterNode(fileNamed: "emitter2")!
        let particles3 = SKEmitterNode(fileNamed: "emitter3")!
        let wait = SKAction.wait(forDuration: 3)
        let removeParticles = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait, removeParticles])
        let positionInScene = node.positionInScene
        if positionInScene != nil {
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
        }
        node.removeFromParent()
    }//particleEffect()
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        guard let nodeA = contactA.node as? SKSpriteNode else {
            return
        }
        guard let nodeB = contactB.node as? SKSpriteNode else {
            return
        }
        
        var diver: SKSpriteNode!
        if contactA.categoryBitMask == 1 {
            diver = nodeA
        } else if contactB.categoryBitMask == 1 {
            diver = nodeB
        }
        var fishNet: SKSpriteNode!
        if contactA.categoryBitMask == 2 {
            fishNet = nodeA
        } else if contactB.categoryBitMask == 2 {
            fishNet = nodeB
        }
        var itemNode: SKSpriteNode!
        if contactA.categoryBitMask == 8 {
            itemNode = nodeA
        } else if contactB.categoryBitMask == 8 {
            itemNode = nodeB
        }
        var seaweed: SKSpriteNode!
        if contactA.categoryBitMask == 16 {
            seaweed = nodeA
        } else if contactB.categoryBitMask == 16 {
            seaweed = nodeB
        }
        var ground: SKSpriteNode!
        if contactA.categoryBitMask == 32 {
            ground = nodeA
        } else if contactB.categoryBitMask == 32 {
            ground = nodeB
        }
        var boat: SKSpriteNode!
        if contactA.categoryBitMask == 64 {
            boat = nodeA
        } else if contactB.categoryBitMask == 64 {
            boat = nodeB
        }
        var hook: SKSpriteNode!
        if contactA.categoryBitMask == 128 {
            hook = nodeA
            print(contactB.categoryBitMask)
        } else if contactB.categoryBitMask == 128 {
            hook = nodeB
            print(contactA.categoryBitMask)
        }
        
        
        
        if let seaweed = seaweed {
            if diver != nil {
               // if ivulPU == false {
                    obstacleKind = .seaweed
                    obstacleNode = seaweed
                //}
            }
            if ground != nil {
                seaweed.physicsBody?.isDynamic = false
            }
        }
        if diver != nil {
            if itemNode != nil {
                particleEffect(node: itemNode)
            }
            if let fishNet = fishNet {
               // if ivulPU == false {
                    obstacleKind = .fishNet
                    obstacleNode = fishNet
                    fishNet.isHidden = true
               // }
            }
            if boat != nil {
               // if ivulPU == false {
                    diver.physicsBody?.applyImpulse(CGVector(dx:0, dy: -13))
                    health -= 0.05
               //}
            }
            if let hook = hook {
                //if ivulPU == false {
                    hookState = .connect
                    hero.move(toParent: hook)
                    hook.physicsBody?.applyForce(CGVector(dx:0, dy: 20))
                    fishBoatSpeed = 20
                //}
            }
        }
    }//didBegin()
    
    func playersDeath() {
        if let scene = SKScene(fileNamed: "DeathScene") {
            scene.scaleMode = .aspectFit
            view?.presentScene(scene)
        }
    }//playersDeath()
    func scrollWorld() {
        scrollLayer.position.x -= scrollSpeed * CGFloat(deltaTime)
        for ground in scrollLayer.children as! [SKSpriteNode] {
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            if groundPosition.x <= -ground.size.width / 2 - 510{
                let rightmostNode = scrollLayer.children.sorted(by: {node1, node2 in node1.position.x > node2.position.x}).first as! SKSpriteNode
                let rightmostPosition = scrollLayer.convert(rightmostNode.position, to: self)
                let newPosition = CGPoint(x: rightmostPosition.x + rightmostNode.size.width, y: groundPosition.y)
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }//scrollWorld()
    func scrollShallow() {
        shallowLayer.position.x -= scrollSpeed * CGFloat(deltaTime)
        for shallowNode in shallowLayer.children as! [SKSpriteNode] {
            if shallowNode.position.x <= -1000 {
                shallowNode.removeFromParent()
            }
        }
    }//scrollShallow()
    func scrollBG() {
        background.position.x -= (scrollSpeed / 4) * CGFloat(deltaTime)
        for BG in background.children as! [SKSpriteNode] {
            let BGPosition = background.convert(BG.position, to: self)
            if BGPosition.x <= -497 {
                let rightmostNode = background.children.sorted(by: {node1, node2 in node1.position.x > node2.position.x}).first as! SKSpriteNode
                let rightmostPosition = background.convert(rightmostNode.position, to: self)
                let newPosition = CGPoint(x: rightmostPosition.x + rightmostNode.size.width, y: 115.01)
                BG.position = self.convert(newPosition, to: background)
            }
        }
    }//scrollBG()
    
    func scrollMG() {
        middleground.position.x -= (scrollSpeed / 3) * CGFloat(deltaTime)
        for MG in middleground.children as! [SKSpriteNode] {
            let MGPosition = middleground.convert(MG.position, to: self)
            if MGPosition.x <= -668 {
                let rightmostNode = middleground.children.sorted(by: {node1, node2 in node1.position.x > node2.position.x}).first as! SKSpriteNode
                let rightmostPosition = middleground.convert(rightmostNode.position, to: self)
                let newPosition = CGPoint(x: rightmostPosition.x + rightmostNode.size.width, y: -95)
                MG.position = self.convert(newPosition, to: middleground)
            }
        }
    }//scrollMG
    
    func scrollFG() {
        foreground.position.x -= (scrollSpeed / 2) * CGFloat(deltaTime)
        for FG in foreground.children as! [SKSpriteNode] {
            let FGPosition = foreground.convert(FG.position, to: self)
            if FGPosition.x <= -681 {
                let rightmostNode = foreground.children.sorted(by: {node1, node2 in node1.position.x > node2.position.x}).first as! SKSpriteNode
                let rightmostPosition = foreground.convert(rightmostNode.position, to: self)
                let newPosition = CGPoint(x: rightmostPosition.x + rightmostNode.size.width, y: -105.5)
                FG.position = self.convert(newPosition, to: foreground)
            }
        }
    }//scrollFG
    
    func updateBoat() {
        boatLayer.position.x -= (scrollSpeed + 100) * CGFloat(deltaTime)
        for boat in boatLayer.children as! [SKSpriteNode] {
            
            let boatPosition = boatLayer.convert(boat.position, to: self)
            if boatPosition.x <= -550 {
                boat.removeFromParent()
            }
        }
        if boatSpawnTimer >= 24 {
            let newBoat = boat1.copy() as! SKSpriteNode
            boatLayer.addChild(newBoat)
            let newPosition = CGPoint(x: 2121.5, y: 140)
            newBoat.position = self.convert(newPosition, to: boatLayer)
            boatSpawnTimer = 0
        }
    }//updateBoat()
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(deltaTime)
        
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            if obstaclePosition.x <= -320 {
                obstacle.removeFromParent()
            }
            
        }
        let randomArray: [CGFloat?] = [-200, -100, 0, 100, 200]
        let n = randomArray[Int(arc4random_uniform(4))]!
        let newNet = fishingNet.copy() as! SKSpriteNode
        let newNPosition = CGPoint(x: 800 + n, y: -30)
        let m = Int(arc4random_uniform(3))
        let itemArray: [SKSpriteNode?] = [item, item2, item3]
        let newItem = itemArray[m]?.copy() as! SKSpriteNode
        let newIPosition = CGPoint(x: 800 + n, y: 28)
        let newSeaweed = seaweed.copy() as! SKSpriteNode
        let newSWPosition = CGPoint(x: 800 + n, y: 28)
        if netSpawnTimer >= 20 {
            obstacleLayer.addChild(newNet)
            newNet.position = self.convert(newNPosition, to: obstacleLayer)
            netSpawnTimer = 0
        }
        if itemSpawnTimer >= 10 {
            obstacleLayer.addChild(newItem)
            newItem.position = self.convert(newIPosition, to: obstacleLayer)
            newItem.physicsBody?.applyForce(CGVector(dx: 0, dy: -30))
            itemSpawnTimer = 0
        }
        if seaweedSpawnTimer >= 15 {
            obstacleLayer.addChild(newSeaweed)
            newSeaweed.position = self.convert(newSWPosition, to: obstacleLayer)
            newSeaweed.physicsBody?.velocity.dy = CGFloat(-70)
            seaweedSpawnTimer = 0
        }
    }//updateObstacles()
    
    func waveFunc() {
        waves.position.x -= scrollSpeed * CGFloat(deltaTime)
        for wave in waves.children as! [SKSpriteNode] {
            let wavePosition = waves.convert(wave.position, to: self)
            let limit = (scene?.size.width)!/2 + wave.size.width / 2
            if wavePosition.x <= -limit {
                let rightmostNode = waves.children.filter({node in waves.convert(node.position, to: self).y == wavePosition.y}).sorted(by: {node1, node2 in node1.position.x > node2.position.x}).first as! SKSpriteNode
                let rightmostPosition = waves.convert(rightmostNode.position, to: self)
                let newPosition = CGPoint(x: rightmostPosition.x + rightmostNode.size.width, y: wavePosition.y)
                wave.position = self.convert(newPosition, to: waves)
            }
        }
    }//waveFunc()
    func fisherBoatFunc() {
        fisherBoat.position.x -= fishBoatSpeed * CGFloat(deltaTime)
        for fishingRod in fisherBoat.children as! [SKSpriteNode] {
            let obstaclePosition = fisherBoat.convert(fishingRod.position, to: self)
            if obstaclePosition.x <= -320 {
                fishingRod.removeFromParent()
            }
        }
        let randomArray: [CGFloat?] = [-200, -100, 0, 100, 200]
        let n = randomArray[Int(arc4random_uniform(4))]!
        let newHook = fisher.copy() as! SKSpriteNode
        let newHPosition = CGPoint(x: 600 + n, y: 300)
        if boatSpawnTimer > 14.29 && boatSpawnTimer < 14.31 {
            obstacleLayer.addChild(newHook)
            newHook.position = self.convert(newHPosition, to: fisherBoat)
        }
        
    }//fisherBoatFunc()
    func buttonFunc(fileName: String, direction: String) {
        let button = childNode(withName: "\(fileName)") as! MSButtonNode
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
    }//buttonFunc()
    
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
    }//float()
    
    func oxygenlvl() {
        if hero.position.y >= 30 {
            health += CGFloat(0.24 / 60)
        } else {
            if refillPU == false {
                health -= CGFloat(0.08 / 60)
            }
        }
    }//oxygenlvl()
    
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
    }//root()
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
        if let old = lastTime {
            deltaTime = currentTime - old
        }
        updateObstacles()
        updateBoat()
        updateDistance()
        scrollWorld()
        scrollShallow()
        fisherBoatFunc()
        waveFunc()
        oxygenlvl()
        scrollBG()
        scrollFG()
        scrollMG()
        if hero.parent == self {
            float()
        }
        if gameState == .dead {
            playersDeath()
        }
        if hero.parent != nil {
            if hero.parent!.convert(hero.position, to: self).x < -340 {
                playersDeath()
            }
        }
        if ivulPU == true {
            ivulTimer += deltaTime
            switch Int(ivulTimer) {
            case 0:
                countDown.text = "3"
            case 1:
                countDown.text = "2"
            case 2:
                countDown.text = "1"
            case 3:
                countDown.text = "0"
            default:
                break
            }//switch
            ivul.isUserInteractionEnabled = false
            if ivulTimer > 3 {
                ivulPU = false
                ivulTimer = 0
                countDown.isHidden = true
                ivul.isUserInteractionEnabled = true
            }
        }//if powerUp == .ivul
        if refillPU == true {
            refillTimer += deltaTime
            health += CGFloat(0.4/60)
            refill.isUserInteractionEnabled = false
            if refillTimer >= 0.5 {
                refillPU = false
                refillTimer = 0
                refill.isUserInteractionEnabled = true
            }
        }
        timer += deltaTime
        if timer - timer2 >= 1 && Int(timer.truncatingRemainder(dividingBy: 15)) == 0{
            x += 2.5
            timer2 += 15
        }
        netSpawnTimer += deltaTime * CFTimeInterval(x/60)
        boatSpawnTimer += deltaTime
        itemSpawnTimer += deltaTime * CFTimeInterval(x/60)
        seaweedSpawnTimer += deltaTime
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        if holding == true {
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: diveForce))
            hero.run(dive!)
            if velocityY < maxVelocity {
                hero.physicsBody?.velocity.dy = maxVelocity
            }
        } else {
            hero.run(float2!)
        }// if holding == true
        if velocityY > minVelocity {
            hero.physicsBody?.velocity.dy = minVelocity
        }
        if hookState == .connect {
            if hero.parent != nil {
                if hero.parent!.convert(hero.position, to: self).y >= 160 {
                    playersDeath()
                }
                if hero.parent!.convert(hero.position, to: self).y < -10 {
                    hookState = .noconnect
                    hero.move(toParent: self)
                    fishBoatSpeed = x
                }
            }//if let parent = hero.parent
        }//if hookState == .connect
        root()
        if let obstacle = obstacleNode {
            if !obstacle.intersects(hero) {
                obstacleKind = .none
                obstacleNode = nil
            }
        }
        if sData.current > sData.high {
            sData.high = sData.current
        }
        highestDistanceScore2.text = String(sData.high)
        moneyCounterScore.text =     String(sData.money)
        moneyCounterScore2.text =    String(sData.money)
        refCounter.text =            String(sData.refill)
        ivulCounter.text =           String(sData.ivul)
        lastTime =                   currentTime
    }//override func update
}//GameScene class
