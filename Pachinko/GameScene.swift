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
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //This method gets called whenever someone touches the device
        if let touch = touches.first {
            
            let location = touch.location(in: self) //finds out where the screen was touched in relation to self (gamescene)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))  //creates a box
            box.position = location  //places the box where the screen was touched
            addChild(box)  // then adds it to the scene
        }
    }
}
