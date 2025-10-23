//  Banzarintent.swift
//  Challenge09_Group8

import AppIntents
import Foundation

// Define a "Ação" principal que a Siri e o app Atalhos podem executar.
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
            dialogo = "Hora de Banzar! Mandando lembrete para todo mundo!"
        } else {
            dialogo = "Não é hora de Banzar! Vá trabalhar!"
        }
        return .result(dialog: dialogo)
    }
}
