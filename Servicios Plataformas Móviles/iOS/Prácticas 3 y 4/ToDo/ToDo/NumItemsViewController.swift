//
//  NumItemsViewController.swift
//  ToDoList
//
//  Created by Domingo on 12/5/15.
//  Copyright (c) 2015 Universidad de Alicante. All rights reserved.
//

import UIKit
import UserNotifications

extension UNNotificationAttachment {
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = image.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}

class NumItemsViewController: UIViewController {

    var terminados = 0
    @IBOutlet weak var numItems: UILabel!
    let store = NSUbiquitousKeyValueStore.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.terminados = Int(self.store.longLong(forKey: "terminados"))
        numItems.text = "Se han completado \(terminados) ítems."
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendNotification(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Notificación local"
        content.body = "Esto es una notificación de prueba para la práctica 3 de la asignatura"
        content.sound = UNNotificationSound.default
        if let attachment = UNNotificationAttachment.create(identifier: "Prueba",
                                                            image: UIImage(named: "ulompi.png")!,
                                                            options: nil) {
            content.attachments = [attachment]
        }
        content.userInfo = ["Mensaje": "Esto es una notificación local para la práctica 3 de SPM"]
        content.categoryIdentifier = "practicaNotificaciones"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let requestIdentifier = "practicaNotificaciones"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {
            (error) in
            if (error != nil) {
                print("Error al lanzar la notificación: \(String(describing: error))")
            }
            else {
                print("Notificación lanzada con éxito")
            }
        }
    }
    
    func displayAlert(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let accept = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(accept)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
