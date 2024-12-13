//
//  MessageServer.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/13/24.
//

import Foundation
import Network
import os

// https://rderik.com/blog/building-a-server-client-aplication-using-apple-s-network-framework/
// https://github.com/httpswift/swifter
// https://ko9.org/posts/simple-swift-web-server/

public final class MessageServer: Sendable {

    let listener: NWListener

    public init(port: UInt16) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
    }

    public func start() throws {
        // handler 클로져들에 [weak self] 넣어야 하는데 넣지않고,
        // 대신 close 메서드에서 nil 대입을 하고 있다.
        listener.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("server state: ready on port \(self.listener.port!)")
            case .failed(let error):
                print("server state: failed, error: \(error)")
                // exit(EXIT_FAILURE)
            case .cancelled:
                print("server state: canceled")
            default:
                break
            }
        }
        listener.newConnectionHandler = { connection in
            MessageServerConnection(connection: connection).start()
        }
        listener.start(queue: .global())
        print("server started")
    }

    public func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
//        for connection in self.serverConnectionsByID.withLock({ $0.values }) {
//            connection.stopHandler = nil
//            connection.stop()
//        }
    }
}

final class MessageServerConnection: Sendable {
    
    private static let idGen = IntIDGenerator()

    let id: Int
    let connection: NWConnection

    init(connection: NWConnection) {
        self.id = Self.idGen.nextID()
        self.connection = connection
    }

    func log(_ message: String) {
        print("server connection \(self.id): \(message)")
    }

    func start() {
        setupStateUpdateHandler()
        setupReceiveHandler()
        connection.start(queue: .global())
        log("new")
        send(data: "hello".data(using: .utf8)!)
    }

    private func setupStateUpdateHandler() {
        connection.stateUpdateHandler = { state in
            switch state {
            case .waiting(let error):
                self.log("state, waiting, \(error.localizedDescription)")
                self.close()
            case .ready:
                self.log("state, ready")
            case .failed(let error):
                self.log("state, failed, \(error.localizedDescription)")
                self.close()
            default:
                break
            }
        }
    }

    private func setupReceiveHandler() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { data, _, isComplete, error in

            if let data, !data.isEmpty {
                self.log("received, \(data.count) bytes")
                self.send(data: data)
            }
            if isComplete {
                self.log("completed")
                self.close()
            } else if let error {
                self.log("receive error, \(error.localizedDescription)")
                self.close()
            } else {
                self.setupReceiveHandler()
            }
        }
    }

    private func send(data: Data) {
        connection.send(content: data, completion: .contentProcessed( { error in
            if let error {
                self.log("failed to send, \(error)")
                self.close()
                return
            }
            self.log("sent \(data.count) bytes")
        }))
    }

    private func close() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        self.log("closed")
    }

}

extension MessageServerConnection: Hashable {
    static func == (lhs: MessageServerConnection, rhs: MessageServerConnection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
