//
//  ServiceProvider.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 07.10.2025.
//


struct ServiceProvider: Codable {
    let serviceName: String
    
    var output: [Output] = []
    var isRunning: Bool = false
    var isFetching: Bool = false
    
    init(serviceName: String) {
        self.serviceName = serviceName
    }
}

extension ServiceProvider: Identifiable, Hashable {
    var id: String { serviceName }
}

extension ServiceProvider: Equatable {
    static func ==(lhs: ServiceProvider, rhs: ServiceProvider) -> Bool {
        lhs.serviceName == rhs.serviceName
    }
}
