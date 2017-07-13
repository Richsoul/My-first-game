//
//  Settings.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit

class Settings: SKScene {
    
    var deleteWindow: SKSpriteNode!
    var deleteResults: MSButtonNode!
    var goBack: MSButtonNode!
    var cancel: MSButtonNode!
    
    override func didMove(to view: SKView) {
        deleteWindow = childNode(withName: "deleteGameResultsWindow") as! SKSpriteNode
        deleteResults = childNode(withName: "deleteResults") as! MSButtonNode
        goBack = childNode(withName: "goBack") as! MSButtonNode
        cancel = childNode(withName: "//cancelButton") as! MSButtonNode
        deleteWindow.isHidden = true
        deleteResults.selectedHandler = {
            self.deleteWindow.isHidden = false
            self.goBack.isUserInteractionEnabled = false
        }
        cancel.selectedHandler = {
            self.deleteWindow.isHidden = true
            self.goBack.isUserInteractionEnabled = true
        }
        
    }
    
    
}
