//
//  AsyncStreamTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/16/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/asyncstream

// AsyncStream conforms to AsyncSequence,
// providing a convenient way to create an asynchronous sequence
// without manually implementing an asynchronous iterator.

struct AsyncStreamTests {

    @Test func test() async throws {
        let stream = AsyncStream { continuation in
            continuation.yield(10)
            continuation.yield(20)
            Task {
                continuation.yield(30)
                continuation.finish()
            }
        }

        var iterator = stream.makeAsyncIterator()

        #expect((await iterator.next()) == 10)
        #expect((await iterator.next()) == 20)
        #expect((await iterator.next()) == 30)
        #expect((await iterator.next()) == nil)
    }

}
