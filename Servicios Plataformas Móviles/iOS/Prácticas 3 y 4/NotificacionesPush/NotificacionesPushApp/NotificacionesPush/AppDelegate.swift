

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("En didFinishLaunchingWithOptions")
        UITabBar.appearance().barTintColor = UIColor.themeGreenColor
        UITabBar.appearance().tintColor = UIColor.white

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in print(granted)}
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func createNewNewsItem(text: String) {
        let date = Date()
        let newsItem = NewsItem(title: text, date: date)
        let newsStore = NewsStore.sharedStore
        newsStore.addItem(newsItem)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NewsFeedTableViewController.RefreshNewsFeedNotification), object: self)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = "Device Token: "
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Recibida notificación primer plano")
        let aps = notification.request.content.userInfo["aps"] as! [String: AnyObject]
        if let news = aps["alert"] as? String {
            createNewNewsItem(text: news + " (userNotificationCenter willPresent)")
        }
        // No mostramos la notificación
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Usuario ha pulsado una notificación")
        let aps = response.notification.request.content.userInfo["aps"] as! [String: AnyObject]
        if let news = aps["alert"] as? String {
            createNewNewsItem(text: news + " (userNotificationCenter didReceive)")
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Recibida notificación remota en background")
        if let news = userInfo["mensaje"] as? String {
            createNewNewsItem(text: news + " (UIApplication didReceiveRemoteNotification)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

