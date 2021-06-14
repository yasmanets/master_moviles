//
//  DetailViewController.swift
//  ejercicio_universal
//
//  Created by Yaser  on 15/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, TableViewControllerDelegate {
    func optionSeleccionada(nombreOpcion: String) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topBar: UINavigationItem!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            topBar.title = "\(detail.titulo) (\(detail.fecha))"
            if let imagen = self.imageView {
                imagen.image = UIImage(named: detail.caratula)
            }
            if let description = self.descriptionText {
                description.text = detail.descripcion!
            }
        }
        else {
            topBar.title = "Película"
            descriptionText.text = "Selecciona una película"
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
    
    @IBAction func accionOpciones() {
        print("click en opciones")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "optionsTable") as! TableViewController
        controller.setOptionsContent(content: detailItem?.actores ?? [])
        controller.delegate = self
        
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(controller, animated: true, completion: nil)
        
        let popController = controller.popoverPresentationController
        // Se establecen la posición desde la que sale
        popController?.barButtonItem = self.navigationItem.rightBarButtonItem
        popController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController?.delegate = self
        controller.preferredContentSize = CGSize(width: 250, height: 135)
    }
}
