//
//  ISO8601FormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct ISO8601FormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactoryVariable() throws {

        // https://developer.apple.com/documentation/foundation/date/iso8601formatstyle/3796293-iso8601
        // iso8601: A convenience factory variable that provides a base format for customizing ISO 8601 date format styles.

        #expect(date1410.formatted(.iso8601) == "2024-10-24T08:30:10Z")
    }

    @Test func testDefaults() throws {
        var style = Date.ISO8601FormatStyle()
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(style.format(date1410) == "2024-10-24T17:30:10+0900")
        #expect(date1410.formatted(style) == "2024-10-24T17:30:10+0900")
    }

    @Test func testModifiers() throws {
        var style = Date.ISO8601FormatStyle()
            .year().month().day().time(includingFractionalSeconds: false).dateTimeSeparator(.space)
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(style.format(date1410) == "2024-10-24 17:30:10")
        #expect(date1410.formatted(style) == "2024-10-24 17:30:10")
    }

    @Test func testParsing() throws {
        var style = Date.ISO8601FormatStyle()
            .year().month().day().time(includingFractionalSeconds: false).dateTimeSeparator(.space)
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let string1 = date1410.formatted(style)

        #expect(string1 == "2024-10-24 17:30:10")

        let date1 = try! Date(string1, strategy: style)
        let date2 = try! style.parse(string1)

        #expect(date1 == date1410)
        #expect(date2 == date1410)
    }

}
