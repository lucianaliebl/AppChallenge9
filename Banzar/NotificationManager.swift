import UserNotifications
import CloudKit

class NotificationManager {
    static let shared = NotificationManager()
    
    init() {
        let subscription = CKQuerySubscription (
            recordType: "Aviso",
            predicate: NSPredicate(value: true),
            subscriptionID: subscriptionID,
            options: .firesOnRecordCreation
        )
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Placeholder Titulo"
        notification.alertBody = "Placeholder Mensagem"
        notification.shouldBadge = true
        notification.soundName = "default"
    
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { (subscription, error) in
            if let error = error {
                print("Erro ao criar inscrição \(error)")
            } else {
                print("Inscrição criada com sucesso!")
            }
        }
    }
    
    func EnviarNotificação() {
        let record = CKRecord(recordType: "Aviso")
        record["Banzos"] = "Hora de Banzar"
        
        print("Notificação enviada")
        
        CKContainer.default().publicCloudDatabase.save(record) {  _, error in
            if let error = error {
                        print("Erro ao salvar record: \(error)")
                    } else {
                        print("Record criado, subscription deve disparar push!")
                    }
        }
    }
}
