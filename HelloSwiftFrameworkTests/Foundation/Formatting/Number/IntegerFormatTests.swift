//
//  IntegerFormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct IntegerFormatTests {

    @Test func testFactoryVariables() throws {
        #expect(12345.formatted() == "12,345")

        #expect(12345.formatted(.number) == "12,345")
        #expect(12345.formatted(.number.grouping(.never)) == "12345")

        #expect(12345.formatted(.percent) == "12,345%")
        #expect(12345.formatted(.currency(code: "KRW")) == "₩12,345")
        #expect(12345.formatted(.currency(code: "USD")) == "US$12,345.00")
    }

    @Test func testIntegerFormatStyle() throws {
        let style = IntegerFormatStyle<Int>(locale: Locale(identifier: "ko_KR"))
        let number = 12345

        #expect(style.format(number) == "12,345")

        #expect(number.formatted(style) == "12,345")

        #expect(number.formatted(style.grouping(.never)) == "12345")

        #expect(number.formatted(style.notation(.scientific)) == "1.2345E4")

        #expect(number.formatted(style.precision(.significantDigits(4))) == "12,340")
        #expect(12345.formatted(style.precision(.significantDigits(4))) == "12,340")
        #expect(12346.formatted(style.precision(.significantDigits(4))) == "12,350")

        #expect(12345.formatted(style.rounded(rule: .toNearestOrEven, increment: 1000)) == "12,000")
        #expect(12567.formatted(style.rounded(rule: .toNearestOrEven, increment: 1000)) == "13,000")

        #expect(number.formatted(style.scale(0.01)) == "123.45")

        #expect((-number).formatted(style) == "-12,345")
        #expect((-number).formatted(style.sign(strategy: .never)) == "12,345")
    }

    @Test func testParsing() throws {
        let style = IntegerFormatStyle<Int>(locale: Locale(identifier: "ko_KR"))
        let strategy = style.parseStrategy

        #expect(try Int("12345", format: style) == 12345)

        #expect(try strategy.parse("12345") == 12345)
        #expect(try strategy.parse("12,345") == 12345)

        #expect(throws: Error.self) {
            try strategy.parse("₩12,345")
        }
    }

}
