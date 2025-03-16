//
//  DateComponentsFormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct DateComponentsFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date1410 = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactoryVariable() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let duration = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        #expect(duration.formatted(.timeDuration) == "1:30:00")
    }

    @Test func test30days() throws {
        let calendar = Calendar(identifier: .gregorian)

        let days30 = date1410 ..< calendar.date(byAdding: .day, value: 30, to: date1410)!

        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: nil
            )

            #expect(days30.formatted(style) == "4주 2일")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: [.day]
            )

            #expect(days30.formatted(style) == "30일")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: [.hour]
            )

            #expect(days30.formatted(style) == "720시간")
        }
    }

    @Test func test90Minutes() throws {
        let calendar = Calendar(identifier: .gregorian)

        let min90 = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: nil
            )

            #expect(min90.formatted(style) == "1시간 30분")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: [.hour]
            )

            #expect(min90.formatted(style) == "1시간")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: [.minute]
            )

            #expect(min90.formatted(style) == "90분")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated,
                locale: Locale(identifier: "ko_KR"),
                calendar: Calendar(identifier: .gregorian),
                fields: [.hour, .minute]
            )

            #expect(min90.formatted(style) == "1시간 30분")
        }
    }

    @Test func test90MinutesUS() throws {
        let calendar = Calendar(identifier: .gregorian)

        let min90 = date1410 ..< calendar.date(byAdding: .minute, value: 90, to: date1410)!

        do {
            let style = Date.ComponentsFormatStyle(
                style: .abbreviated, locale: Locale(identifier: "en_US"), calendar: Calendar(identifier: .gregorian)
            )

            #expect(min90.formatted(style) == "1 hr, 30 min")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .condensedAbbreviated, locale: Locale(identifier: "en_US"), calendar: Calendar(identifier: .gregorian)
            )

            #expect(min90.formatted(style) == "1hr 30min")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .narrow, locale: Locale(identifier: "en_US"), calendar: Calendar(identifier: .gregorian)
            )

            #expect(min90.formatted(style) == "1h 30m")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .spellOut, locale: Locale(identifier: "en_US"), calendar: Calendar(identifier: .gregorian)
            )

            #expect(min90.formatted(style) == "one hour, thirty minutes")
        }
        do {
            let style = Date.ComponentsFormatStyle(
                style: .wide, locale: Locale(identifier: "en_US"), calendar: Calendar(identifier: .gregorian)
            )

            #expect(min90.formatted(style) == "1 hour, 30 minutes")
        }
    }

}
