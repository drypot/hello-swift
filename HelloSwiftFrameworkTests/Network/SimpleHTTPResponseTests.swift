//
//  SimpleHTTPResponseTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation
import HelloSwiftFramework
import Testing

struct SimpleHTTPResponseTests {

    @Test func test() throws {
        let headers = [
            "Content-Type: text/plain"
        ]
        let body = "hello".data(using: .utf8)!
        let response = SimpleHTTPResponse(headers: headers, body: body)

        let expected = """
            HTTP/1.1 200 OK\r
            Content-Type: text/plain\r
            Content-Length: 5\r
            \r
            hello
            """

        let responseString = String(data:response.data(), encoding: .utf8)!
        #expect(responseString == expected)
    }

}
