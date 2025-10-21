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
    static var description: IntentDescription = "Tell me if is banzos time and notifies everyone"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let dataAtual = Date()

        let hora = "\(Calendar.current.component(.hour, from: dataAtual))\(Calendar.current.component(.minute, from: dataAtual))"

        let intervalo = ["inicio": "1550", "fim": "1630"]

        if hora >= intervalo["inicio"]! && hora <= intervalo["fim"]! {
            print("Entrou no intervalo")
        }
        else{
            print("NÃO É HORA DE BANZAR!")
        }
        return .result()
    }
}
