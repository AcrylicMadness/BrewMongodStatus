//
//  ServiceProvider.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 07.10.2025.
//

enum ServiceProvider: String, Codable {
    case postgresql = "PostgreSQL"
    case mongodb = "MongoDB"
    
    var commands: ServiceCommands {
        switch self {
        case .mongodb:
            return .mongodb
        case .postgresql:
            return .postgresql
        }
    }
    
    var serviceName: String {
        switch self {
        case .mongodb:
            return "mongodb-community"
        case .postgresql:
            return "postgresql"
        }
    }
}

extension ServiceProvider: Identifiable {
    var id: String { rawValue }
}

extension ServiceProvider: CaseIterable { }
