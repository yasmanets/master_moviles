//
//  ButtonSpriteNode.swift
//  AirHockey
//
//  Created by Yaser  on 28/2/21.
//  Copyright © 2021 Miguel Angel Lozano Ortega. All rights reserved.
//

import SpriteKit

protocol ButtonSpriteNodeDelegate {
    func didPushButton(_ sender: ButtonSpriteNode)
}

class ButtonSpriteNode: SKSpriteNode {
    
    var delegate : ButtonSpriteNodeDelegate?
    
    // Indica el estado del botón
    var pressed : Bool = false
    
    // El boton siempre sera interactivo
    override var isUserInteractionEnabled: Bool {
        set {
        }
        get {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        self.run(scaleUp)
        pressed = true
    }
        
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        self.run(scaleDown, completion: {
            self.pressed = false

            // Solo llamamos al evento si al terminar el gesto
            // seguimos dentro del boton
            for t in touches {
                if self.contains(t.location(in: self.parent!)) {
                    self.delegate?.didPushButton(self)
                }
            }
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        pressed = false
    }
}
