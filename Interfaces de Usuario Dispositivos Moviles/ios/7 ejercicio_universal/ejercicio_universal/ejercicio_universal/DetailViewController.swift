//
//  DetailViewController.swift
//  ejercicio_universal
//
//  Created by Yaser  on 15/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fecha: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = titleLabel {
                label.text = detail.titulo
            }
            if let imagen = self.imageView {
                imagen.image = UIImage(named: detail.caratula)
            }
            if let description = self.descriptionText {
                description.text = detail.descripcion!
            }
            if let fecha = self.fecha {
                fecha.text = detail.fecha
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Pelicula? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewWillLayoutSubviews() {
        if view.bounds.size.width >= view.bounds.size.height {
            self.stackView.axis = .horizontal
        }
        else {
            self.stackView.axis = .vertical
        }
    }


}
