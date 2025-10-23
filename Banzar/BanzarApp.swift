//  Challenge9App.swift
//  Challenge09_Group8

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
