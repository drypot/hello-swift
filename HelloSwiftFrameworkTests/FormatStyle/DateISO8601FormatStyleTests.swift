//
//  DateISO8601FormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct DateISO8601FormatStyleTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFormattingWithDefaults() throws {
        let style = Date.ISO8601FormatStyle()
        //style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let string1 = date.formatted(style)
        let string2 = style.format(date)

        #expect(string1 == string2)
        #expect(string1 == "2024-10-24T08:30:10Z")
    }

    @Test func testFormattingWithParams() throws {
        var style = Date.ISO8601FormatStyle()
            .year().month().day().time(includingFractionalSeconds: false)
            .dateTimeSeparator(.space)

        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let string1 = date.formatted(style)
        let string2 = style.format(date)

        #expect(string1 == string2)
        #expect(string1 == "2024-10-24 17:30:10")
    }

    @Test func testParsing() throws {
        var style = Date.ISO8601FormatStyle()
            .year().month().day().time(includingFractionalSeconds: false)
            .dateTimeSeparator(.space)

        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let string1 = date.formatted(style)
        let string2 = style.format(date)

        #expect(string1 == string2)
        #expect(string1 == "2024-10-24 17:30:10")

        let parsedDate = try style.parse(string1)

        #expect(parsedDate == date)
    }

}
