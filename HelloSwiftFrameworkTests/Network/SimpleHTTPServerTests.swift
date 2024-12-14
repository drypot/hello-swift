//
//  SimpleHTTPServerTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Testing
import HelloSwiftFramework

struct SimpleHTTPServerTests {

    @Test func test() async throws {
        let server = SimpleHTTPServer(port: 8080)
        try server.start()

        let url = URL(string: "http://localhost:8080/data")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let content = String(data: data, encoding: .utf8) ?? "decoding error"

        #expect(content == "OK")

        server.stop()
    }

}
