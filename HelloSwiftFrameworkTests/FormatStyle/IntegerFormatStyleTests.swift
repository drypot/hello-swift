//
//  IntegerFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct IntegerFormatStyleTests {

    @Test func test() throws {
        let style = IntegerFormatStyle<Int>()

        #expect(style.format(123) == "123")
        #expect(123.formatted(style) == "123")
        #expect(123.formatted(.number) == "123")
    }

}
