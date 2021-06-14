//
//  DetailViewController.swift
//  MisTenedores
//
//  Created by Yaser  on 01/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.restaurant.name
        self.restaurantImage!.image = self.restaurant.image
        
        self.infoTableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.infoTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.infoTableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func close(segue: UIStoryboardSegue) {
        if let reviewViewController = segue.source as? ReviewViewController {
            if let rating = reviewViewController.ratingSelected {
                self.restaurant.rating = rating
                self.infoTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.restaurant = self.restaurant
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            if let bestPlates = restaurant.bestPlates?.count {
                return bestPlates
            }
            else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                case 0:
                    cell.keyLabel.text = "Tipo"
                    cell.valueLabel.text = self.restaurant.type
                case 1:
                    cell.keyLabel.text = "Valoración"
                    if self.restaurant.rating == "rating" {
                        cell.valueLabel.text = "Sin valorar"
                    }
                    else {
                        cell.valueLabel.text = self.restaurant.rating
                    }
                case 2:
                    cell.keyLabel.text = "Dirección"
                    cell.valueLabel.text = self.restaurant.location
                case 3:
                    cell.keyLabel.text = "Teléfono"
                    cell.valueLabel.text = self.restaurant.phone
                case 4:
                    cell.keyLabel.text = "Página web"
                    cell.valueLabel.text = self.restaurant.web
                default:
                    break
                }
        case 1:
            if indexPath.row == 0 {
                cell.keyLabel.text = "Mejores platos"
            }
            else {
                cell.keyLabel.text = ""
            }
            cell.valueLabel.text = self.restaurant.bestPlates[indexPath.row]
        default:
            break
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "Información general"
        case 1:
            title = "Platos estrella"
        default:
            break
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 2:
                self.performSegue(withIdentifier: "showMap", sender: nil)
            case 3:
                self.createAlert()
            case 4:
                if let website = URL(string: self.restaurant.web) {
                    let app = UIApplication.shared
                    if app.canOpenURL(website) {
                        app.open(website, options: [:], completionHandler: nil)
                    }
                }
            default:
                break
        }
    }
    
    private func createAlert() {
        let alertController = UIAlertController(title: "Contactar con \(self.restaurant.name)", message: "¿Cómo quieres contactar?", preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "Llamar", style: .default, handler: { (action) in
            if let phone = URL(string: "tel://\(self.restaurant.phone)") {
                let app = UIApplication.shared
                if app.canOpenURL(phone) {
                    app.open(phone, options: [:], completionHandler: nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(callAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
