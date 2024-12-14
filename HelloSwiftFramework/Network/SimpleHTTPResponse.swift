//
//  SimpleHTTPResponse.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 12/15/24.
//

import Foundation

// https://ko9.org/posts/simple-swift-web-server/

public struct Response {
    public let httpVersion = "HTTP/1.1"
    public let status: Int = 200
    public let reason: String = "OK"
    public let headers: [String: String]
    public let body: Data

    var messageData: Data {
        let statusLine = "\(httpVersion) \(status) \(reason)"

        var headers = self.headers
        headers["Content-Length"] = String(body.count)

        var lines = [statusLine]
        lines.append(contentsOf: headers.map({ "\($0.key): \($0.value)" }))
        lines.append("")
        lines.append("")
        let header = lines.joined(separator: "\r\n").data(using: .utf8)!

        return header + body
    }
}
