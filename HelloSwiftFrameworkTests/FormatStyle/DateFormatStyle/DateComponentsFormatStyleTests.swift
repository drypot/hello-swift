//
//  DateComponentsFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct DateComponentsFormatStyleTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testNext30days() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var style = Date.ComponentsFormatStyle(style: .abbreviated)
        style.calendar = calendar
        style.locale = Locale(identifier: "ko_KR")

        let next30days = date ..< calendar.date(byAdding: .day, value: 30, to: date)!

        #expect(next30days.formatted(style) == "4주 2일")

        style.fields = [.day]
        #expect(next30days.formatted(style) == "30일")

        style.fields = [.hour]
        #expect(next30days.formatted(style) == "720시간")
    }

    @Test func testNext90Minutes() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var style = Date.ComponentsFormatStyle(style: .abbreviated)
        style.calendar = calendar
        style.locale = Locale(identifier: "ko_KR")

        let next90min = date ..< calendar.date(byAdding: .minute, value: 90, to: date)!

        #expect(next90min.formatted(style) == "1시간 30분")

        style.fields = [.hour]
        #expect(next90min.formatted(style) == "1시간")

        style.fields = [.minute]
        #expect(next90min.formatted(style) == "90분")

        style.fields = [.hour, .minute]
        #expect(next90min.formatted(style) == "1시간 30분")
    }

    @Test func testNext90MinutesUSStyles() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var style = Date.ComponentsFormatStyle(style: .abbreviated)
        style.calendar = calendar
        style.locale = Locale(identifier: "en_US")

        let next90min = date ..< calendar.date(byAdding: .minute, value: 90, to: date)!

        style.style = .abbreviated
        #expect(next90min.formatted(style) == "1 hr, 30 min")

        style.style = .condensedAbbreviated
        #expect(next90min.formatted(style) == "1hr 30min")

        style.style = .narrow
        #expect(next90min.formatted(style) == "1h 30m")

        style.style = .spellOut
        #expect(next90min.formatted(style) == "one hour, thirty minutes")

        style.style = .wide
        #expect(next90min.formatted(style) == "1 hour, 30 minutes")
    }

    @Test func testFactoryVariable() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let next90min = date ..< calendar.date(byAdding: .minute, value: 90, to: date)!

        #expect(next90min.formatted(.timeDuration) == "1:30:00")
    }

}
