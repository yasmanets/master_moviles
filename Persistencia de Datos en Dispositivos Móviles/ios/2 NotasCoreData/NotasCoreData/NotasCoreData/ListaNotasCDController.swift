//
//  ListaNotasCDController.swift
//  NotasCoreData
//
//  Created by Yaser  on 13/12/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit
import CoreData

class ListaNotasCDController: UITableViewController, NSFetchedResultsControllerDelegate {

    var frc: NSFetchedResultsController<Nota>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = UIApplication.shared.delegate! as! AppDelegate
        let myContext = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<Nota>(entityName: "Nota")
        let sortText = NSSortDescriptor(key: "texto", ascending: true)
        let sortDate = NSSortDescriptor(key: "fecha", ascending: true)
        request.sortDescriptors = [sortText, sortDate]
        self.frc = NSFetchedResultsController<Nota>(fetchRequest: request, managedObjectContext: myContext, sectionNameKeyPath: "inicial", cacheName: "cache")
        try! self.frc.performFetch()
        self.frc.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.frc.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.frc.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaFetched", for: indexPath)
        let note = self.frc.object(at: indexPath)
        cell.textLabel?.text = note.texto
        cell.detailTextLabel?.text = note.libreta?.nombre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let myContext = delegate.persistentContainer.viewContext
            let note = self.frc.object(at: indexPath)
            myContext.delete(note)
            try! myContext.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.frc.sections![section].name
    }

    // MARK: - Fetched Results Controller Delefate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with:.automatic)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            self.tableView.insertRows(at: [newIndexPath!], with:.automatic )
        default:
            print("Se ha producido un error")
        }
    }

}
