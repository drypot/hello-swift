//
//  SimpleHTTPServer.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Network

// https://github.com/httpswift/swifter
// https://ko9.org/posts/simple-swift-web-server/

public final class SimpleHTTPServer: Sendable {

    private let listener: NWListener

    public init(port: UInt16) {
        let nwPort = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener(using: .tcp, on: nwPort)
    }

    func log(_ message: String) {
        print("web server: \(message)")
    }

    public func start() throws {
        listener.newConnectionHandler = { connection in
            SimpleHTTPServerConnection(connection: connection).start()
        }
        listener.start(queue: .global())
        log("started")
    }

    public func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        log("stopped")
    }

}

final class SimpleHTTPServerConnection: Sendable {

    let id: Int
    let connection: NWConnection
    nonisolated(unsafe) var request: SimpleHTTPRequest?

    init(connection: NWConnection) {
        self.id = connectionIDGen.nextID()
        self.connection = connection
    }

    func log(_ message: String) {
        print("web connection \(self.id): \(message)")
    }

    func start() {
        receive()
        connection.start(queue: .global())
        log("started")
    }

    private func receive() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: connection.maximumDatagramSize
        ) { data, _, isComplete, error in

            if let error {
                self.log("receive error, \(error)")
                self.stop()
                return
            }
            if let data {
                self.log("data arrived: \(data.count)")

                if self.request == nil {
                    self.request = SimpleHTTPRequest.parse(data)
                } else {
                    self.request!.appendToBody(data)
                }
                var length = 0
                if let contentLength = self.request!.headers["Content-Length"] {
                    length = Int(contentLength)!
                }
                if self.request!.body.count >= length {
                    self.log("request arrived, \(self.request!.path)")
                    self.route()
                    self.request = nil
                }
            }
            if isComplete {
                self.log("completed")
            } else {
                self.log("receive again")
                self.receive()
            }
        }
    }

    private func route() {
        guard let request else { return }
        switch request.path {
        case "/echo":
            let message = String(data: request.body, encoding: .utf8)!
            self.respond(message)
        case "/abc":
            self.respond("abc")
        default:
            self.respond("invalid page")
        }
    }

    private func respond(_ message: String) {
        let headers = [
            "Content-Type: text/plain"
        ]
        let response = SimpleHTTPResponse(
            status: 200,
            reason: "OK",
            headers: headers,
            body: message.data(using: .utf8)!
        )
        connection.send(content: response.data(), completion: .idempotent)
    }

    func stop() {
        connection.stateUpdateHandler = nil
        connection.cancel()
        log("stopped")
    }

}

extension SimpleHTTPServerConnection: Hashable {
    static func == (lhs: SimpleHTTPServerConnection, rhs: SimpleHTTPServerConnection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
