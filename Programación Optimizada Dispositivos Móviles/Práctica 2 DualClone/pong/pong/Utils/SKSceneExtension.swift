//
//  SKSceneExtension.swift
//  pong
//
//  Created by Yaser  on 4/5/21.
//

import UIKit
import SpriteKit

public extension SKScene {
    func resizeWithFixedHeightTo(viewportSize: CGSize) {
        self.scaleMode = .aspectFit
        let aspectRatio = viewportSize.width / viewportSize.height
        self.size = CGSize(width: self.size.height * aspectRatio, height: self.size.height)
    }
}
