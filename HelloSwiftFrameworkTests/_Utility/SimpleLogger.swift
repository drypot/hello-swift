//
//  SimpleLogger.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import os

struct SimpleLogger<T> where T: Sendable {

    private let _log = OSAllocatedUnfairLock(initialState: [T]())

    func append(_ value: T) {
        _log.withLock { $0.append(value) }
    }

    func log() -> [T] {
        _log.withLock { $0 }
    }
    
}
