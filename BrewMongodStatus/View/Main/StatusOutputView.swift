//
//  StatusOutputView.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import SwiftUI

struct StatusOutputView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var serviceManager: ServiceManager

    var body: some View {
        VStack {
            Table(serviceManager.info[serviceManager.selectedProvider]!.output) {
                TableColumn("Output") { output in
                    Text(output.text)
                        .textSelection(.enabled)
                        .fontDesign(.monospaced)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                providerSelector
            }
            ToolbarItem(placement: .cancellationAction) {
                if serviceManager.info[serviceManager.selectedProvider]!.isFetching {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal, 10)
                } else {
                    HStack {
                        Image(systemName: serviceManager.info[serviceManager.selectedProvider]!.isRunning ? "play.circle.fill" : "stop.circle.fill")
                            .foregroundColor(serviceManager.info[serviceManager.selectedProvider]!.isRunning ? Color.green : Color.red)
                        Text(serviceManager.info[serviceManager.selectedProvider]!.isRunning ? "Running" : "Stopped")
                            .foregroundColor(serviceManager.info[serviceManager.selectedProvider]!.isRunning ? Color.green : Color.red)
                    }
                    .padding(.horizontal, 8)
                }
            }
            if !serviceManager.info[serviceManager.selectedProvider]!.isFetching && serviceManager.info[serviceManager.selectedProvider]!.isRunning {
                toolbarButton(
                    systemImage: "arrow.clockwise",
                    text: "Restart",
                    run: {
                        serviceManager.restart(for: serviceManager.selectedProvider)
                    }
                )
                toolbarButton(
                    systemImage: "stop.fill",
                    text: "Stop",
                    run: {
                        serviceManager.set(running: false, for: serviceManager.selectedProvider)
                    }
                )
            } else if !serviceManager.info[serviceManager.selectedProvider]!.isFetching && !serviceManager.info[serviceManager.selectedProvider]!.isRunning {
                toolbarButton(
                    systemImage: "play.fill",
                    text: "Start",
                    run: {
                        serviceManager.set(running: true, for: serviceManager.selectedProvider)
                    }
                )
            }
        }
        .navigationTitle("DB Service Status")
    }
    
    @ToolbarContentBuilder
    func toolbarButton(
        systemImage: String,
        text: LocalizedStringKey,
        run: @escaping () -> Void
    ) -> some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                run()
            } label: {
                HStack {
                    Image(systemName: systemImage)
                    Text(text)
                }
                .padding(4)
            }
        }
    }
    
    @ViewBuilder
    var providerSelector: some View {
        Picker("Provider", selection: $serviceManager.selectedProvider) {
            ForEach($serviceManager.providers) { provider in
                Text(provider.wrappedValue.serviceName)
                    .tag(provider.wrappedValue)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    StatusOutputView(serviceManager: .constant(ServiceManager()))
}
