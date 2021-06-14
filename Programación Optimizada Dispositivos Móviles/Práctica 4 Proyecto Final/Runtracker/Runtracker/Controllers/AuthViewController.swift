//
//  AuthViewController.swift
//  Runtracker
//
//  Created by Yaser  on 9/6/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextFiel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var vStackView: UIStackView!
    
    private let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Autenticación"
        // Do any additional setup after loading the view.
        
        // Se comprueba si el usuario ha iniciado sesión
        if let email = userDefaults.string(forKey: "email") {
            self.vStackView.isHidden = true
            self.navigationController?.isToolbarHidden = true
            self.performSegue(withIdentifier: "tabBar", sender: nil)
        }
        
        // Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vStackView.isHidden = false
        
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        if let email = self.emailTextFiel.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                self.loadTabBarController(result: result, error: error, email: email)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let email = self.emailTextFiel.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                self.loadTabBarController(result: result, error: error, email: email)
            }
        }
    }
    
    @IBAction func googleAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func loadTabBarController (result: AuthDataResult?, error: Error?, email: String) {
        if let _ = result, error == nil {
            self.userDefaults.setValue(email, forKey: "email")
            self.userDefaults.synchronize()
            self.performSegue(withIdentifier: "tabBar", sender: nil)
        }
        else {
            let alertController = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                let email = user.profile.email!
                print(email)
                self.loadTabBarController(result: result, error: error, email: email)
            }
        }
    }
}
