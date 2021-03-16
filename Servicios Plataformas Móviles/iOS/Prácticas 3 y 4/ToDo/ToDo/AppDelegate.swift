//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Domingo on 10/5/15.
//  Copyright (c) 2015 Universidad de Alicante. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var actionSelected = ""
    var messageText = ""
    let store = NSUbiquitousKeyValueStore.default

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (store.synchronize()) {
            print("synchronize ok")
        }
        else {
            print("synchronize ko")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in print(granted)}
        
        let accept = UNNotificationAction(identifier: "accept", title: "Acepto", options: [])
        let reject = UNNotificationAction(identifier: "reject", title: "Rechazo", options: [])
        let message = UNTextInputNotificationAction(identifier: "message", title: "Mensaje", options: [], textInputButtonTitle: "Enviar", textInputPlaceholder: "Introduce el mensaje")
        let category = UNNotificationCategory(identifier: "practicaNotificaciones", actions: [accept, reject, message], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = "Device token: "
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        let navigationController = self.window!.rootViewController as! UINavigationController
        let toDoTableViewController = navigationController.viewControllers[0] as! ToDoTableViewController
        toDoTableViewController.borraItems()
        
        if (self.actionSelected != "") {
            let numItemViewController = navigationController.viewControllers[1] as! NumItemsViewController
            numItemViewController.displayAlert(title: self.actionSelected, content: self.messageText)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Notificación recibida en primer plano
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let aps = notification.request.content.userInfo["aps"] as! [String: AnyObject]
        if let task = aps["alert"] as? String {
            updateToDoTable(task: task)
        }
        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if (response.notification.request.content.userInfo["aps"] != nil) {
            let aps = response.notification.request.content.userInfo["aps"] as! [String: AnyObject]
            if let task = aps["alert"] as? String {
                updateToDoTable(task: task)
            }
        }
        else {
            if let textInput = response as? UNTextInputNotificationResponse {
                self.messageText = "Texto del mensaje: \(textInput.userText)"
            }
            self.actionSelected = "Acción escogida: \(response.actionIdentifier)"
        }
        completionHandler()
    }
    
    // Notificación recibida en segundo plano
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let task = userInfo["mensaje"] as? String {
            updateToDoTable(task: task)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func updateToDoTable(task: String) {
        let navigationController = self.window!.rootViewController as! UINavigationController
        let toDoTableViewController = navigationController.viewControllers[0] as! ToDoTableViewController
        toDoTableViewController.addNewItem(task: self.messageText)
    }
}

