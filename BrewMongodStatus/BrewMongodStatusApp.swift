//
//  BrewMongodStatusApp.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import SwiftUI

@main
struct BrewMongodStatusApp: App {
    
    @State var serviceManager: ServiceManager = ServiceManager()
    
    var body: some Scene {
        Window("DB Status", id: "details-window") {
            ContentView(serviceManager: $serviceManager)
        }
        MenuBarExtra("DB Status", systemImage: "server.rack") {
            MenubarView(serviceManager: $serviceManager)
        }
        .menuBarExtraStyle(.window)
    }
}
