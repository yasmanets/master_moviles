//
//  SKScene+Extensions.swift
//  AirHockey
//
//  Created by Yaser  on 28/2/21.
//  Copyright © 2021 Miguel Angel Lozano Ortega. All rights reserved.
//

import SpriteKit

public extension SKScene {
    func resizeWithFixedHeightTo(viewportSize: CGSize) {
        self.scaleMode = .aspectFill
        let aspectRatio = viewportSize.width / viewportSize.height
        self.size = CGSize(width: self.size.height * aspectRatio,
                           height: self.size.height)
    }
}
