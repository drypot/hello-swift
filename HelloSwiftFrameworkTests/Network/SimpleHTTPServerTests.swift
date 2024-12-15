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

    @Test func testGet() async throws {
        let server = SimpleHTTPServer(port: 8080)
        try server.start()

        do {
            let url = URL(string: "http://localhost:8080/abc")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let content = String(data: data, encoding: .utf8)

            #expect(content! == "abc")
        }
        do {
            let url = URL(string: "http://localhost:8080/echo")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = "hello".data(using: .utf8)

            let (data, _) = try await URLSession.shared.data(for: request)
            let content = String(data: data, encoding: .utf8)

            #expect(content! == "hello")
        }

        server.stop()
    }

}
