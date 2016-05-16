//
//  WinScene.swift
//  NLO
//
//  Created by Iliya Kuznetsov on 06.05.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import SpriteKit
class WinScene: SKScene {
      override func didMoveToView(view: SKView) {
        let score = self.childNodeWithName("scoreLabel") as! SKLabelNode
        let high = self.childNodeWithName("recordLabel") as! SKLabelNode
        
        score.text = String(GameStates.sharedInstance.score)
        high.text = String(GameStates.sharedInstance.highScore)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = .AspectFill
        self.view?.presentScene(scene)
    }
    
}