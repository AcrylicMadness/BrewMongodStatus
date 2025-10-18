//
//  Commands.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import Foundation

struct Commands {
    
    static let pathToBrew: String = URL(fileURLWithPath: "/home/local/bin").absoluteString
}

struct ServiceCommands {
    let info: String
    let start: String
    let stop: String
    let restart: String
    
    static let mongodb: ServiceCommands = .init(
        info: "/opt/homebrew/bin/brew services info mongodb/brew/mongodb-community",
        start: "/opt/homebrew/bin/brew services start mongodb/brew/mongodb-community",
        stop: "/opt/homebrew/bin/brew services stop mongodb/brew/mongodb-community",
        restart: "/opt/homebrew/bin/brew services restart mongodb/brew/mongodb-community"
    )
    
    static let postgresql: ServiceCommands = .init(
        info: "/opt/homebrew/bin/brew services info postgresql",
        start: "/opt/homebrew/bin/brew services start postgresql",
        stop: "/opt/homebrew/bin/brew services stop postgresql",
        restart: "/opt/homebrew/bin/brew services restart postgresql"
    )
}
