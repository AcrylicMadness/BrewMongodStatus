//
//  BrewService.swift
//  BrewMongodStatus
//
//  Created by Acrylic M. on 18.10.2025.
//

import Foundation

struct BrewService {
    enum Command: String {
        case run
        case stop
        case restart
        case info
    }
    
    enum CommandError: Error {
        case failedToDecodeResponse
        case processAlreeadyRunning
    }
    
    let provider: ServiceProvider
    
    private var process: Process?
    private var pipe = Pipe()
    
    init(provider: ServiceProvider) {
        self.provider = provider
        setupProcess()
    }
    
    static func discoverProviders() -> [ServiceProvider] {
        let discoverProcess = Process()
        let outputPipe = Pipe()
        discoverProcess.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/brew")
        discoverProcess.standardOutput = outputPipe
        discoverProcess.arguments = ["services", "list"]
        try? discoverProcess.run()
        if
            let data = try? outputPipe.fileHandleForReading.readToEnd(),
            let output = String(data: data, encoding: .utf8)
        {
            return output
                .split(separator: "\n")
                .compactMap({ resultString in
                    if let providerName = resultString.split(separator: " ").first {
                        if providerName.uppercased() != "NAME" {
                            return ServiceProvider(serviceName: String(providerName))
                        }
                    }
                    return nil
                })
        }
        return []
    }
    
    mutating
    private func setupProcess() {
        process = nil
        process = Process()
        pipe = Pipe()
        process?.standardOutput = pipe
        process?.standardError = pipe
        process?.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/brew")
    }
    
    mutating
    func run(command: Command) throws -> [Output] {
        setupProcess()
        process?.arguments = ["services", command.rawValue, provider.serviceName]
        try process?.run()
        guard
            let data = try pipe.fileHandleForReading.readToEnd(),
            let output = String(data: data, encoding: .utf8)
        else {
            throw CommandError.failedToDecodeResponse
        }
        return output.split(separator: "\n").map(String.init).map({ Output(text: $0) })
    }
    
    mutating
    func getStatus() -> (isRunning: Bool, output: [Output]) {
        do {
            let output = try run(command: .info)
            let isRunning = !output
                .filter({ $0.text.contains("Running") })
                .filter({ $0.text.contains("true") })
                .isEmpty
            return (isRunning: isRunning, output: output)
        } catch {
            return (isRunning: false, output: [Output(text: error.localizedDescription)])
        }
    }
}

struct Output: Codable, Identifiable, Hashable {
    let id: UUID
    let text: String
    
    init(text: String) {
        self.id = UUID()
        self.text = text
    }
}
