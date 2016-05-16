//
//  LostScene.swift
//  NLO
//
//  Created by Iliya Kuznetsov on 06.05.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import SpriteKit
class LostScene: SKScene {
    override func didMoveToView(view: SKView) {
    }
    
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
}
