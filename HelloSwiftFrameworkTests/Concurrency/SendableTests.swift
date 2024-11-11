//
//  SendableTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Sendable-Types
// https://developer.apple.com/documentation/swift/sendable
// Sendable: A type that can be shared from one concurrency domain to another.

// Sendable protocol doesn’t have any code requirements,
// but it does have semantic requirements that Swift enforces.

struct SendableTests {

    struct TemperatureReading: Sendable {
        var measurement: Int
    }

    @Test func test() throws {

    }

}
