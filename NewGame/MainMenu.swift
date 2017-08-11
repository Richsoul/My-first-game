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
import GoogleMobileAds

class MainMenu: SKScene {
    
    let sharedData = SharedData.data
    var adsButton: MSButtonNode!
    var highDistanceScore: SKLabelNode!
    var moneyCounterScore: SKLabelNode!
    var login: MSButtonNode!
    static weak var controller: UIViewController!
    var banner: GADBannerView!
    
    override func didMove(to view: SKView) {
        login = childNode(withName: "login") as! MSButtonNode
        highDistanceScore = childNode(withName: "highDistanceScore") as! SKLabelNode
        moneyCounterScore = childNode(withName: "moneyCounterScore") as! SKLabelNode
        /*adsButton = childNode(withName: "adsButton") as! MSButtonNode
        adsButton.selectedHandler = {
            Products.store.requestProducts { success, products in
                guard success else { return }
                Products.store.restorePurchases()
                let ads = products!.first(where: {product in product.productIdentifier == Products.removeAds})
                if let adProduct = ads,
                    StoreService.canMakePayments(),
                    !Products.store.isProductPurchased(Products.removeAds) {
                    Products.store.buyProduct(adProduct)
                }
            }
        }*/
        /*shopButton.selectedHandler = {[unowned self] in
            let shop = Shop(fileNamed: "Shop")
            shop?.backScene = self
            shop?.scaleMode = .aspectFit
            view.presentScene(shop)
        }*/
        highDistanceScore.text = String(sharedData.high)
        moneyCounterScore.text = String(sharedData.money)
        login.selectedHandler = { [unowned self] in
            guard let authUI = FUIAuth.defaultAuthUI() else {
                return
            }
            authUI.delegate = self
            MainMenu.controller.present(authUI.authViewController(), animated: true)
        }
        showAd()
    }
    
    func showAd() {
        guard !Products.store.isProductPurchased(Products.removeAds) else { return }
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        banner.adUnitID = "ca-app-pub-7382032268110091/6686251293" //test ads: "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = MainMenu.controller
        MainMenu.controller.view.addSubview(banner)
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        banner.load(request)
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
            banner.removeFromSuperview()
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            }
        }
     }
}

extension MainMenu: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if error != nil {
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
