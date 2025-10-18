//
//  BrewMongodStatusApp.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import SwiftUI

@main
struct BrewMongodStatusApp: App {
    
    @State var serviceManager: ServiceManager = ServiceManager.shared
    
    @AppStorage("open_window_on_launch")
    private var openWindowOnLaunch: Bool = true
    
    var body: some Scene {
        Window("Brew Service Control", id: "details-window") {
            ServicesView(serviceManager: $serviceManager)
                .navigationTitle(serviceManager.selectedProvider?.serviceName ?? "Brew Service Control")
                .onAppear {
                    NSApplication.shared.setActivationPolicy(.regular)
                }
                .onDisappear {
                    NSApplication.shared.setActivationPolicy(.accessory)
                }
        }
        .defaultLaunchBehavior(openWindowOnLaunch ? .presented : .suppressed)

        MenuBarExtra("DB Status", systemImage: "server.rack") {
            MenubarView(serviceManager: $serviceManager)
        }
        .menuBarExtraStyle(.window)
    }
}
