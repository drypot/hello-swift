//
//  SequenceTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

// Sequence protocol:
// A type that provides sequential, iterated access to its elements.

struct SequenceTests {

    @Test func testForInLoop() throws {
        let oneTwoThree = 1...3
        var sum = 0

        for number in oneTwoThree {
            sum += number
        }

        #expect(sum == 6)
    }

}
