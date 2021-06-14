//
//  Mano.swift
//  SieteyMedia
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

class Mano {
    private var mano: [Carta]
    init() {
        mano = []
    }
    
    var tamaño: Int {
        get {
            return self.mano.count
        }
    }
    
    var cartas: [Carta] {
        get {
            return self.mano
        }
    }
    
    func addCarta(_ carta: Carta) {
        self.mano.append(carta)
    }
    
    func getCarta(pos: Int) -> Carta? {
        if pos < 0 || pos >= self.cartas.count {
            return nil
        }
        return self.cartas[pos]
    }
}
