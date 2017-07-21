//
//  DeathScene.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-11.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class DeathScene: SKScene, SKPhysicsContactDelegate {
    
    let sharedData = SharedData.data
    var highestDistanceScore: SKLabelNode!
    var currentDistanceScore: SKLabelNode!
    var moneyCounterScore:    SKLabelNode!
    var button: MSButtonNode!
    var shopButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        highestDistanceScore = childNode(withName: "highestDistanceScore") as! SKLabelNode
        currentDistanceScore = childNode(withName: "currentDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "moneyCounterScore") as! SKLabelNode
        buttonFunc(fileName: "restartButton", direction: "GameScene")
        buttonFunc(fileName: "mainMenuButton", direction: "MainMenu")
        shopButton = childNode(withName: "shopButton") as! MSButtonNode
        shopButton.selectedHandler = {
            let shop = Shop(fileNamed: "Shop")
            shop?.backScene = self
            shop?.scaleMode = .aspectFill
            view.presentScene(shop)
        }
        highestDistanceScore.text = String(sharedData.high)
        currentDistanceScore.text = String(sharedData.current)
        moneyCounterScore.text = String(sharedData.money)
    }
    
    func buttonFunc(fileName: String, direction: String) { //custom button transfer, for any situation я горд собой
        button = childNode(withName: fileName) as! MSButtonNode
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
}
