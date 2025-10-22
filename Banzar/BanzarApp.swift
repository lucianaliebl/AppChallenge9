//
//  Challenge9App.swift
//  Challenge9
//
//  Created by Luciana Liebl de Freitas on 21/10/25.
//

import SwiftUI

@main
struct BanzarApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    appDelegate.app = self
                }
        }
    }
}
