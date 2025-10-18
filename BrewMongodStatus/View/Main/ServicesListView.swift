//
//  ServicesListView.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import SwiftUI

struct ServicesListView: View {
    
    @Binding var serviceManager: ServiceManager
    
    @AppStorage("open_window_on_launch")
    private var openWindowOnLaunch: Bool = true
    
    var body: some View {
        List($serviceManager.providers) { provider in
            ServiceProviderView(
                provider: provider,
                serviceManager: $serviceManager
            )
        }
        .listStyle(.sidebar)
        .padding(.horizontal, 0)
        .frame(minWidth: 250)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Toggle(isOn: $openWindowOnLaunch) {
                    Text("Open window on app launch")
                }
                .toggleStyle(.checkbox)
                Spacer()
            }
            .padding()
        }
    }
}


//#Preview {
//    ServicesView(serviceManager: .constant(ServiceManager()))
//}
