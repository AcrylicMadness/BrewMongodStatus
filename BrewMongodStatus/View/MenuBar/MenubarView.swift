//
//  MenubarView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 17.10.2025.
//

import SwiftUI

struct MenubarView: View {
    
    @Binding var serviceManager: ServiceManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            
            if serviceManager.providers.isEmpty {
                EmptyProvidersView(serviceManager: $serviceManager, inMenu: true)
            } else {
                ForEach($serviceManager.providers) { provider in
                    MenuServiceProviderView(
                        provider: provider,
                        serviceManager: $serviceManager
                    )
                }
            }
            HStack(spacing: 2) {
                Button(action: {
                    dismissWindow()
                    openWindow(id: "details-window")
                    NSApplication.shared.setActivationPolicy(.regular)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    var possibleWindowTitles = serviceManager.providers.map({ $0.serviceName })
                    possibleWindowTitles.append("Brew Service Control")
                    if let mainWindow = NSApplication.shared.windows.first(where: { possibleWindowTitles.contains($0.title) }) {
                        mainWindow.orderFrontRegardless()
                        mainWindow.makeKey()
                        mainWindow.makeKeyAndOrderFront(nil)
                        mainWindow.becomeKey()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "text.and.command.macwindow")
                        Text("Details")
                    }
                    .frame(maxWidth: .infinity)
                })
                .cornerRadius(10)
                Button(action: {
                    NSApp.terminate(nil)
                }, label: {
                    HStack {
                        Image(systemName: "x.square")
                        Text("Quit")
                    }
                    .frame(maxWidth: .infinity)
                })
                .foregroundStyle(.red)
                .cornerRadius(10)
            }
        }
        .padding(5)
        .frame(maxWidth: 250)
    }
}

#Preview {
    MenubarView(serviceManager: .constant(ServiceManager()))
}
