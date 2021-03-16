//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Domingo on 10/5/15.
//  Copyright (c) 2015 Universidad de Alicante. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var toDoItems = [ToDoItem]()
    var itemsTerminados = 0
    var itemsStored = 0
    let store = NSUbiquitousKeyValueStore.default
    
    func borraItems() {
        var itemsPendientes = [ToDoItem]()
        for toDoItem in toDoItems {
            if (!toDoItem.completado) {
                itemsPendientes.append(toDoItem)
            } else {
                itemsTerminados += 1
                Task.deleteTask(taskName: toDoItem.nombreItem) { result in
                    print(result)
                }
            }
        }
        toDoItems = itemsPendientes
        tableView.reloadData()
    }
    
    func getTasks() {
        Task.fetchPrivateTasks() { result in
            switch result {
            case .failure( _):
              let alert = UIAlertController(title: "Error", message: "Se ha producido un error al obtener las tareas de iCloud", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true, completion: nil)
            case .success(let tasks):
                for item in tasks {
                    self.toDoItems.append(ToDoItem(nombre: item.nombre!))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        Task.fetchPublicTasks() { result in
            switch result {
            case .failure( _):
              let alert = UIAlertController(title: "Error", message: "Se ha producido un error al obtener las tareas de iCloud", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true, completion: nil)
            case .success(let tasks):
                for item in tasks {
                    let toDoItem = ToDoItem(nombre: item.nombre!)
                    toDoItem.type = 1
                    self.toDoItems.append(toDoItem)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler:
            {(settings: UNNotificationSettings) in
                if (settings.alertSetting == UNNotificationSetting.disabled || settings.badgeSetting == UNNotificationSetting.disabled) {
                    self.openSettings()
                }
            })
        self.getTasks()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.itemsStored = Int(self.store.longLong(forKey: "terminados"))
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func refresh() {
        self.toDoItems.removeAll()
        self.getTasks()
        self.tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPrototypeCell", for: indexPath) 

        // Configure the cell...

        let toDoItem = toDoItems[indexPath.row]
        cell.textLabel!.text = toDoItem.nombreItem
        if (toDoItem.type == 1) {
            cell.textLabel?.textColor = UIColor.red
        }
        if (toDoItem.completado) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let itemPulsado = toDoItems[indexPath.row]
        itemPulsado.completado = !itemPulsado.completado
        itemPulsado.fechaFinalizacion = Date()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unWindToList(_ segue: UIStoryboardSegue) {
        let fuente: AddToDoItemViewController = segue.source as! AddToDoItemViewController
        if let item = fuente.toDoItem {
            toDoItems.append(item)
            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsTerminados" {
            /*if let destinationVC = segue.destination as? NumItemsViewController {
                borraItems()
                destinationVC.terminados = itemsTerminados
            }*/
            borraItems()
            if (itemsTerminados > 0) {
                self.store.set(itemsTerminados + itemsStored, forKey: "terminados")
                self.store.synchronize()
            }
        }
    }
    
    func openSettings() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Se necesitan los permisos para enviar notificaciones", message: "Por favor, habilita los permisos", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Ajustes", style: .default, handler: {action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            alert.preferredAction = settingsAction
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addNewItem(task: String) {
        let item = ToDoItem(nombre: task)
        self.toDoItems.append(item)
        self.tableView.reloadData()
    }
}
