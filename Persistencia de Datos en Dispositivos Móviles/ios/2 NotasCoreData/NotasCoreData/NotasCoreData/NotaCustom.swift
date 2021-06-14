//
//  NotaCustom.swift
//  NotasCoreData
//
//  Created by Yaser  on 13/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import Foundation

extension Nota {
    @objc var inicial: String? {
        if let textoNoNil = self.texto {
            let pos2 = textoNoNil.index(after: textoNoNil.startIndex)
            return textoNoNil.substring(to: pos2)
        }
        else {
            return nil
        }
    }
}
