//
//  SimpleHTTPRequest.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 12/14/24.
//

import Foundation

// https://ko9.org/posts/simple-swift-web-server/

public struct SimpleHTTPRequest {
    public let method: String
    public let path: String
    public let httpVersion: String
    public let headers: [String: String]

    public static func parse(_ data: Data) -> SimpleHTTPRequest? {
        let str = String(data: data, encoding: .utf8)!
        let lines = str.components(separatedBy: "\r\n")
        print(lines)
        guard let firstLine = lines.first,
              let lastLine = lines.last, lastLine.isEmpty else {
            return nil
        }

        let parts = firstLine.components(separatedBy: " ")
        guard parts.count == 3 else {
            return nil
        }

        let method = parts[0]
        let path = parts[1].removingPercentEncoding!
        let httpVersion = parts[2]

        let headerPairs = lines.dropFirst()
            .map { $0.split(separator: ":", maxSplits: 1) }
            .filter { $0.count == 2 }
            .map { ($0[0].lowercased(), $0[1].trimmingCharacters(in: .whitespaces)) }

        let headers = Dictionary(headerPairs, uniquingKeysWith: { old, _ in old })

        return SimpleHTTPRequest(
            method: method,
            path: path,
            httpVersion: httpVersion,
            headers: headers
        )
    }

}
