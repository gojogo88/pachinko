//
//  GameScene.swift
//  Pachinko
//
//  Created by Jonathan Go on 2017/07/17.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0{  //property observer
        
        didSet {
            
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        
        didSet {
            
            if editingMode {
            
                editLabel.text = "Done"
            
            } else {
        
                editLabel.text = "Edit"
            }
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)  //places the background image in the cente of the landscapte iPad
        background.blendMode = .replace  //determines how a node is drawn. .replace means just draw it ignoring any alpha values
        background.zPosition = -1  //-1 means draw this behind anything else
        addChild(background)  //doens't use viewController so we need to use this.  We can add nodes to other nodes.
    
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  //adds a physicsBody to the whole scene that is a line on each edge effectively acting as a container for the scene
    
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 897, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //This method gets called whenever someone touches the device
        if let touch = touches.first {  //looks for the first touch
            
            let location = touch.location(in: self) //finds out where the screen was touched in relation to self (gamescene) and puts it there
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                
                editingMode = !editingMode
                
            } else {
                
                if editingMode {
                    
                    //create a box
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody!.isDynamic = false
                    
                    addChild(box)
                    
                } else {
                    //create a ball
                    let ball = SKSpriteNode(imageNamed: "ballRed")  //creates a ball
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)  //add a physicsbody for the ball
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody!.restitution = 0.4  //bounciness of the ball (0-1)
                    ball.position = location  //places the ball where the screen was touched
                    ball.name = "ball"
                    addChild(ball)  // then adds it to the scene (displaying the ball)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
     //at is what you will use to call the method; position is what you use inside the method.
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.isDynamic = false  //if true, the bouncer will be moved by the physicsBody based on collisions, etc.
        addChild(bouncer)

    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"

        } else {
            
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
            
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)  //add physics for slots
        slotBase.physicsBody!.isDynamic = false  //we dont want it to move when hit
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
    //checks where the ball collides
        
        if object.name == "good" {
            
            destroy(ball: ball)
            
            score += 1
            
        } else if object.name == "bad" {
            
            destroy(ball: ball)
            
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "ball" {
        
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
            
        } else if contact.bodyB.node?.name == "ball" {
            
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
            
        }
        
    }
}
