//
//  Shop.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-11.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import SpriteKit


class Shop: SKScene {
    var sharedData = SharedData.data
    var back:      MSButtonNode!
    var buyRefill: MSButtonNode!
    var buyIvul:   MSButtonNode!
    var refillCounter: SKLabelNode!
    var ivulCounter:   SKLabelNode!
    var refillCost:    SKLabelNode!
    var ivulCost:      SKLabelNode!
    var cost : Int = 25
    var cost2 : Int = 30
    weak var backScene: SKScene!
    
    override func didMove(to view: SKView) {
        buyRefill = childNode(withName: "buyButton1")   as! MSButtonNode
        buyIvul =   childNode(withName: "buyButton2")   as! MSButtonNode
        back =      childNode(withName: "goBackButton") as! MSButtonNode
        refillCounter = childNode(withName: "refillPU")   as! SKLabelNode
        ivulCounter =   childNode(withName: "ivulPU")     as! SKLabelNode
        refillCost =    childNode(withName: "refillCost") as! SKLabelNode
        ivulCost =      childNode(withName: "ivulCost")   as! SKLabelNode
        back.selectedHandler = {[unowned self] in
            view.presentScene(self.backScene)
        }
        buyRefill.selectedHandler = {[unowned self] in
            if self.sharedData.money > self.cost {
            self.sharedData.refill += 1
            self.sharedData.money -= self.cost
            }
        }
        buyIvul.selectedHandler = {[unowned self] in
            if self.sharedData.money > self.cost2 {
            self.sharedData.ivul += 1
            self.sharedData.money -= self.cost2
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        refillCounter.text = String(sharedData.refill)
        ivulCounter.text =   String(sharedData.ivul)
        refillCost.text =    String(cost)
        ivulCost.text =      String(cost2)
    }
}
