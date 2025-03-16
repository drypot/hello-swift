//
//  PercentFormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/1/24.
//

import Foundation
import Testing

struct PercentFormatTests {

    @Test func testFactoryVariable() throws {
        #expect(12345.formatted(.percent) == "12,345%")
        #expect(0.12345.formatted(.percent) == "12.345%")
    }

    @Test func testIntegerPercent() throws {
        let style = IntegerFormatStyle<Int>.Percent(locale: Locale(identifier: "ko_KR"))
        
        #expect(12345.formatted(style) == "12,345%")
    }

    @Test func testFloatingPointPercent() throws {
        let style = FloatingPointFormatStyle<Double>.Percent(locale: Locale(identifier: "ko_KR"))

        #expect(0.12345.formatted(style) == "12.345%")
    }

    @Test func testParsing() throws {
        let strategy = IntegerFormatStyle<Int>.Percent(locale: Locale(identifier: "ko_KR")).parseStrategy

        #expect(try strategy.parse("12,345") == 12345)
        #expect(try strategy.parse("12,345%") == 12345)
        #expect(try strategy.parse("%12,345") == 12345)
        #expect(throws: Error.self) {
            try strategy.parse("$12,345")
        }
    }
    
}
