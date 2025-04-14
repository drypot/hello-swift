//
//  ActorLogger.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 11/20/24.
//

import Foundation

actor ActorLogger {
    private var _log: [String]

    init() {
        _log = []
    }

    func append(_ message: String) {
        _log.append(message)
    }

    func log() -> [String] {
        return _log
    }
}
