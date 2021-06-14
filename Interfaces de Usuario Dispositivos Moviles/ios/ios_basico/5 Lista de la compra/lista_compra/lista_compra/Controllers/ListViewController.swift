//
//  ViewController.swift
//  lista_compra
//
//  Created by Yaser  on 20/11/2020.
//  Copyright © 2020 Yaser . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var listHelper = ListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = listHelper
        self.table.delegate = listHelper
    }
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! ItemViewController
        let name = sourceViewController.name
        let item = Item(name: name, isBought: false)
        listHelper.list.append(item)
        self.table.reloadData()
    }


}

