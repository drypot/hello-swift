//
//  AsyncSequenceTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

struct AsyncSequenceTests {

    struct AsyncCounter: AsyncSequence {
        typealias Element = Int

        let limit: Element

        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(limit: limit)
        }

        struct AsyncIterator: AsyncIteratorProtocol {
            let limit: Element
            var current = 0

            mutating func next() async -> Element? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }
    }

    @Test func testAsyncCounter() async throws {
        let counter = AsyncCounter(limit: 3)
        var result = [Int]()

        for await count in counter {
            result.append(count)
        }

        #expect(result == [0, 1, 2])
    }

}
