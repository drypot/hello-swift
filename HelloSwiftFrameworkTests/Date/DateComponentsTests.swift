//
//  DateComponentsTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/30/24.
//

import Foundation
import Testing

struct DateComponentsTests {

    @Test func testDateComponents() throws {
        var components1 = DateComponents()
        components1.year = 2024
        components1.month = 10
        components1.day = 24
        components1.hour = 17
        components1.minute = 30
        components1.second = 10

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)

        #expect(components1 == components2)

        #expect(components1.year == 2024)
        #expect(components1.month == 10)
        #expect(components1.day == 24)
    }

    @Test func testDateComponentsWithCalendar() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10
        )

        #expect(components.year == 2024)
        #expect(components.month == 10)
        #expect(components.day == 24)
    }

}
