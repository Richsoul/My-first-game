//
//  MainMenu.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var button: MSButtonNode!
    
    override func didMove(to view: SKView) {
        buttonFunc(fileName: "shopButton", direction: "Shop")
        buttonFunc(fileName: "settingsButton", direction: "Settings")
        //buttonFunc(fileName: "startArea", direction: "GameScene")
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
       
        
    }
}
