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
        let range = 0...2
        var joined = ""

        for number in range {
            joined += String(number)
        }

        #expect(joined == "012")
    }

}
