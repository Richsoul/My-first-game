//
//  DeathScene.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-11.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class DeathScene: SKScene, SKPhysicsContactDelegate {
    
    var highestDistanceScore: SKLabelNode!
    var currentDistanceScore: SKLabelNode!
    var moneyCounterScore:    SKLabelNode!
    var button: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        buttonFunc(fileName: "restartButton", direction: "GameScene")
        buttonFunc(fileName: "shopButton", direction: "Shop")
        buttonFunc(fileName: "mainMenuButton", direction: "MainMenu")
        
        
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
