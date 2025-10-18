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
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(serviceManager.providers) { provider in
                MenubarServiceView(serviceManager: $serviceManager, provider: provider)
                    .background(Color(nsColor: .tertiarySystemFill))
                    .cornerRadius(10)
            }
            HStack {
                Button(action: {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    openWindow(id: "details-window")
                }, label: {
                    HStack {
                        Image(systemName: "text.and.command.macwindow")
                        Text("Details")
                    }
                    .frame(maxWidth: .infinity)
                })
                .buttonStyle(.glass)
                
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
                .buttonStyle(.glass)
            }
        }
        .padding(5)
        .frame(maxWidth: 200)
    }
}

#Preview {
    MenubarView(serviceManager: .constant(ServiceManager()))
}
