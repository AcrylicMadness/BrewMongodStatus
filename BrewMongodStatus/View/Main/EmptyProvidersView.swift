//
//  EmptyProvidersView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct EmptyProvidersView: View {
    
    @Binding
    var serviceManager: ServiceManager
    
    @State var inMenu: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if serviceManager.refreshingProviders {
                ProgressView()
                    .controlSize(.large)
            } else {
                VStack {
                    Text("No Homebrew services found")
                        .font(inMenu ? .body : .title)
                    Button("Refresh", systemImage: "arrow.trianglehead.clockwise") {
                        serviceManager.refreshingProviders = true
                        Task {
                            serviceManager.refreshProviders()
                        }
                    }
                    .cornerRadius(inMenu ? 10 : 8)
                }
            }
            Spacer()
        }
        .padding()
    }
}
