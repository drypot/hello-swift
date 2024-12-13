//
//  MessageServerTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/12/24.
//

import Foundation
import Testing
import Network
import os
import HelloSwiftFramework

struct MessageServerTests {

//    private static let server = {
//        let server = Server(port: 8080)
//        try! server.start()
//        return server
//    }()
//
//    func startServer() {
//        let _ = Self.server
//    }

    @Test func test() async throws {
        let port:UInt16 = 9090

        let server = MessageServer(port: port)
        try server.start()

        let client = MessageClient(host: "localhost", port: port)
        client.start()

        try await client.send(data: "good day".data(using: .utf8)!)

        #expect((try await client.receive()) == "hello")
        #expect((try await client.receive()) == "good day")

        client.stop()
        server.stop()
    }

}
