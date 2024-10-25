//
//  DateTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/23/24.
//

import Foundation
import Testing

struct DateTests {

    @Test func testReferenceDate() throws {
        // TimeInterval = Double

        // 2001-01-01
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

        #expect(referenceDate.timeIntervalSinceReferenceDate == 0)
        #expect(referenceDate.timeIntervalSince1970 == 978307200.0)
        #expect(referenceDate.timeIntervalSince1970 == Date.timeIntervalBetween1970AndReferenceDate)

        // 2024-10-24 08:30:10 +0000
        // 2024-10-24 17:30:10 +0900
        let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

        #expect(date.timeIntervalSinceReferenceDate == 751451410.0)
        #expect(date.timeIntervalSince1970 == 1729758610.0)

        #expect(date.timeIntervalSince(referenceDate) == 751451410.0)

        #expect(referenceDate.distance(to: date) == 751451410.0)
    }

    @Test func testMakingNow() throws {

        // Swift’s Date type does not include information about time zones or calendar systems

        let now1 = Date()
        let now2 = Date.now
        let now3 = Date(timeIntervalSinceNow: 0)

        #expect(now2.timeIntervalSince(now1) < 3)
        #expect(now3.timeIntervalSince(now1) < 3)
    }

    @Test func testMakingTomorrow() throws {
        let now = Date.now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        let tomorrow2 = now + 60*60*24
        let tomorrow3 = Date(timeInterval: 60*60*24, since: now) /* in seconds */
        let tomorrow4 = now.addingTimeInterval(60*60*24)
        let tomorrow5 = now.advanced(by: 60*60*24)

        #expect(tomorrow == tomorrow2)
        #expect(tomorrow == tomorrow3)
        #expect(tomorrow == tomorrow4)
        #expect(tomorrow == tomorrow5)
    }

    @Test func testMakingComponents() throws {
        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)

        var components2 = DateComponents()
        components2.year = 2024
        components2.month = 10
        components2.day = 24
        components2.hour = 17
        components2.minute = 30
        components2.second = 10

        #expect(components1 == components2)
    }
    
    @Test func testMakingDateFromComponents() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        let components = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date = calendar.date(from: components)!

        #expect(date == Date(timeIntervalSinceReferenceDate: 751451410.0))
    }

    @Test func testMakingCompoentsFromDate() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

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
    }

    @Test func testComponentFromDate() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        let components = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date = calendar.date(from: components)!

        #expect(calendar.component(.year, from: date) == 2024)
        #expect(calendar.component(.month, from: date) == 10)
        #expect(calendar.component(.day, from: date) == 24)
        #expect(calendar.component(.hour, from: date) == 17)
        #expect(calendar.component(.minute, from: date) == 30)
        #expect(calendar.component(.second, from: date) == 10)
    }

    @Test func testDateArithmetic() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        do {
            let date2 = calendar.date(byAdding: DateComponents(day: 10), to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
        }

        do {
            let date2 = calendar.date(byAdding: .day, value: 10, to: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 11)
            #expect(components2.day == 3)
        }

        do {
            let date2 = calendar.date(bySetting: .month, value: 12, of: date1)!
            let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(components2.year == 2024)
            #expect(components2.month == 12)
            #expect(components2.day == 1) // not 24
        }
    }

    @Test func testDateComparison() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 23, minute: 30, second: 10)
        let date2 = calendar.date(from: components2)!

        #expect(calendar.isDate(date1, inSameDayAs: date2) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .day) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .hour) == false)
    }

}
