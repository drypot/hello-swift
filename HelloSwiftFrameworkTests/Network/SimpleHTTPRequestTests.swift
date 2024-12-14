//
//  SimpleHTTPRequestTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/14/24.
//

import Foundation
import Testing
import HelloSwiftFramework

struct SimpleHTTPRequestTests {

    @Test func test() throws {
        let headerString = """
            GET /data HTTP/1.1\r
            Host: localhost:8080\r
            Accept: */*\r
            Accept-Language: ko-KR,ko;q=0.9\r
            Connection: keep-alive\r
            Accept-Encoding: gzip, deflate\r
            User-Agent: xctest/23600 CFNetwork/1568.300.101 Darwin/24.2.0\r
            \r\n
            """

        let req = SimpleHTTPRequest.parse(headerString.data(using: .utf8)!)

        #expect(req?.method == "GET")
        #expect(req?.path == "/data")
        #expect(req?.httpVersion == "HTTP/1.1")
        #expect(req?.headers["host"] == "localhost:8080")
    }

}
