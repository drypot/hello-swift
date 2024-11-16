//
//  AsyncAwaitTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

fileprivate func fetchValue() async -> Int {
    return 10
}

struct AsyncAwaitTests {

    @Test func testAsyncAwait() async throws {

        let value = await fetchValue()

        #expect(value == 10)
    }

}
