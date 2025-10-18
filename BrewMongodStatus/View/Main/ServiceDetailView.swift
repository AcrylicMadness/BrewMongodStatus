//
//  ServiceDetailView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct ServiceDetailView: View {
    
    @Binding var serviceManager: ServiceManager
    
    var body: some View {
        if let selectedProvider = Binding($serviceManager.selectedProvider) {
            VStack(alignment: .leading) {
//                VStack {
//                    Text(serviceManager.selectedProvider?.serviceName ?? "Brew Service Control")
//                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
//                }
//                .padding(16)
                Table(selectedProvider.output) {
                    TableColumn("Raw output") { output in
                        Text(output.wrappedValue.text)
                            .textSelection(.enabled)
                            .fontDesign(.monospaced)
                    }
                }
            }
            .toolbar {
                if serviceManager.providers[serviceManager.selectedIndex].isFetching {
                    ToolbarItem(placement: .automatic) {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.horizontal, 10)
                    }
                } else {
                    if serviceManager.providers[serviceManager.selectedIndex].isRunning {
                        toolbarButton(
                            systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill",
                            text: "Restart"
                        ) {
                            serviceManager.restart(for: selectedProvider.wrappedValue)
                        }
                        toolbarButton(
                            systemImage: "stop.fill",
                            text: "Stop"
                        ) {
                            serviceManager.set(running: false, for: selectedProvider.wrappedValue)
                        }
                    } else {
                        toolbarButton(
                            systemImage: "play.fill",
                            text: "Start"
                        ) {
                            serviceManager.set(running: true, for: selectedProvider.wrappedValue)
                        }
                    }
                }
            }
        } else {
            Text("Error")
        }
    }
    
    @ToolbarContentBuilder
        func toolbarButton(
            systemImage: String,
            text: LocalizedStringKey,
            _ run: @escaping () -> Void
        ) -> some ToolbarContent {
            ToolbarItem(placement: .automatic) {
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
}
