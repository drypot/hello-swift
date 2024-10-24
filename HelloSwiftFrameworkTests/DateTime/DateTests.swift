//
//  DateTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/23/24.
//

import Foundation
import Testing

struct DateTests {

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

    @Test func testMakingSomeDate() throws {
        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)

        var components2 = DateComponents()
        components2.year = 2024
        components2.month = 10
        components2.day = 24
        components2.hour = 17
        components2.minute = 30
        components2.second = 10

        #expect(components1 == components2)

        let date = Calendar.current.date(from: components1)!

        let check = Calendar.current.dateComponents([.year, .month, .day], from: date)

        #expect(check.year == 2024)
        #expect(check.month == 10)
        #expect(check.day == 24)
    }

    @Test func testLocale() throws {
        let _ = Locale.current
        let locale = Locale(identifier: "ko_KR")

        #expect(locale.identifier == "ko_KR")
    }

    @Test func testTimeZone() throws {
        let _ = TimeZone.current
        let timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(timeZone.identifier == "Asia/Seoul")

        let localeUS = Locale(identifier: "en_US")
        let timeZoneName = timeZone.localizedName(for: .generic, locale: localeUS)

        #expect(timeZoneName == "Korean Standard Time")

        // secondsFromGMT 은 Date 를 요구하는데 Daylight Saving Time 을 사용하는 지역 때문에 그렇다.
        // 한국은 서머 타임이 없으므로 기본값 Date() 를 사용하면 된다.

        #expect(timeZone.secondsFromGMT() == 60*60*9) // 9시간 차
    }

    @Test func testCalendar() throws {
        let _ = Calendar.current

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(calendar.identifier == .gregorian)
        #expect(calendar.timeZone.identifier == "Asia/Seoul")
    }

    @Test func testDateComponentsFromDate() throws {
        let calendar = Calendar(identifier: .gregorian)
        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        do {
            #expect(calendar.component(.year, from: date1) == 2024)
            #expect(calendar.component(.month, from: date1) == 10)
            #expect(calendar.component(.day, from: date1) == 24)
            #expect(calendar.component(.hour, from: date1) == 17)
            #expect(calendar.component(.minute, from: date1) == 30)
            #expect(calendar.component(.second, from: date1) == 10)
        }

        do {
            let check = calendar.dateComponents([.year, .month, .day], from: date1)

            #expect(check.year == 2024)
            #expect(check.month == 10)
            #expect(check.day == 24)
            #expect(check.hour == nil)
        }

        do {
            // Extract DateComponents from Date

            let check = calendar.dateComponents([.hour, .minute, .second], from: date1)

            #expect(check.year == nil)
            #expect(check.hour == 17)
            #expect(check.minute == 30)
            #expect(check.second == 10)
        }

        do {
            // 모든 Component 를 싹 받는 편한 방법은 타임존 기술하는 방법 밖엔 없는 것 같다.
            let check = calendar.dateComponents(in: calendar.timeZone, from: date1)

            #expect(check.year == 2024)
            #expect(check.month == 10)
            #expect(check.day == 24)
            #expect(check.hour == 17)
            #expect(check.minute == 30)
            #expect(check.second == 10)
        }
    }

    @Test func testDateArithmetic() throws {
        let calendar = Calendar(identifier: .gregorian)
        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        do {
            let date2 = calendar.date(byAdding: DateComponents(day: 10), to: date1)!
            let check = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(check.year == 2024)
            #expect(check.month == 11)
            #expect(check.day == 3)
        }

        do {
            let date2 = calendar.date(byAdding: .day, value: 10, to: date1)!
            let check = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(check.year == 2024)
            #expect(check.month == 11)
            #expect(check.day == 3)
        }

        do {
            let date2 = calendar.date(bySetting: .day, value: 12, of: date1)!
            let check = calendar.dateComponents([.year, .month, .day], from: date2)

            #expect(check.year == 2024)
            #expect(check.month == 12)
            #expect(check.day == 3)
        }
    }

    @Test func testDateComparison() throws {
        let calendar = Calendar(identifier: .gregorian)

        let components1 = DateComponents(year: 2024, month: 10, day: 24, hour: 17, minute: 30, second: 10)
        let date1 = calendar.date(from: components1)!

        let components2 = DateComponents(year: 2024, month: 10, day: 24, hour: 23, minute: 30, second: 10)
        let date2 = calendar.date(from: components2)!

        #expect(calendar.isDate(date1, inSameDayAs: date2) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .day) == true)
        #expect(calendar.isDate(date1, equalTo: date2, toGranularity: .hour) == false)
    }

    @Test func testTimeInterval() throws {
        // TimeInterval = Double

        // 2001-01-01
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

        #expect(referenceDate.timeIntervalSinceReferenceDate == 0)
        #expect(referenceDate.timeIntervalSince1970 == 978307200.0)
        #expect(referenceDate.timeIntervalSince1970 == Date.timeIntervalBetween1970AndReferenceDate)

        let date1 = Date(timeIntervalSinceReferenceDate: 751451410.0)

        #expect(date1.timeIntervalSinceReferenceDate == 751451410.0)
        #expect(date1.timeIntervalSince1970 == 1729758610.0)

        let interval1 = referenceDate.distance(to: date1)
        let interval2 = date1.timeIntervalSince(referenceDate)

        #expect(interval1 == interval2)
    }

}
