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
        for provider in ServiceProvider.allCases {
            BrewManager.provider = provider
            _ = await BrewManager.start()
        }
        return .result()
    }
}

struct StopAll: AppIntent {
    static var title: LocalizedStringResource = "Stop All"
    
    func perform() async throws -> some IntentResult {
        for provider in ServiceProvider.allCases {
            BrewManager.provider = provider
            _ = await BrewManager.stop()
        }
        return .result()
    }
}
