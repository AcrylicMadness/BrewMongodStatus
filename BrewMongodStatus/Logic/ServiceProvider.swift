//
//  ServiceProvider.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 07.10.2025.
//

struct ServiceProvider: Codable {
    let serviceName: String
    
    init(serviceName: String) {
        self.serviceName = serviceName
    }
}

extension ServiceProvider: Identifiable, Hashable {
    var id: String { serviceName }
}
