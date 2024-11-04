//
//  StrideTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/2/24.
//

import Foundation
import Testing

struct StrideTests {

    @Test func testStrideable() throws {
        // Int confirms to Strideable protocol

        let value = 10

        #expect(value.advanced(by: 10) == 20)
        #expect(value.distance(to: 100) == 90)
    }

    @Test func testStrideTo() throws {
        // struct StrideTo<Element> where Element : Strideable
        // StrideTo confirms to Sequence

        var joined = ""
        let seq: StrideTo<Int> = stride(from: 0, to: 5, by: 1)

        for i in seq {
            joined += String(i)
        }

        #expect(joined == "01234")
    }

    @Test func testStrideThrough() throws {
        // struct StrideThrough<Element> where Element : Strideable
        // StrideThrough confirms to Sequence

        var joined = ""
        let seq: StrideThrough<Int> = stride(from: 0, through: 5, by: 1)

        for i in seq {
            joined += String(i)
        }

        #expect(joined == "012345")
    }
}
