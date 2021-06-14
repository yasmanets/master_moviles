//
//  ListaNotasController.swift
//  NotasCoreData
//
//  Created by Yaser  on 12/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit
import CoreData

class ListaNotasController: UITableViewController, UISearchResultsUpdating {
    
    var listaNotas: [Nota]!
    var fullNotes: [Nota]!
    let searchController = UISearchController(searchResultsController: nil)
    let throttlet = Throttler(minimumDelay: 0.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listaNotas = []
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar texto"
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        guard let coreDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let myContext = coreDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Nota> = NSFetchRequest(entityName: "Nota")
        if let notas = try? myContext.fetch(request) {
            self.listaNotas = notas
            self.fullNotes = notas
            self.tableView.reloadData()
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaNotas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        cell.textLabel?.text = self.listaNotas[indexPath.row].texto
        cell.detailTextLabel?.text = self.listaNotas[indexPath.row].libreta?.nombre
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        throttlet.throttle {
            let texto = searchController.searchBar.text!
            if texto.isEmpty {
                self.listaNotas = self.fullNotes
                self.tableView.reloadData()
                return
            }
            guard let coreDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let myContext = coreDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<Nota>(entityName: "Nota")
            let predicate = NSPredicate(format: "texto CONTAINS[c] '\(texto)'")
            let sortDate = NSSortDescriptor(key: "fecha", ascending: false)
            request.predicate = predicate
            request.sortDescriptors = [sortDate]
            let filteredNotes = try! myContext.fetch(request)
            self.listaNotas = filteredNotes
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
