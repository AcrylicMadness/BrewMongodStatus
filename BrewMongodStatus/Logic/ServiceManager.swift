//
//  ServiceManager.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import Observation
import Foundation
import SwiftUI



@Observable
class ServiceManager {
    
    static var shared: ServiceManager = ServiceManager()
    
    var providers: [ServiceProvider] = []
    var refreshingProviders: Bool = true
    var selectedProvider: ServiceProvider?
    private var services: [String: BrewService] = [:]
    
    var selectedIndex: Int {
        guard let selectedProvider else {
            return 0
        }
        return index(of: selectedProvider)
    }
    
    func index(of provider: ServiceProvider) -> Int {
        guard let index = providers.firstIndex(where: { $0 == provider }) else {
            return 0
        }
        return index
    }
    
    init() {
        providers = BrewService.discoverProviders()
        providers
            .forEach({
                services[$0.serviceName] = BrewService(provider: $0)
            })
        updateAll()
        refreshingProviders = false
    }

    func refreshProviders() {
        refreshingProviders = true
        providers = BrewService.discoverProviders()
        updateAll()
        refreshingProviders = false
    }
    
    func updateAll() {
        for provider in providers {
            getInfo(for: provider)
        }
    }
    
    func getInfo(for provider: ServiceProvider) {
        
        guard let index = providers.firstIndex(where: { $0 == provider }) else {
            return
        }
        
        providers[index].isFetching = true
        Task {
            if let result = services[provider.serviceName]?.getStatus() {
                providers[index].isRunning = result.isRunning
                providers[index].output.append(contentsOf: result.output)
            }
            providers[index].isFetching = false
            if provider == selectedProvider {
                selectedProvider = nil
                selectedProvider = providers[index]
            }
        }
    }
    
    func set(running: Bool, for provider: ServiceProvider) {
        guard let index = providers.firstIndex(where: { $0 == provider }) else {
            return
        }
        providers[index].isFetching = true
        Task {
            if let result = try? services[provider.serviceName]?.run(command: running ? .run : .stop) {
                let didRun = running && result.contains(where: { $0.text.contains("Successfully ran") })
                providers[index].isRunning = didRun
                providers[index].output.append(contentsOf: result)
            }
            providers[index].isFetching = false
            if provider == selectedProvider {
                selectedProvider = nil
                selectedProvider = providers[index]
            }
        }
        
    }
    
    func restart(for provider: ServiceProvider) {
        guard let index = providers.firstIndex(where: { $0 == provider }) else {
            return
        }
        providers[index].isFetching = true
        Task {
            if let result = try? services[provider.serviceName]?.run(command: .restart) {
                let didRun = result.contains(where: { $0.text.contains("Successfully ran") })
                providers[index].isRunning = didRun
                providers[index].output.append(contentsOf: result)
            }
            providers[index].isFetching = false
            if provider == selectedProvider {
                selectedProvider = nil
                selectedProvider = providers[index]
            }
        }
        
    }
}
