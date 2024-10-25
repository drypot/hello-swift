//
//  DateFormatterTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/24/24.
//

import Foundation
import Testing

// DateFormatter is relatively expensive 'class' to create,
// so it’s a good practice to reuse the same instance
// rather than creating a new one every time you need to format or parse a date.

// In Swift, use formatted methods directly on the types.
// In Objective-C, create instances of Formatter and its subtypes, and use the string(for:) method.

struct DateFormatterTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testLocale() throws {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium

        do {
            formatter.locale = Locale(identifier: "ko_KR")

            #expect(formatter.string(from: date) == "2024. 10. 24. 오후 5:30:10")
        }

        do {
            formatter.locale = Locale(identifier: "en_US")

            #expect(formatter.string(from: date) == "Oct 24, 2024 at 5:30:10 PM")
        }

        do {
            formatter.locale = Locale(identifier: "zh_CN")

            #expect(formatter.string(from: date) == "2024年10月24日 17:30:10")
        }

        do {
            formatter.locale = Locale(identifier: "ja_JP")

            #expect(formatter.string(from: date) == "2024/10/24 17:30:10")
        }
    }

    @Test func testDateTimeStyle() throws {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")

        do {
            formatter.dateStyle = .short
            formatter.timeStyle = .short

            #expect(formatter.string(from: date) == "2024. 10. 24. 오후 5:30")
        }

        do {
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium

            #expect(formatter.string(from: date) == "2024. 10. 24. 오후 5:30:10")
        }

        do {
            formatter.dateStyle = .long
            formatter.timeStyle = .long

            #expect(formatter.string(from: date) == "2024년 10월 24일 오후 5시 30분 10초 GMT+9")
        }

        do {
            formatter.dateStyle = .full
            formatter.timeStyle = .full

            #expect(formatter.string(from: date) == "2024년 10월 24일 목요일 오후 5시 30분 10초 대한민국 표준시")
        }
    }

    // Date Format Patterns
    // http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns

    @Test func testCustomStyle() throws {
        do {
            // For user-visible representations,
            // you should use the dateStyle and timeStyle properties, or
            // the setLocalizedDateFormatFromTemplate(_:) method

            // setLocalizedDateFormatFromTemplate 는 템플릿을 지정하더라도 locale 에 따라 출력이 달라진다고 한다.

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd 'at' HH:mm")

            #expect(formatter.string(from: date) == "2024. 10. 24. 17:30")
        }

        do {
            // When working with fixed format dates, such as RFC 3339,
            // you set the dateFormat property to specify a format string.

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"

            #expect(formatter.string(from: date) == "2024-10-24 at 17:30")
        }

        do {
            // When working with fixed format dates, such as RFC 3339,
            // you set the dateFormat property

            // For most fixed formats,
            // you should also set the locale property to a POSIX locale ("en_US_POSIX"), and
            // set the timeZone property to UTC.

            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            #expect(RFC3339DateFormatter.string(from: date) == "2024-10-24T08:30:10Z")
        }

    }

    @Test func testParsingDateString() throws {
        do {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!

            formatter.dateStyle = .long
            formatter.timeStyle = .long

            #expect(formatter.date(from: "2024년 10월 24일 오후 5시 30분 10초 GMT+9") == date)
        }

        do {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss"

            #expect(formatter.date(from: "2024-10-24 at 17:30:10") == date)
        }

        do {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            #expect(RFC3339DateFormatter.date(from:"2024-10-24T08:30:10Z") == date)
        }

    }

}
