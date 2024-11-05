//
//  SequenceExcludingElementsTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceExcludingElementsTests {

    @Test func testDropFirst() throws {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.dropFirst(2) == [3, 4, 5])
        #expect(numbers.dropFirst(10) == [])
    }

}
