//
//  AddToDoItemViewController.swift
//  ToDoList
//
//  Created by Domingo on 10/5/15.
//  Copyright (c) 2015 Universidad de Alicante. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {

    var toDoItem: ToDoItem? = nil
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func viewDidLoad() {
        self.switchButton.isOn = false
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (saveButton.isEqual(sender)) && (textField.text!.count > 0) {
            toDoItem = ToDoItem(nombre: textField.text!)
            if (self.switchButton.isOn) {
                toDoItem?.type = 1
                Task.savePublicTask(task: textField.text!) { result in
                    print(result)
                }
            }
            else {
                Task.savePrivateTask(task: textField.text!) { result in
                    print(result)
                }
            }
        }
    }
}
