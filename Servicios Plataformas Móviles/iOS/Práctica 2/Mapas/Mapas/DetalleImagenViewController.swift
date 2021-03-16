//
//  DetalleImagenControllerViewController.swift
//  Mapas
//
//  Created by Yaser  on 21/2/21.
//

import UIKit
import MapKit

class DetalleImagenViewController: UIViewController {
    
    var annotationTitle: String!
    @IBOutlet weak var detailImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        if annotationTitle.contains("1") {
            detailImage.image = UIImage(named: "swift.png")
        }
        else {
            detailImage.image = UIImage(named: "btc.png")
        }
    }
}
