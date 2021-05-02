//
//  ProfileViewController.swift
//  Runtracker
//
//  Created by Yaser  on 25/4/21.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    private var gender: String = "male"
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserData()

        // Do any additional setup after loading the view.
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(openImagePicker(_:)))
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let wightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let ageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let heightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        self.profileImage.addGestureRecognizer(imageTapGesture)
        self.nameLabel.addGestureRecognizer(nameTapGesture)
        self.weightLabel.addGestureRecognizer(wightTapGesture)
        self.ageLabel.addGestureRecognizer(ageTapGesture)
        self.heightLabel.addGestureRecognizer(heightTapGesture)
    }
    
    func getUserData() {
        let image = userDefaults.data(forKey: "profileImage")
        if let savedImage = image {
            self.profileImage.image = UIImage(data: savedImage, scale: 1.0)
        }
        else {
            self.profileImage.image = UIImage(named: "profile.png")
        }
        let name = userDefaults.string(forKey: "name")
        if let savedName = name {
            self.nameLabel.text = savedName
        }
        else {
            self.nameLabel.text = "Nombre"
        }
        let gender = userDefaults.string(forKey: "gender")
        if gender == "male" {
            self.genderButton.setImage(UIImage(named: "male.png"), for: .normal)
            self.gender = "male"
        }
        else {
            self.genderButton.setImage(UIImage(named: "female.png"), for: .normal)
            self.gender = "female"
        }
        let weight = userDefaults.string(forKey: "weight")
        if let savedWeight = weight {
            self.weightLabel.text = savedWeight
        }
        else {
            self.weightLabel.text = "000"
        }
        let age = userDefaults.string(forKey: "age")
        if let savedAge = age {
            self.ageLabel.text = savedAge
        }
        else {
            self.ageLabel.text = "00"
        }
        let height = userDefaults.string(forKey: "height")
        if let savedHeight = height {
            self.heightLabel.text = savedHeight
        }
        else {
            self.heightLabel.text = "000"
        }
    }
    
    
    // MARK: - GestureRecognizer options
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let restorationId = sender.view?.restorationIdentifier {
            switch restorationId {
            case "name":
                openEditText("Introduce tu nombre", self.nameLabel, "name")
            case "weight":
                openEditText("Introduce tu peso", self.weightLabel, "weight")
            case "age":
                openEditText("Introduce tu edad", self.ageLabel, "age")
            case "height":
                openEditText("Introduce tu altura", self.heightLabel, "height")
            default: break
            }
        }
    }

    @objc func openImagePicker(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImage.image = image
        userDefaults.set(image.pngData(), forKey: "profileImage")
        dismiss(animated: true, completion: nil)
        userDefaults.synchronize()
    }
    
    @objc func openEditText(_ text: String, _ label: UILabel, _ prefsValue: String) {
        let alertController = UIAlertController(title: "Datos", message: text, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Introduce aquí el dato..."
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            let textField = (alertController.textFields?[0])! as UITextField
            if !textField.text!.isEmpty {
                label.text = textField.text
                self.userDefaults.setValue(textField.text, forKey: prefsValue)
                self.userDefaults.synchronize()
            }
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Gender button
    @IBAction func genderAction(_ sender: Any) {
        if (self.gender == "male") {
            self.gender = "female"
            self.genderButton.setImage(UIImage(named: "female.png"), for: .normal)
        }
        else {
            self.gender = "male"
            self.genderButton.setImage(UIImage(named: "male.png"), for: .normal)
        }
        self.userDefaults.setValue(self.gender, forKey: "gender")
        self.userDefaults.synchronize()
    }
}
