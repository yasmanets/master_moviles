//
//  MasterViewController.swift
//  ejercicio_search
//
//  Created by Yaser  on 14/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating {
  
    var detailViewController: DetailViewController? = nil
    var objects = [String]()
    private var searchController : UISearchController?
    private var searchResults = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.objects = ["En", "un", "lugar", "de", "la", "mancha", "de", "cuyo", "nombre"];
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        //SE crea una tabla alternativa para ver los resultados
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self
        
        // Se asigna la tabla al controlador de búsqueda
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController?.searchResultsUpdater = self
        
        // Se especifica el tamaño de la barra de búsqueda
        if let frame = self.searchController?.searchBar.frame {
            self.searchController?.searchBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 44.0)
        }
        // Se añade a la cabecera de la tabla
        self.tableView.tableHeaderView = self.searchController?.searchBar
        // Se indica que la tabla de búsqueda se superpone a la existente
        self.definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Table View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let object : String

            if let indexPath = self.tableView.indexPathForSelectedRow {
                 object = self.objects[indexPath.row]
            }
            else {
                let sc = self.searchController?.searchResultsController as! UITableViewController
                object = self.searchResults[(sc.tableView.indexPathForSelectedRow?.row)!]
            }
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let src = self.searchController?.searchResultsController as! UITableViewController
        if tableView == src.tableView {
            return self.searchResults.count
        }
        else {
            return self.objects.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let src = self.searchController?.searchResultsController as! UITableViewController
        let object: String?
        
        if tableView == src.tableView {
            object = self.searchResults[indexPath.row]
        }
        else {
            object = objects[indexPath.row]
        }
        
        cell.textLabel!.text = object?.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // Método delegado encargado de actualizar los datos de la tabla
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = self.searchController?.searchBar.text
        if searchString == nil || searchString == "" {
            self.searchResults = self.objects
        }
        else {
            // Si la búsqueda no es vacía, se copian en searchResults los resultados que coinciden
            let searchPredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", searchString!)
            let array = (self.objects as NSArray).filtered(using: searchPredicate)
            self.searchResults = array as! [String]
        }
        
        // Se recargan los datos de la tabla
        let tvc = self.searchController?.searchResultsController as! UITableViewController
        tvc.tableView.reloadData()
        
        // SE deselecciona la celda de la tabla principal
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: false)
        }
      }


}

