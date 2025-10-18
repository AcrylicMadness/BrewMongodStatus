//
//  ServiceProviderView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct ServiceProviderView: View {
    
    @Binding var provider: ServiceProvider
    @Binding var serviceManager: ServiceManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(provider.serviceName)
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(
                        provider == serviceManager.selectedProvider ?
                            Color.white :
                            .primary
                    )
                HStack(spacing: 4) {
                    if provider.isFetching {
                        ProgressView()
                            .controlSize(.mini)
                            .foregroundStyle(
                                provider == serviceManager.selectedProvider ?
                                    Color.white :
                                    .primary
                            )
                    } else {
                        Image(
                            systemName: provider.isRunning ? 
                                "checkmark.circle.fill" :
                                "x.circle.fill"
                        )
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(
                            provider == serviceManager.selectedProvider ? Color.white :
                                (provider.isRunning ? Color.green : Color.red)
                        )
                    }
                    Text(
                        provider.isFetching ?
                        "Loading" : (provider.isRunning ? "Running" : "Stopped")
                    )
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(
                        provider == serviceManager.selectedProvider ? Color.white :
                            provider.isFetching ? .primary :
                            (provider.isRunning ? Color.green : Color.red)
                    )
                }
                .opacity(0.7)
            }
            Spacer()
            if !provider.isFetching {
                if provider.isRunning {
                    button(systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill") {
                        serviceManager.restart(for: provider)
                    }
                    button(systemImage: "stop.fill") {
                        serviceManager.set(running: false, for: provider)
                    }
                } else {
                    button(systemImage: "play.fill") {
                        serviceManager.set(running: true, for: provider)
                    }
                }
            }
            
        }
        .padding(6)
        .contentShape(Rectangle())
        .background {
            if provider == serviceManager.selectedProvider {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accent)
            }
        }
        .onTapGesture {
            serviceManager.selectedProvider = provider
        }
    }
    
    @ViewBuilder
    func button(
        systemImage: String,
        _ run: @escaping () -> Void
    ) -> some View {
        Button {
            run()
        } label: {
            Image(systemName: systemImage)
        }
        .frame(width: 25, height: 25)
    }
}

#Preview {
    ServiceProviderView(
        provider: .constant(
            ServiceProvider(serviceName: "service")
        ),
        serviceManager: .constant(
            ServiceManager()
        )
    )
}
