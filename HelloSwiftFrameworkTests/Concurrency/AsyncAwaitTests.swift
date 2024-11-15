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

// When adding concurrent code to an existing project, work from the top down.
// Specifically, start by converting the top-most layer of code to use concurrency,
// and then start converting the functions and methods that it calls,
// working through the project’s architecture one layer at a time.
// There’s no way to take a bottom-up approach,
// because synchronous code can’t ever call asynchronous code.

fileprivate func fetchNames() async -> [String] {
    return ["aaa", "bbb", "ccc"]
}

struct AsyncAwaitTests {

    @Test func testAsyncAwait() async throws {
        let names = await fetchNames()
        #expect(names == ["aaa", "bbb", "ccc"])
    }

}
