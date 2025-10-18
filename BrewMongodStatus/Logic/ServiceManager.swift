//
//  ServiceManager.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import Observation
import Foundation
import SwiftUI

struct ServiceInfo: Codable {
    var output: [Output] = []
    var isRunning: Bool = false
    var isFetching: Bool = false
}

@Observable
class ServiceManager {
    
    var info: [ServiceProvider: ServiceInfo] = [:]
    private var services: [ServiceProvider: BrewService] = [:]
    
    init() {
        ServiceProvider
            .allCases
            .forEach({
                info[$0] = ServiceInfo()
                services[$0] = BrewService(provider: $0)
            })
        updateAll()
    }
    
    func updateAll() {
        for provider in ServiceProvider.allCases {
            getInfo(for: provider)
        }
    }
        
    func getInfo(for provider: ServiceProvider) {
        info[provider]?.isFetching = true
        Task {
            if let result = services[provider]?.getStatus() {
                info[provider]?.isRunning = result.isRunning
                info[provider]?.output.append(contentsOf: result.output)
            }
            info[provider]?.isFetching = false
        }
    }
    
    func set(running: Bool, for provider: ServiceProvider) {
        info[provider]?.isFetching = true
        Task {
            if let result = try? services[provider]?.run(command: running ? .run : .stop) {
                let didRun = running && result.contains(where: { $0.text.contains("Successfully ran") })
                info[provider]?.isRunning = didRun
                info[provider]?.output.append(contentsOf: result)
            }
            info[provider]?.isFetching = false
        }
    }
    
    func restart(for provider: ServiceProvider) {
        info[provider]?.isFetching = true
        Task {
            if let result = try? services[provider]?.run(command: .restart) {
                let didRun = result.contains(where: { $0.text.contains("Successfully ran") })
                info[provider]?.isRunning = didRun
                info[provider]?.output.append(contentsOf: result)
            }
            info[provider]?.isFetching = false
        }
    }
}
