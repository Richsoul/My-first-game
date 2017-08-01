//
//  MainMenu.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    let sharedData = SharedData.data
    var shopButton: MSButtonNode!
    var highDistanceScore: SKLabelNode!
    var moneyCounterScore: SKLabelNode!
    
    override func didMove(to view: SKView) {
        highDistanceScore = childNode(withName: "highDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "moneyCounterScore") as! SKLabelNode
        shopButton = childNode(withName: "shopButton") as! MSButtonNode
        shopButton.selectedHandler = {[unowned self] in
            let shop = Shop(fileNamed: "Shop")
            shop?.backScene = self
            shop?.scaleMode = .aspectFill
            view.presentScene(shop)
        }
        highDistanceScore.text = String(sharedData.high)
        moneyCounterScore.text = String(sharedData.money)
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let x: CGFloat = 215
        let y1: CGFloat = -139
        let y2: CGFloat = 39
        
        if location.x > -x && location.x < x {
            if location.y > y1 && location.y < y2 {
            guard let skView = self.view as SKView! else {
                return
            }
            guard let scene = GameScene(fileNamed:"GameScene") else {
                return
            }
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            }
        }
     }
}
