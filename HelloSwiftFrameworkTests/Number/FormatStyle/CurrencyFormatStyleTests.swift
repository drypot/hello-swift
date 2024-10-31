//
//  CurrencyFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// https://en.wikipedia.org/wiki/ISO_4217

struct CurrencyFormatStyleTests {

    @Test func testFactoryVariable() throws {
        #expect(12345.formatted(.currency(code: "KRW")) == "₩12,345")
        #expect(12345.formatted(.currency(code: "USD")) == "US$12,345.00")
    }

    @Test func testCurrency() throws {
        let style = IntegerFormatStyle<Int>.Currency(code: "KRW", locale: Locale(identifier: "ko_KR"))

        #expect(12345.formatted(style) == "₩12,345")
    }

    @Test func testCurrencyUSD() throws {
        let style = IntegerFormatStyle<Int>.Currency(code: "USD", locale: Locale(identifier: "en_US"))

        #expect(12345.formatted(style) == "$12,345.00")
    }

    @Test func testParsing() throws {
        let strategy = IntegerFormatStyle<Int>.Currency(code: "KRW").parseStrategy
        
        #expect(try strategy.parse("12,345") == 12345)
        #expect(try strategy.parse("₩12,345") == 12345)
        #expect(throws: Error.self) {
            try strategy.parse("$12,345")
        }
    }

}
