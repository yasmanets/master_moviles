//
//  TableViewController.swift
//  MisTenedores
//
//  Created by Yaser  on 30/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
        var restaurant = Restaurant(name: "Pizzeria Tito's", type: "Pizzería", image: UIImage(named: "titos")!, bestPlates: ["Ensaladilla rusa", "Huevos rotos", "Croquetas", "Pizza Margarita"], phone: "123456789", web: "https://pizzeriatitosalicante.es/", location: "Calle Médico Vicente Reyes, 1, 03015 Alicante")
        restaurants.append(restaurant)
        restaurant = Restaurant(name: "La Tía Juana", type: "Mexicano", image: UIImage(named: "tia-juana")!, bestPlates: ["Tacos", "Burritos", "Nachos"], phone: "123456789", web: "https://latiajuanamx.com/", location: "Rambla Méndez Núñez, 45, 03002 Alicante")
        restaurants.append(restaurant)
        restaurant = Restaurant(name: "Casa Yong", type: "Chino", image: UIImage(named: "casa-yong")!, bestPlates: ["Rollo de primavera", "Arroz Tres Delicia", "Ternera con Bambú"], phone: "965209283", web: "http://casayong.es/", location: "Calle Hogar Provincial, 1, 03559 Alicante")
        restaurants.append(restaurant)
        restaurant = Restaurant(name: "Templo", type: "Asador", image: UIImage(named: "templo")!, bestPlates: ["Cecina", "Steak Tartar", "Ensalada de perdiz escabechada"], phone: "965209283", web: "http://www.templorestaurante.com/", location: "Calle Periodista Pirula Arderius, 7, 03001 Alicante")
        restaurants.append(restaurant)
        restaurant = Restaurant(name: "La Fundición", type: "Asador", image: UIImage(named: "fundicion")!, bestPlates: ["Patatitas con boquerones y limón", "Mini crepa de marisco"], phone: "646932259", web: "https://www.https://lafundicionalicante.com/", location: "Carrer Poeta Pastor, 16, 03007 Alacant, Alicante")
        restaurants.append(restaurant)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        cell.restaurantName?.text = restaurants[indexPath.row].name
        cell.restaurantType?.text = restaurants[indexPath.row].type
        cell.restaurantImage?.image = restaurants[indexPath.row].image
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil, handler: {(action, view, completeionHander) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let shareAction = UIContextualAction(style: .normal, title: nil, handler: {(action, view, completeionHander) in
            let defaultText = "Creo que esta noche iré a cenar a \(self.restaurants[indexPath.row].name)"
            let activityController = UIActivityViewController(activityItems: [defaultText, self.restaurants[indexPath.row].image!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        })
        
        deleteAction.image = UIImage(named: "trash.png")
        deleteAction.backgroundColor = UIColor.red
        shareAction.image = UIImage(named: "share.png")
        shareAction.backgroundColor = UIColor.systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return configuration
    }
    
    // MARK: - UITableViewDelegate
        


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let restaurant = self.restaurants[indexPath.row]
                let detailController = segue.destination as! DetailViewController
                detailController.restaurant = restaurant
            }
        }
    }
    
    @IBAction func unwindMainViewController(segue: UIStoryboardSegue) {
        if let addController = segue.source as? AddRestaurantTableViewController {
            print("addControler")
            if let restaurant = addController.restaurant {
                self.restaurants.append(restaurant)
                self.tableView.reloadData()
            }
        }
    }
}
