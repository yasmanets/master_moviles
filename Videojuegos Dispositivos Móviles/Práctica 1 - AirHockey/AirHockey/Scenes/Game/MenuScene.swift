//
//  MenuScene.swift
//  AirHockey
//
//  Created by Yaser  on 28/2/21.
//  Copyright © 2021 Miguel Angel Lozano Ortega. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene, ButtonSpriteNodeDelegate {
    
    private var playButton : ButtonSpriteNode?

    func didPushButton(_ sender: ButtonSpriteNode) {
        if let scene = SKScene(fileNamed: "GameScene"),
           let view = self.view
        {
            view.presentScene(scene, transition: SKTransition.flipHorizontal(withDuration: 1))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if let scene = SKScene(fileNamed: "GameScene"),
        //   let view = self.view
        // {
        //    view.presentScene(scene, transition: SKTransition.flipHorizontal(withDuration: 1))
        //  }
    }
    
    override func didMove(to view: SKView) {
        self.playButton = childNode(withName: "playButton") as? ButtonSpriteNode
        self.playButton?.delegate = self
    }

}
