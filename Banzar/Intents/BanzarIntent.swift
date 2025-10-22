//
//  Banzarintent.swift
//  Challenge09_Group8
//
//  Created by Marcos Albuquerque on 21/10/25.
//

import AppIntents
import Foundation

struct BanzarIntent: AppIntent {
    static var title: LocalizedStringResource = "Its Banzos Time"
    static var description: IntentDescription = "Tell me if is banzos tiXme and notifies everyone"
    
    private var notificationManager = NotificationManager()
    
    @MainActor
    func perform() async throws -> some ProvidesDialog {
        let dataAtual = Date()

        let hora = "\(Calendar.current.component(.hour, from: dataAtual))\(Calendar.current.component(.minute, from: dataAtual))"

        let intervalo = ["inicio": "1550", "fim": "1630"]
        
        var dialogo: IntentDialog

        if hora >= intervalo["inicio"]! && hora <= intervalo["fim"]! {
            notificationManager.EnviarNotificação()
            dialogo = "Hora de Banzar! Mandando notificação para todo mundo!"
        } else {
            dialogo = "Ainda não é hora de Banzar!"
        }
        return .result(dialog: dialogo)
    }
}
