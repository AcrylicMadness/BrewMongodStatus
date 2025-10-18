//
//  ServicesView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct ServicesView: View {
    
    @Binding var serviceManager: ServiceManager
    
    var body: some View {
        if serviceManager.providers.isEmpty {
            EmptyProvidersView(serviceManager: $serviceManager, inMenu: false)
        } else {
            NavigationSplitView {
                ServicesListView(serviceManager: $serviceManager)
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Button(action: {
                                serviceManager.refreshingProviders = true
                                Task {
                                    serviceManager.refreshProviders()
                                }
                            }, label: {
                                Image(systemName: "arrow.trianglehead.clockwise")
                            })
                        }
                    }
            } detail: {
                if serviceManager.selectedProvider == nil {
                    Text("Not Selected")
                } else {
                    ServiceDetailView(serviceManager: $serviceManager)
                }
            }
        }
    }
}
//
//#Preview {
//    ServicesView(serviceManager: .constant(ServiceManager()))
//}
