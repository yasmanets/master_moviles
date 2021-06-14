//
//  TravelPicker.swift
//  dashboard
//
//  Created by Yaser  on 19/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit
class TravelPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var places = ["TOI 700", "Kepler-186f", "Kepler-186d", "Saturno", "M13", "Nebulosa de Orión"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Se ha cambiadl el destino a: \(places[row])")
    }
}
