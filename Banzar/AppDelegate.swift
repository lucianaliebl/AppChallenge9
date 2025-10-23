//  AppDelegate.swift
//  Challenge09_Group8

import UserNotifications
import SwiftUI
import CloudKit

// Define um ID de inscrição global
let subscriptionID = "Challenge09"

// O AppDelegate implementa métodos do ciclo de vida da aplicação.
class AppDelegate: NSObject, UIApplicationDelegate {
    var app: BanzarApp?
    
    // Esta função é chamada quando o processo de lançamento do aplicativo é concluído.
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // 1. Registro para Notificações Remotas
        // Inicia o processo de registro com o Apple Push Notification service (APNs).
        // Após a conclusão bem-sucedida, o método didRegisterForRemoteNotificationsWithDeviceToken será chamado.
        application.registerForRemoteNotifications()
        
        // 2. Definição do Delegate
        // Define esta classe (AppDelegate) como o delegate do UNUserNotificationCenter.
        // Isso permite que o app manipule notificações recebidas (quando o app está em foreground)
        // e ações do usuário (como tocar na notificação).
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

// Extensão do AppDelegate para conformar ao protocolo UNUserNotificationCenterDelegate.
// Isso centraliza a lógica de manipulação de notificações.
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Chamado quando o usuário interage com uma notificação.
    // O app pode estar em background ou terminado.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
         didReceive response: UNNotificationResponse) async {
        
        // Ação atual: apenas registra o título da notificação no console para depuração.
        print("Notificação recebida com o título: \(response.notification.request.content.title)")
    }

    // Chamado quando uma notificação é recebida enquanto o app está EM PRIMEIRO PLANO (foreground).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification)
        async -> UNNotificationPresentationOptions {
            // Por padrão, notificações recebidas em foreground são silenciosas.
            // Esta implementação instrui o iOS a apresentar a notificação visualmente (banner, lista) e com som, como se o app estivesse em background.
        return [.badge, .banner, .list, .sound]
    }


}
