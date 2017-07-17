//
//  GameScene.swift
//  Pachinko
//
//  Created by Jonathan Go on 2017/07/17.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)  //places the background image in the cente of the landscapte iPad
        background.blendMode = .replace  //determines how a node is drawn. .replace means just draw it ignoring any alpha values
        background.zPosition = -1  //-1 means draw this behind anything else
        addChild(background)  //doens't use viewController so we need to use this.  We can add nodes to other nodes.
    
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  //adds a physicsBody to the whole scene that is a line on each edge effectively acting as a container for the scene
    
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 897, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //This method gets called whenever someone touches the device
        if let touch = touches.first {  //looks for the first touch
            
            let location = touch.location(in: self) //finds out where the screen was touched in relation to self (gamescene) and puts it there
            let ball = SKSpriteNode(imageNamed: "ballRed")  //creates a ball
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)  //add a physicsbody for the ball
            ball.physicsBody!.restitution = 0.4  //bounciness of the ball (0-1)
            ball.position = location  //places the ball where the screen was touched
            addChild(ball)  // then adds it to the scene (displaying the ball)
        }
    }
    
    func makeBouncer(at position: CGPoint) {
     //at is what you will use to call the method; position is what you use inside the method.
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody!.isDynamic = false  //if true, the bouncer will be moved by the physicsBody based on collisions, etc.
        addChild(bouncer)

    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")

        } else {
            
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")

        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}
