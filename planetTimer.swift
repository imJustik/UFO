//
//  planetTimer.swift
//  NLO
//
//  Created by Iliya Kuznetsov on 05.05.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//
import SpriteKit

class planetTimer: SKLabelNode {
    var timerCount: Int = 20 {
        didSet {
            self.text = "Планета через: \(timerCount)"
        }
    }
    init(action:() -> Void) {
        super.init()
        self.fontName = "ArialMT"
        self.fontSize = 50
        self.position = CGPoint(x: 550, y: 1700)
        self.text = "Планета через: \(timerCount)"
        
        let wait = SKAction.waitForDuration(1)
        let block = SKAction.runBlock({
            if self.timerCount > 0 {
                self.timerCount -= 1
            } else {
                print("планета")
                self.removeActionForKey("countdown")
                action()
                self.removeFromParent()
            }
        })
        let sequence = SKAction.sequence([wait,block])
        runAction(SKAction.repeatActionForever(sequence), withKey: "countdown")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
