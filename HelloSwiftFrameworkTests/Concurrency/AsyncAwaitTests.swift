//
//  AsyncAwaitTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency
// https://developer.apple.com/documentation/swift/concurrency

// An asynchronous function can be suspended while it’s partway through execution.
// Inside the body of an asynchronous function,
// you mark each of these places where execution can be suspended.

struct AsyncAwaitTests {

    func fetchNames() async -> [String] {
        return ["aaa", "bbb", "ccc"]
    }

    @Test func testAsyncAwait() async throws {
        let names = await fetchNames()
        #expect(names == ["aaa", "bbb", "ccc"])
    }

    @Test func testTaskYield() async throws {
        let names = await fetchNames()
        var copy = [String]()

        for name in names {
            copy.append(name)
            await Task.yield()   // 의도적으로 suspension point 를 만들 수 있다.
        }

        #expect(copy == names)
    }

    @Test func testTaskSleep() async throws {
        try await Task.sleep(for: .seconds(0.1))
    }
    
}
