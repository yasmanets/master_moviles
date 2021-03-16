//
//  ViewController.swift
//  animacion_gym_swift
//
//  Created by Master Móviles
//  Copyright © 2016 Master Móviles. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    var capaPortada: CALayer!
    @IBOutlet weak var btVenAqui: UIButton!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.capaPortada = CALayer()
        self.capaPortada.position = self.view.center
        self.capaPortada.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // TODO (a) Configurar la capa con
        // 1. Radio de esquinas 10
        // 2. Grosor de borde 2
        // 3. Color de fondo blanco
        // 4. Color de borde gris
        
        // ...
        self.capaPortada.cornerRadius = 10
        self.capaPortada.borderWidth = 2
        self.capaPortada.backgroundColor = UIColor.white.cgColor
        self.capaPortada.borderColor = UIColor.gray.cgColor
        
        self.capaPortada.contents = (UIImage(named: "resplandor.jpg")!.cgImage! as Any)
        self.capaPortada.contentsGravity = CALayerContentsGravity.resizeAspect
        
        self.view.layer.addSublayer(self.capaPortada)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionMoverAqui(_ sender: UIButton) {
        // TODO (b) Hacer que la capa con la imagen de la pelicula (self.capaPortada) se mueva a la posición que ocupa el botón pulsado (sender.center) de forma animada
        self.capaPortada.position = sender.center
    }
    
}

