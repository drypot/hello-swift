//
//  StrideableTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/2/24.
//

import Foundation
import Testing

struct StrideableTests {

    @Test func testStrideable() throws {
        let value = 10

        #expect(value as Any is any Strideable)

        #expect(value.advanced(by: 10) == 20)
        #expect(value.distance(to: 100) == 90)
    }

    @Test func testStrideTo() throws {
        var joined = ""

        for i in stride(from: 0, to: 5, by: 1) {
            joined += String(i)
        }

        #expect(joined == "01234")
    }

    @Test func testStrideThrough() throws {
        var joined = ""

        for i in stride(from: 0, through: 5, by: 1) {
            joined += String(i)
        }

        #expect(joined == "012345")
    }
}
