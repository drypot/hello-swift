//
//  MessageClient.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

public class MessageClient {
    let clientConnection: MessageClientConnection
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port

    public init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
        let nwConnection = NWConnection(host: self.host, port: self.port, using: .tcp)
        clientConnection = MessageClientConnection(connection: nwConnection)
    }

    public func start() {
        print("Client started \(host) \(port)")
        clientConnection.didStopCallback = didStopCallback(error:)
        clientConnection.start()
    }

    public func stop() {
        clientConnection.stop()
    }

    public func send(data: Data) async throws {
        try await clientConnection.send(data: data)
    }

    public func receive() async throws -> String? {
        return try await clientConnection.receive()
    }

    func didStopCallback(error: Error?) {
        if error == nil {
            // exit(EXIT_SUCCESS)
        } else {
            // exit(EXIT_FAILURE)
        }
    }
}

final class MessageClientConnection: Sendable {
    let connection: NWConnection

    init(connection: NWConnection) {
        self.connection = connection
    }

    nonisolated(unsafe) var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        print("connection will start")
        connection.stateUpdateHandler = stateDidChange(to:)
        //setupReceive()
        connection.start(queue: .global())
    }

    @Sendable private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            print("Client connection ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    func send(data: Data) async throws {
        connection.send(content: data, completion: .contentProcessed( { error in
            if let error {
                self.connectionDidFail(error: error)
                return
            }
            print("connection did send, data: \(data as NSData)")
        }))
    }

    func receive() async throws -> String? {
        let (data, _, isComplete, error) = await withCheckedContinuation { continuation in
            connection.receive(minimumIncompleteLength: 1, maximumLength: connection.maximumDatagramSize ) {
                continuation.resume(returning: ($0, $1, $2, $3))
            }
        }
        if let error {
            self.connectionDidFail(error: error)
            return nil
        }
        if let data, !data.isEmpty {
            let message = String(data: data, encoding: .utf8)
            return message
        }
//        if isComplete {
//            self.connectionDidEnd()
//        } else {
//            self.setupReceive()
//        }
        return "???"
    }

    private func setupReceive() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { (data, _, isComplete, error) in

            if let data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8)
                print("connection did receive, data: \(data as NSData) string: \(message ?? "-" )")
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }

    func stop() {
        print("connection will stop")
        stop(error: nil)
    }

    private func connectionDidFail(error: Error) {
        print("connection did fail, error: \(error)")
        self.stop(error: error)
    }

    private func connectionDidEnd() {
        print("connection did end")
        self.stop(error: nil)
    }

    private func stop(error: Error?) {
        self.connection.stateUpdateHandler = nil
        self.connection.cancel()
        if let didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
