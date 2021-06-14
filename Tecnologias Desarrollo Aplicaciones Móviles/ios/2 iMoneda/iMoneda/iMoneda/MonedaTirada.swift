//
//  MonedaTirada.swift
//  iMoneda
//
//  Created by Yaser  on 28/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

enum Tirada: String {
    case cara, cruz
}

class Moneda {
    func lanzar() -> Tirada {
        let result = Int.random(in: 0..<2)
        if result == 0 {
            return Tirada.cara
        }
        else {
            return Tirada.cruz
        }
    }
}
