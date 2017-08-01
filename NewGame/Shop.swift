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
    var back: MSButtonNode!
    weak var backScene: SKScene!
    
    override func didMove(to view: SKView) {
        back = childNode(withName: "goBackButton") as! MSButtonNode!
        back.selectedHandler = {[unowned self] in
            view.presentScene(self.backScene)
        }
    }
    
    
    func buttonFunc(fileName: String, direction: String) { //custom button transfer, for any situation
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

}
