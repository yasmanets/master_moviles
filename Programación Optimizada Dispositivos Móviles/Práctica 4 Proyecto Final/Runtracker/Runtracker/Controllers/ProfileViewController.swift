//
//  ProfileViewController.swift
//  Runtracker
//
//  Created by Yaser  on 25/4/21.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var saveData: UIButton!
    
    private var gender: String = "male"
    private let db = Firestore.firestore()
    
    private var email = ""
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email = self.userDefaults.string(forKey: "email") ?? ""
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
        db.collection("users").document(self.email).getDocument {
            (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let image = document.get("image") as? Data {
                    self.profileImage.image = UIImage(data: image, scale: 1.0)
                }
                else {
                    self.profileImage.image = UIImage(named: "profile.png")
                }
                if let name = document.get("name") as? String {
                    self.nameLabel.text = name
                }
                else {
                    self.nameLabel.text = "Nombre"
                }
                if let gender = document.get("gender") as? String {
                    if gender == "male" {
                        self.genderButton.setImage(UIImage(named: "male.png"), for: .normal)
                        self.gender = gender
                    }
                    else {
                        self.genderButton.setImage(UIImage(named: "female.png"), for: .normal)
                        self.gender = gender
                    }
                }
                if let weight = document.get("weight") as? String {
                    self.weightLabel.text = weight
                }
                else {
                    self.weightLabel.text = "000"
                }
                if let age = document.get("age") as? String {
                    self.ageLabel.text = age
                }
                else {
                    self.ageLabel.text = "00"
                }
                if let height = document.get("height") as? String {
                    self.heightLabel.text = height
                }
                else {
                    self.heightLabel.text = "000"
                }
            }
            else {
                self.profileImage.image = UIImage(named: "profile.png")
                self.nameLabel.text = "Nombre"
                self.weightLabel.text = "000"
                self.ageLabel.text = "00"
                self.heightLabel.text = "000"
            }
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
    
    @IBAction func save(_ sender: Any) {
        if let email = self.userDefaults.string(forKey: "email") {
            db.collection("users").document(email).setData([
                "name": self.nameLabel.text!,
                "gender": self.gender,
                "weight": self.weightLabel.text!,
                "age": self.ageLabel.text!,
                "height": self.heightLabel.text!,
                "image": self.profileImage.image?.pngData()! ?? ""
            ])
        }
        
    }
}
