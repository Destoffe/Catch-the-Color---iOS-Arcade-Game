//
//  Player.swift
//  CrazyColors
//
//  Created by christoffer wahlman on 2018-03-11.
//  Copyright © 2018 CWApplications. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode{
    
    private var minX = CGFloat(-200), maxX = CGFloat(200);
    
    func initializePlayer(){
        name = "Player";
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width,
                                                        height: size.height));
        physicsBody?.affectedByGravity = false;
        physicsBody?.isDynamic = false;
        physicsBody?.categoryBitMask = ColliderType.PLAYER;
        physicsBody?.contactTestBitMask = ColliderType.FRUIT_AND_BOMB;
        
    }
    
    
}
























