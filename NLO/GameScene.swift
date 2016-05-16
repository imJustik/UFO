//
//  GameScene.swift
//  NLO
//
//  Created by Iliya Kuznetsov on 04.05.16.
//  Copyright (c) 2016 Iliya Kuznetsov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player = SKSpriteNode()
    var planet = SKSpriteNode()
    
    var isPlayerMoving = false
    
    var angels = [String:CGPoint]()
    var currentDirection = CGPoint()
    
    let meteorSprites:[String] = ["meteor","meteor_medium","meteor_small"]
    
    
     let score = scoreLabel()
    
    override func didMoveToView(view: SKView) {
        player = self.childNodeWithName("player") as! SKSpriteNode
        planet = self.childNodeWithName("planet") as! SKSpriteNode
        
        player.physicsBody?.categoryBitMask = BitMask.Player
        player.physicsBody?.collisionBitMask = BitMask.None
        player.physicsBody?.contactTestBitMask = BitMask.Planet
        
        planet.physicsBody?.categoryBitMask = BitMask.Planet
        planet.physicsBody?.collisionBitMask = BitMask.None
        planet.physicsBody?.contactTestBitMask = BitMask.Player
        
        
        angels["leftTop"] = CGPointMake(CGRectGetMinX(self.frame) + player.frame.size.width/2, CGRectGetMaxY(self.frame) - player.frame.size.height/2 )
        angels["rightTop"] = CGPointMake(CGRectGetMaxX(self.frame) - player.frame.size.width/2, CGRectGetMaxY(self.frame) - player.frame.size.height/2 )
        angels["leftDown"] = CGPointMake(CGRectGetMinX(self.frame) + player.frame.size.width/2, CGRectGetMinY(self.frame) + player.frame.size.height/2 )
        angels["rightDown"] = CGPointMake(CGRectGetMaxX(self.frame) - player.frame.size.width/2, CGRectGetMinY(self.frame) + player.frame.size.height/2 )
        
        
        let timerPlaenet = planetTimer(action: {self.createPlanet()})
        self.addChild(timerPlaenet)
        
       
        self.addChild(score)
        
        
        let wait = SKAction.waitForDuration(1.5)
        let block = SKAction.runBlock({
            self.createMeteor()
        })
        let sequence = SKAction.sequence([wait,block])
        runAction(SKAction.repeatActionForever(sequence), withKey: "creatingMeteors")
        
        
        if let particles = SKEmitterNode(fileNamed: "cosmorain.sks") {
            particles.position = CGPoint(x: CGRectGetMaxX(self.frame) + 50, y: CGRectGetMidY(self.frame))
            particles.zPosition = 4
            addChild(particles)
        }
       
        
          physicsWorld.contactDelegate = self
        
    }
    func didBeginContact(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.categoryBitMask == BitMask.Player) && ( secondBody.categoryBitMask == BitMask.Planet) {
            GameStates.sharedInstance.score = score.timerCount
            GameStates.sharedInstance.saveState()
            let scene = WinScene(fileNamed:"WinScene")
            scene!.scaleMode = .AspectFill
            self.view?.presentScene(scene)
           
            
        }
        
        if (firstBody.categoryBitMask == BitMask.Player) && ( secondBody.categoryBitMask == BitMask.Meteor) {
            let scene = LostScene(fileNamed:"LostScene")
            scene!.scaleMode = .AspectFill
            self.view?.presentScene(scene)
            
        }

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isPlayerMoving {
            currentDirection = angels["leftTop"]!
            player.runAction(SKAction.moveTo(currentDirection, duration: 2))
            isPlayerMoving = true
        } else {
            switch currentDirection {
            case angels["leftTop"]!: currentDirection = angels["rightTop"]!; break
            case angels["rightTop"]!: currentDirection = angels["rightDown"]!; break
            case angels["rightDown"]!: currentDirection = angels["leftDown"]!; break
            default: currentDirection = angels["leftTop"]!; break
            }
            player.removeAllActions()
            player.runAction(SKAction.moveTo(currentDirection, duration: 2))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createPlanet() {
        let oscillate = SKAction.oscillation(amplitude: 200, timePeriod: 7, midPoint: planet.position)
        
        let sinAction = SKAction.repeatAction(oscillate, count: 1)
        let runAction = SKAction.moveByX(-2000, y: 0, duration: 7)
        let block = SKAction.runBlock({
            let timerPlaenet = planetTimer(action: {self.createPlanet()})
            self.addChild(timerPlaenet)
            self.planet.position = CGPointMake(1558,-270)
        })
        
        planet.runAction(sinAction)
        planet.runAction(SKAction.sequence([runAction,block]))
    }
    
    func createMeteor() {
        let meteor = SKSpriteNode(imageNamed: meteorSprites[Int(arc4random_uniform(3))])
        
        meteor.position = CGPointMake(CGRectGetMaxX(self.frame) + meteor.frame.size.width/2, CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(self.frame)) - UInt32(meteor.frame.size.height))))
        
        addChild(meteor)
        
        let meteorAction = SKAction.moveByX(-2000,y: 0, duration: Double(arc4random_uniform(5)+2))
        meteor.runAction(SKAction.sequence([meteorAction, SKAction.removeFromParent()]))
        
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.frame.size.height/2)
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.categoryBitMask = BitMask.Meteor
        meteor.physicsBody?.collisionBitMask = BitMask.None
        meteor.physicsBody?.contactTestBitMask = BitMask.Player
    }
    
}

extension SKAction {
    static func oscillation(amplitude a: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
        let action = SKAction.customActionWithDuration(Double(t)) { node, currentTime in
            let displacement = a * sin(CGFloat(M_PI) * currentTime / CGFloat(t))
            node.position.y = midPoint.y + displacement
        }
        
        return action
    }}
