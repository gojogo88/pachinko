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
    
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = CGPoint(x: 512, y: 0)  //centered horizontally at the bottom edge of the screen
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody!.isDynamic = false  //if true, the bouncer will be moved by the physicsBody based on collisions, etc.
        addChild(bouncer)
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
}
