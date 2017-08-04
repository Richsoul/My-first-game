//
//  MainMenu.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-10.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit
import FirebaseAuth
import FirebaseAuthUI

class MainMenu: SKScene {
    
    let sharedData = SharedData.data
    var shopButton: MSButtonNode!
    var highDistanceScore: SKLabelNode!
    var moneyCounterScore: SKLabelNode!
    var login: MSButtonNode!
    static weak var controller: UIViewController!
    
    override func didMove(to view: SKView) {
        login = childNode(withName: "login") as! MSButtonNode
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
        login.selectedHandler = {
            guard let authUI = FUIAuth.defaultAuthUI() else {
                return
            }
            authUI.delegate = self
            MainMenu.controller.present(authUI.authViewController(), animated: true)
        }
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

extension MainMenu: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            return
        }
        guard let firUser = user else {
            return
        }
        UserService.show(forUID: firUser.uid) { user in
            if let user = user {
                User.setCurrent(user, writeToUserDefaults: true)
            } else {
                if User.loggedIn {
                    UserDefaults.standard.set(0, forKey: "money")
                }
                UserService.create(firUser, coins: UserDefaults.standard.integer(forKey: "money")) { user in
                    guard let user = user else {
                        return
                    }
                    User.setCurrent(user, writeToUserDefaults: true)
                }
            }
        }
    }
}
