//
//  StringTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/28/24.
//

import Testing

struct StringTests {

    @Test func testString() throws {
        let name = "Rosa"

        #expect("Welcome, \(name)!" == "Welcome, Rosa!")
        #expect("A" + "B" == "AB")
    }

    @Test func testMultilineString() throws {
        let m1 = """
            abc
            """

        #expect(m1 == "abc")

        let m2 = """
            abc
            
            """

        #expect(m2 == "abc\n")
    }

    @Test func testStringHaveValueSemantics() throws {
        let hello = "hello"
        var hello2 = hello
        hello2 += ", world"

        #expect(hello == "hello")
        #expect(hello2 == "hello, world")
    }

    @Test func testStringComparison() throws {
        #expect("Cafe\u{301}" == "Café")
    }

    

}
