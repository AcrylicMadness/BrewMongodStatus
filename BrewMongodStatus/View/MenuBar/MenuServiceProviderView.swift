//
//  MenuServiceProviderView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct MenuServiceProviderView: View {
    
    @Binding var provider: ServiceProvider
    @Binding var serviceManager: ServiceManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State var hover: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(provider.serviceName)
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                HStack(spacing: 2) {
                    if provider.isFetching {
                        ProgressView()
                            .controlSize(.mini)
                    } else {
                        Image(
                            systemName: provider.isRunning ?
                                "checkmark.circle.fill" :
                                "x.circle.fill"
                        )
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(
                                provider.isRunning ? Color.green : Color.red
                        )
                    }
                    Text(
                        provider.isFetching ?
                        "Loading" : (provider.isRunning ? "Running" : "Stopped")
                    )
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(
                            provider.isFetching ? .primary :
                            provider.isRunning ? Color.green : Color.red
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
        .contentShape(Rectangle())
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill( hover ?
                       Color(nsColor: .systemFill) :
                    Color(nsColor: .secondarySystemFill)
                )
        }
        .onHover { isHovering in
            hover = isHovering
        }
        .onTapGesture {
            serviceManager.selectedProvider = provider
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
