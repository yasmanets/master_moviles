//
//  Baraja.swift
//  SieteyMedia
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

class Baraja {
    private var cartas: [Carta]
    
    init() {
        cartas = []
        for palo in [Palo.bastos, Palo.espadas, Palo.oros, Palo.copas] {
            for valor in 1...12 {
                if valor != 9 && valor != 8 {
                    let carta = Carta(valor, palo)
                    cartas.append(carta!)
                }
            }
        }
    }
    
    func repartirCarta() -> Carta {
        return cartas.popLast()!
    }
    
    func barajar() {
        cartas.shuffle()
    }
    
    
}
