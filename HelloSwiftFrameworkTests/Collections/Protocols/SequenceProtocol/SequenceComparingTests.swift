//
//  SequenceComparingTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/7/24.
//

import Foundation
import Testing

struct SequenceComparingTests {

    @Test func testElementsEqual() throws {
        let a = 1...3
        let b = 1...10

        #expect(a.elementsEqual(b) == false)
        #expect(a.elementsEqual([1, 2, 3]) == true)
    }

    @Test func testElementsEqualBy() throws {
        let a = 1...3
        let b = 1...3
        let c = 3...5

        #expect(a.elementsEqual(b) { $0 == $1 - 2 } == false)
        #expect(a.elementsEqual(c) { $0 == $1 - 2 } == true)
    }

    @Test func testStarts() throws {
        let a = 1...3
        let b = 1...10
        let c = 2...10

        #expect(b.starts(with: a) == true)
        #expect(c.starts(with: a) == false)
    }

    @Test func testStartsBy() throws {
        let a = 1...3
        let b = 1...10
        let c = 3...10

        #expect(b.starts(with: a) { $0 == $1 + 2 } == false)
        #expect(c.starts(with: a) { $0 == $1 + 2 } == true)
    }


}
