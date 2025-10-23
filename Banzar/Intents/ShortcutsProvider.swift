//  ShortcutsProvider.swift
//  Challenge09_Group8

import AppIntents

// Define um provedor de Atalhos da Siri
// É assim que o app "ensina" a Siri quais frases podem ativar suas Ações (Intents).
struct BanzouShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: BanzarIntent(),
            phrases: [
                "Veja se é hora de \(.applicationName)",
                "Checar hora de \(.applicationName)",
                "É hora de \(.applicationName)?",
                "Vamos \(.applicationName)",
                "\(.applicationName) está na hora?",
                "Hora de \(.applicationName)",
                "Let's \(.applicationName)",
                "\(.applicationName) time",
                "is it \(.applicationName) time?",
                "I want \(.applicationName)"
            ],
            shortTitle: "check banzos time",
            systemImageName: "clock.fill"
        )
    ]
}
