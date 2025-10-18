//
//  MenubarServiceView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 17.10.2025.
//

import SwiftUI

struct MenubarServiceView: View {
    
    @Binding var serviceManager: ServiceManager
    @State var provider: ServiceProvider
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                if serviceManager.providers[serviceManager.index(of: provider)].isFetching {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Image(systemName: serviceManager.providers[serviceManager.index(of: provider)].isRunning ? "play.circle.fill" : "stop.circle.fill")
                        .foregroundStyle(serviceManager.providers[serviceManager.index(of: provider)].isRunning ? Color.green : Color.red)
                }
                Text(provider.serviceName)
            }
            Spacer()
            
            if !serviceManager.providers[serviceManager.index(of: provider)].isFetching {
                if serviceManager.providers[serviceManager.index(of: provider)].isRunning {
                    Button(action: {
                        serviceManager.restart(for: provider)
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                    .frame(width: 20, height: 20)
                    .buttonStyle(.glass)
                    actionButton(
                        systemIcon: "stop.fill",
                        accentColor: .red,
                        run: {
                            serviceManager.set(
                                running: false,
                                for: provider
                            )
                        }
                    )
                } else {
                    actionButton(
                        systemIcon: "play.fill",
                        accentColor: .green,
                        run: {
                            serviceManager.set(
                                running: true,
                                for: provider
                            )
                        }
                    )
                }
            }
            
        }
        .padding(5)
        
    }
    
    @ViewBuilder
    func actionButton(
        systemIcon: String,
        accentColor: Color,
        run: @escaping () -> Void
    ) -> some View {
        Button(action: {
            run()
        }, label: {
            Image(systemName: systemIcon)
        })
        .frame(width: 20, height: 20)
        .accentColor(accentColor)
        .buttonStyle(.glassProminent)
    }
}

#Preview {
    MenubarServiceView(
        serviceManager: .constant(ServiceManager()),
        provider: ServiceProvider(
            serviceName: "Test"
        )
    )
}
