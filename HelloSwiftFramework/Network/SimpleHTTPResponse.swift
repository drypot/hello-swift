//
//  SimpleHTTPResponse.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation

// https://ko9.org/posts/simple-swift-web-server/

public struct SimpleHTTPResponse {
    public let httpVersion: String
    public let status: Int
    public let reason: String
    public let headers: [String]
    public let body: Data

    public init(
        httpVersion: String = "HTTP/1.1",
        status: Int = 200,
        reason: String = "OK",
        headers: [String],
        body: Data) {

        self.httpVersion = httpVersion
        self.status = status
        self.reason = reason
        self.headers = headers
        self.body = body
    }

    public func data() -> Data {
        let statusLine = "\(httpVersion) \(status) \(reason)"

        var lines = [statusLine]
        lines.append(contentsOf: headers)
        lines.append("Content-Length: \(body.count)")
        lines.append("")
        lines.append("")
        let header = lines.joined(separator: "\r\n").data(using: .utf8)!

        return header + body
    }
}
