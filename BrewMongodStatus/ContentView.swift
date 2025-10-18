//
//  ContentView.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedProvider: ServiceProvider = ServiceProvider.allCases.first!
    @Binding var serviceManager: ServiceManager

    var body: some View {
        VStack {
            Table(serviceManager.info[selectedProvider]!.output) {
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
                if serviceManager.info[selectedProvider]!.isFetching {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.horizontal, 10)
                } else {
                    HStack {
                        Image(systemName: serviceManager.info[selectedProvider]!.isRunning ? "play.circle.fill" : "stop.circle.fill")
                            .foregroundColor(serviceManager.info[selectedProvider]!.isRunning ? Color.green : Color.red)
                        Text(serviceManager.info[selectedProvider]!.isRunning ? "Running" : "Stopped")
                            .foregroundColor(serviceManager.info[selectedProvider]!.isRunning ? Color.green : Color.red)
                    }
                    .padding(.horizontal, 8)
                }
            }
            if !serviceManager.info[selectedProvider]!.isFetching && serviceManager.info[selectedProvider]!.isRunning {
                toolbarButton(
                    systemImage: "arrow.clockwise",
                    text: "Restart",
                    run: {
                        serviceManager.restart(for: selectedProvider)
                    }
                )
                toolbarButton(
                    systemImage: "stop.fill",
                    text: "Stop",
                    run: {
                        serviceManager.set(running: false, for: selectedProvider)
                    }
                )
            } else if !serviceManager.info[selectedProvider]!.isFetching && !serviceManager.info[selectedProvider]!.isRunning {
                toolbarButton(
                    systemImage: "play.fill",
                    text: "Start",
                    run: {
                        serviceManager.set(running: true, for: selectedProvider)
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
        Picker("Provider", selection: $selectedProvider) {
            ForEach(ServiceProvider.allCases) { provider in
                Text(provider.rawValue)
                .tag(provider)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    ContentView(serviceManager: .constant(ServiceManager()))
}
