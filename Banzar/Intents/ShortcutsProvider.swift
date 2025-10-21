//
//  ShortcutsProvider.swift
//  Challenge09_Group8
//
//  Created by Marcos Albuquerque on 21/10/25.
//

import AppIntents

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
