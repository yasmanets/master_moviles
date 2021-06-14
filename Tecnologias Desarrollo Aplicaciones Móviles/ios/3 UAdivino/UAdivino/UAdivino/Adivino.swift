//
//  Adivino.swift
//  UAdivino
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

class Adivino {
    func obtenerRespuesta() -> String {
        let respuestas = ["si", "no", "ni_casualidad", "claro"]
        let indice = Int(arc4random_uniform(UInt32(respuestas.count)))
        return respuestas[indice]
    }
}
