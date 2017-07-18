//
//  Shop.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-11.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class Shop: SKScene {
    
    var button: MSButtonNode!
    
    override func didMove(to view: SKView) {
        buttonFunc(fileName: "settingsButton", direction: "Settings")
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

}
    
