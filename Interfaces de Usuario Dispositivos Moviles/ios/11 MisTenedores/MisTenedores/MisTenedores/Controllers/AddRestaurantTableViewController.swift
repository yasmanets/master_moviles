//
//  AddRestaurantTableViewController.swift
//  MisTenedores
//
//  Created by Yaser  on 01/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class AddRestaurantTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var restaurantType: UITextField!
    @IBOutlet weak var restaurantLocation: UITextField!
    @IBOutlet weak var restaurantPhone: UITextField!
    @IBOutlet weak var restaurantWebsite: UITextField!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantName.delegate = self
        self.restaurantType.delegate = self
        self.restaurantLocation.delegate = self
        self.restaurantPhone.delegate = self
        self.restaurantWebsite.delegate = self

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.imageView.contentMode = .scaleToFill
        self.imageView.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveRestaurant(_ sender: UIBarButtonItem) {
        if let name = self.restaurantName.text,
           let type = self.restaurantType.text,
           let location = self.restaurantLocation.text,
           let phone = self.restaurantPhone.text,
           let website = self.restaurantWebsite.text,
           let image = self.imageView.image {
            if !name.isEmpty && !type.isEmpty && !location.isEmpty && !phone.isEmpty && !website.isEmpty {
                self.restaurant = Restaurant(name: name, type: type, image: image, bestPlates: nil, phone: phone, web: website, location: location)
                performSegue(withIdentifier: "unwindMainViewController", sender: self)
            }
            else {
                let alertController = UIAlertController(title: "Falta algún campo", message: "Revisa que has rellenado todos los cambios", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
