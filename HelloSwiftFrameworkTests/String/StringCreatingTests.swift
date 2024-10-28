//
//  StringCreatingTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/28/24.
//

import Foundation
import Testing

struct StringCreatingTests {

    @Test func testString() throws {
        //
    }

    @Test func testStringFromUnicode() throws {
        //
    }

    @Test func testStringFormat() throws {
        #expect(String(format: "Hello, %@", "World") == "Hello, World")
    }

    @Test func testLocalizedString() throws {
        
    }
}
