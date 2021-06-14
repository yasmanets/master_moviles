//
//  Carta.swift
//  SieteyMedia
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

enum Palo: String {
    case bastos, copas, espadas, oros
}

class Carta {
    private var pValor: Int
    private var pPalo: Palo
    
    init?(_ valor: Int, _ palo: Palo) {
        if valor < 1 || valor > 12 || valor == 8 || valor == 9 {
            return nil
        }
        self.pValor = valor
        self.pPalo = palo
    }
    
    var valor: Int {
        get {
            return self.pValor
        }
    }
    
    var palo: Palo {
        get {
            return self.pPalo
        }
    }
    
    func descripcion() -> String {
        return "El \(pValor) de \(pPalo.rawValue)"
    }
}
