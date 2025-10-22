import UserNotifications
import SwiftUI
import CloudKit

let subscriptionID = "Challenge09"


class AppDelegate: NSObject, UIApplicationDelegate {
    var app: BanzarApp?
    
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
         didReceive response: UNNotificationResponse) async {
        print("Notificação recebida com o título: \(response.notification.request.content.title)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification)
        async -> UNNotificationPresentationOptions {

        return [.badge, .banner, .list, .sound]
    }


}
