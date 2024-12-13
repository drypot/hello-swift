//
//  SimpleHTTPServer.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Network

final class SimpleHTTPServer: Sendable {
    private nonisolated(unsafe) var listener: NWListener!

    func start(port: UInt16) throws {
        listener = try NWListener(using: .tcp, on: NWEndpoint.Port(rawValue: port)!)
        print("Server started on port \(port)")

        listener.newConnectionHandler = { @Sendable [weak self] connection in
            self?.handleNewConnection(connection)
        }

        listener.start(queue: .global())
    }

    func stop() {
        listener.cancel()
        listener = nil
        print("Server stopped")
    }

    private func handleNewConnection(_ connection: NWConnection) {
        connection.start(queue: .global())
        connection.receiveMessage { [weak self] (data, _, isComplete, error) in
            print("xxxx")
            if let data, let request = String(data: data, encoding: .utf8) {
                print("Received request:\n\(request)")
                self?.respond(to: connection)
            }

            if let error {
                print("Connection error: \(error)")
            }

            if isComplete {
                connection.cancel()
            }
        }
        print("yyy")
    }

    func receive(from connection: NWConnection) {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { [weak self] data, _, isComplete, error in

            if let error {
                print("Connection error: \(error)")
            } else if let data, let content = String(data: data, encoding: .utf8) {
                print("Received request:\n\(content)")
                self?.respond(to: connection)
            }

            if !isComplete {
                self!.receive(from: connection)
            }
        }
    }


    private func respond(to connection: NWConnection) {
        let response = """
        HTTP/1.1 200 OK
        Content-Type: text/plain
        Content-Length: 13
        
        Hello, World!
        """

        let data = response.data(using: .utf8)
        connection.send(content: data, completion: .contentProcessed { error in
            if let error {
                print("Failed to send response: \(error)")
            }
            connection.cancel()
        })
    }

}


/*

 // Run the server
 let server = SimpleHTTPServer()
 server.start(port: 8080)

 // Keep the main thread running
 RunLoop.main.run()

 */
