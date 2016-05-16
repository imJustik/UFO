//
//  planetTimer.swift
//  NLO
//
//  Created by Iliya Kuznetsov on 05.05.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//
import SpriteKit

class scoreLabel: SKLabelNode {
    var timerCount: Int = 0 {
        didSet {
            self.text = "Счет: \(timerCount)"
        }
    }
    override init() {
        super.init()
        self.fontName = "ArialMT"
        self.fontSize = 50
        self.position = CGPoint(x: 550, y: 1800)
        self.text = "Счет \(timerCount)"
        
        let wait = SKAction.waitForDuration(0.5)
        let block = SKAction.runBlock({
            if self.timerCount >= 0 {
                self.timerCount += 1
            } else {
               print("Что-то пошло не так")
            }
        })
        let sequence = SKAction.sequence([wait,block])
        runAction(SKAction.repeatActionForever(sequence), withKey: "score")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
