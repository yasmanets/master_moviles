//
//  TableViewController.swift
//  ejercicio_celdas
//
//  Created by Yaser  on 12/11/2020.
//

import UIKit

class TableViewController: UITableViewController {

    var books: [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mi tabla personalizada"
        
        var book = Book(title: "Desarrollo de aplicaciones Android seguras", author: "Miguel Ángel Moreno", imagen: UIImage(named: "android.png")!)
        books.append(book)
        book = Book(title: "Pentesting con Foca", author: "Chema Alonso", imagen: UIImage(named: "foca.png")!)
        books.append(book)
        book = Book(title: "Hacking de dispositivos iOS", author: "Chema Alonso", imagen: UIImage(named: "ios.png")!)
        books.append(book)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        cell.labelTitle?.text = books[indexPath.row].title
        cell.labelAuthor?.text = books[indexPath.row].author
        cell.imagen?.image = books[indexPath.row].imagen
        if indexPath.row % 2 == 0 {
            cell.fondo?.image = UIImage(named: "fondo_celda1.png")
        }
        else {
            cell.fondo?.image = UIImage(named: "fondo_celda2.png")
        }
        return cell
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
