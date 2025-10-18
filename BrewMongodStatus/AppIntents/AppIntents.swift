//
//  AppIntents.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 17.10.2025.
//

import AppIntents
import Foundation

struct StartAll: AppIntent {
    
    static var title: LocalizedStringResource = "Start All"
    
    func perform() async throws -> some IntentResult {
        for provider in ServiceManager.shared.providers {
            ServiceManager.shared.set(running: false, for: provider)
        }
        return .result()
    }
}

struct StopAll: AppIntent {
    static var title: LocalizedStringResource = "Stop All"
    
    func perform() async throws -> some IntentResult {
        for provider in ServiceManager.shared.providers {
            ServiceManager.shared.set(running: true, for: provider)
        }
        return .result()
    }
}
