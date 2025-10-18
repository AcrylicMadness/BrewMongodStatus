//
//  Shell.swift
//  BrewMongodStatus
//
//  Created by Кирилл Аверкиев on 20.06.2023.
//

import Foundation

struct Shell {
    static func run(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try? task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    static func run(_ command: String) -> [Output] {
        Shell.run(command).split(separator: "\n").map({ Output(text: String($0)) })
    }
}

class BrewManager {
    
    static var provider: ServiceProvider = ServiceProvider.allCases.first!
    
    static func getInfo() async -> (output: [Output], isRunning: Bool) {
        await withCheckedContinuation { continuation in
            Task {
                let output: [Output] = Shell.run(provider.commands.info)
                var result: Bool = false
                
                for item in output {
                    if item.text.contains("Running") {
                        if item.text.contains("true") {
                            result = true
                        }
                    }
                }
                
                continuation.resume(returning: (output: output, isRunning: result))
            }
        }
    }
    
    static func start() async -> [Output] {
        await withCheckedContinuation { continuation in
            Task {
                let output: [Output] = Shell.run(provider.commands.start)
                

                
                continuation.resume(returning: output)
            }
        }
    }

    static func restart() async -> [Output] {
        await withCheckedContinuation { continuation in
            Task {
                let output: [Output] = Shell.run(provider.commands.restart)

                
                continuation.resume(returning: output)
            }
        }
    }
    
    static func stop() async -> [Output] {
        await withCheckedContinuation { continuation in
            Task {
                let output: [Output] = Shell.run(provider.commands.stop)
                
                
                continuation.resume(returning: output)
            }
        }
    }

}
