//
//  DateFormatStyleParsingTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct DateFormatStyleParsingTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testParsingWithParseStrategy() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "CDT")!
        calendar.locale = Locale(identifier: "en_US")

        let inputString = "month 8, day 23"
        
        let strategy = Date.ParseStrategy(
            format: "month \(month: .defaultDigits), day \(day: .twoDigits)",
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(abbreviation: "CDT")!
        )

        let date1 = try! Date(inputString, strategy: strategy)
        let date2 = try! strategy.parse(inputString)

        #expect(date1 == date2)
        
        let components = calendar.dateComponents([.month, .day], from: date1)

        #expect(components.month == 8)
        #expect(components.day == 23)
    }

    @Test func testParsingWithFormatStyle() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        var style = Date.FormatStyle().year().month().day().hour().minute().second()
        style.calendar = calendar
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!
        style.locale = Locale(identifier: "ko_KR")

        let string1 = date.formatted(style)

        #expect(string1 == "2024년 10월 24일 오후 5:30:10")

        let parsedDate = try! style.parse(string1)

        #expect(parsedDate == date)
    }
}
