//
//  ListDataSource.swift
//  lista_compra
//
//  Created by Yaser  on 20/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var list: [Item] = [
        Item(name: "Queso", isBought: false),
        Item(name: "Agua", isBought: true),
        Item(name: "Leche", isBought: false),
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        if list[indexPath.row].isBought {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            else {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            self.list[indexPath.row].isBought = !self.list[indexPath.row].isBought
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
