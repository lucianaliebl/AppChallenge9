//  NotificationManager.swift
//  Challenge09_Group8

import UserNotifications
import CloudKit

class NotificationManager {
    
    static let shared = NotificationManager() // É o "chefe" das notificações.
    
    init() {
        // Criando a Inscrição
        // basicamente tá dizendo ao iCloud: "Ei, fica de olho nisso pra mim!"
        let subscription = CKQuerySubscription (
            recordType: "Aviso", // O que você vai ficar de olho? Coisas do tipo "Aviso".
            predicate: NSPredicate(value: true), // Tem algum filtro? Não. 'true' = "Pega TUDO".
            subscriptionID: subscriptionID,
            options: .firesOnRecordCreation // me avisar quando algo novo for criado.
        )
        
        // PREPARANDO A MENSAGEM
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Banzooouuu!"
        notification.alertBody = "Passando para lembrar que é hora de Banzar"
        notification.shouldBadge = true // Isso faz aparecer a bolinha vermelha no ícone do app
        notification.soundName = "default" // Faz o barulhinho padrão de notificação
    
        // JUNTANDO TUDO
        subscription.notificationInfo = notification
        
        // ENVIANDO PARA O ICLOUD
        CKContainer.default().publicCloudDatabase.save(subscription) { (subscription, error) in
            if let error = error {
                print("Erro ao criar inscrição \(error)")
            } else {
                print("Inscrição criada com sucesso!")
            }
        }
    }
    
    // Esta é a função que "puxa o gatilho".
    func EnviarNotificação() {
        
        // criar exatamente a coisa que o iCloud está esperando: um registro do tipo "Aviso".
        let record = CKRecord(recordType: "Aviso")
        // tem que botar alguma coisa dentro dele, senão não salva.
        record["Banzos"] = "Hora de Banzar"
        
        // Agora salva esse registro novo lá no iCloud...
        CKContainer.default().publicCloudDatabase.save(record) {  _, error in
            if let error = error {
                        print("Erro ao salvar record: \(error)")
                    } else {
                        // Se o registro foi salvo com sucesso, o iCloud percebe!
                        // Ele vê: "Opa, criaram um 'Aviso'!"
                        // Aí ele procura a nossa "inscrição" (a 'subscription') e... BUM!
                        // Dispara a notificação que a gente escreveu lá no 'init' pra todo mundo.
                        print("Record criado, subscription deve disparar push!")
                    }
        }
    }
}
