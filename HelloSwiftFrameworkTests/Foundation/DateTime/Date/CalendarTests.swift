//
//  CalendarTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/26/24.
//

import Foundation
import Testing

struct CalendarTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testCalendar() throws {
        let _ = Calendar.current

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(calendar.identifier == .gregorian)
    }

    @Test func testCompoentsFromDate() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        do {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

            #expect(components.year == 2024)
            #expect(components.month == 10)
            #expect(components.day == 24)
            #expect(components.hour == 17)
            #expect(components.minute == 30)
            #expect(components.second == 10)
        }

        do {
            // 타임존 넣는 매서드 사용하면 모든 Component 가 싹 들어온다.
            let components = calendar.dateComponents(in: calendar.timeZone, from: date)

            #expect(components.year == 2024)
            #expect(components.month == 10)
            #expect(components.day == 24)
            #expect(components.hour == 17)
            #expect(components.minute == 30)
            #expect(components.second == 10)
        }

        do {
            #expect(calendar.component(.year, from: date) == 2024)
            #expect(calendar.component(.month, from: date) == 10)
            #expect(calendar.component(.day, from: date) == 24)
            #expect(calendar.component(.hour, from: date) == 17)
            #expect(calendar.component(.minute, from: date) == 30)
            #expect(calendar.component(.second, from: date) == 10)
        }
    }

    @Test func testDateFromComponents() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date2 = calendar.date(from: components)!

        #expect(date2 == date)
    }

    @Test func testDateArithmetic() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        do {
            let date2 = calendar.date(byAdding: DateComponents(day: 10), to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
            #expect(components2.hour == 17)
        }

        do {
            let date2 = calendar.date(byAdding: .day, value: 10, to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
            #expect(components2.hour == 17)
        }

        do {
            let date2 = calendar.date(bySetting: .month, value: 12, of: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 12)
            #expect(components2.day == 1) // not 24
            #expect(components2.hour == 0) // not 17
        }
    }

    @Test func testDateComparison() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 23, minute: 30, second: 10)
        let date2 = calendar.date(from: components2)!

        #expect(calendar.isDate(date1, inSameDayAs: date2) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .day) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .hour) == false)
    }

}
