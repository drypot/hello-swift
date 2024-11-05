//
//  SequenceTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

// protocol Sequence<Element>
//
// A type that provides sequential, iterated access to its elements.

struct SequenceTests {

    @Test func testForLoop() throws {
        let range = 0...2
        
        var result: [Int] = []

        for number in range {
            result.append(number)
        }

        #expect(result == [0, 1, 2])
    }

    // 기타 다양한 메서트 테스트는, 나중에 필요하면;

}
