//
//  CollectionTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/4/24.
//

import Foundation
import Testing

// protocol Collection<Element> : Sequence
// 
// A sequence whose elements can be accessed by an indexed subscript.

struct CollectionTests {

    let text = "Buffalo buffalo buffalo buffalo."

    @Test func testStartIndex() throws {
        #expect(text[text.startIndex] == "B")
        #expect(text.first == "B")
    }

    @Test func testRangedSubscript() throws {
        let firstSpace = text.firstIndex(of: " ") ?? text.endIndex
        let firstWord = text[..<firstSpace]
        #expect(firstWord == "Buffalo")
    }

    @Test func testPrefix() throws {
        let firstWord = text.prefix { $0 != " " }
        #expect(firstWord == "Buffalo")
    }

    
}
