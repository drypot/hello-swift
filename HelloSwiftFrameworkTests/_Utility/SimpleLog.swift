//
//  TestLog.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation

struct SimpleLog {
    private static var logDic: [String: [String]] = [:]

    static func log(_ message: String, tag: String) {
        DispatchQueue.main.sync {
            logDic[tag, default: []].append(message)
        }
    }

    static func log(withTag tag: String) -> [String]? {
        var messages: [String]?
        DispatchQueue.main.sync {
            messages = logDic[tag]
        }
        return messages
    }
}

