//
//  DateFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct DateFormatStyleTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFormatted() throws {
        #expect(date.formatted() == "2024. 10. 24. 오후 5:30")

        #expect(date.formatted(date: .numeric, time: .omitted)     == "2024. 10. 24.")
        #expect(date.formatted(date: .abbreviated, time: .omitted) == "2024년 10월 24일")
        #expect(date.formatted(date: .long, time: .omitted)        == "2024년 10월 24일")
        #expect(date.formatted(date: .complete, time: .omitted)    == "2024년 10월 24일 목요일")

        #expect(date.formatted(date: .omitted, time: .shortened)   == "오후 5:30")
        #expect(date.formatted(date: .omitted, time: .standard)    == "오후 5:30:10")
        #expect(date.formatted(date: .omitted, time: .complete)    == "오후 5시 30분 10초 GMT+9")
    }

    @Test func testDateTimeVar() throws {

        // 편의를 위해 .dateTime 변수가 제공된다.
        // Date.FormatStyle() 길게 쓰는 것과 같다.

        #expect(date.formatted(Date.FormatStyle().year()) == date.formatted(.dateTime.year()))
        #expect(date.formatted(.dateTime.year()) == "2024년")
    }

    @Test func testStyle0() throws {
        var style = Date.FormatStyle()
        style.locale = Locale(identifier: "ko_KR")
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(date.formatted(style) == "2024. 10. 24. 오후 5:30")
        #expect(date.formatted(style) == style.format(date))
    }

    @Test func testStyle1() throws {
        var style = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .timeZone(.identifier(.long))
            .era(.wide)
            .dayOfYear(.defaultDigits)
            .weekday(.abbreviated)
            .week(.defaultDigits)

        do {
            style.locale = Locale(identifier: "ko_KR")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "서기 2024년 10월 24일 (목) (주: 43) 오후 5:30 Asia/Seoul")
        }

        do {
            style.locale = Locale(identifier: "en_US")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "Thu, Oct 24, 2024 Anno Domini (week: 43) at 5:30 PM Asia/Seoul")
        }

        do {
            style.locale = Locale(identifier: "zh_CN")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "公元2024年10月24日 周四 (周: 43) Asia/Seoul 17:30")
        }

        do {
            style.locale = Locale(identifier: "ja_JP")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "西暦2024年10月24日(木) (週: 43) 17:30 Asia/Seoul")
        }
    }

    @Test func testStyle2() throws {
        var style = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .weekday(.abbreviated)
            .timeZone(.omitted)

        do {
            style.locale = Locale(identifier: "ko_KR")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "2024년 10월 24일 (목) 오후 5:30")
        }

        do {
            style.locale = Locale(identifier: "en_US")
            style.timeZone = TimeZone(identifier: "Asia/Seoul")!

            #expect(date.formatted(style) == "Thu, Oct 24, 2024 at 5:30 PM")
        }
    }

    @Test func testParsing() throws {
        let inputString = "Archive for month 8, archived on day 23 - complete."
        let strategy = Date.ParseStrategy(
            format: "Archive for month \(month: .defaultDigits), archived on day \(day: .twoDigits) - complete.",
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(abbreviation: "CDT")!
        )

//        let date = try! Date(inputString, strategy: strategy).
//        #expect()

//        let input = "2024년 10월 24일 (목) 오후 5:30"
//        let format = Date.FormatStyle()
//            .year(.defaultDigits)
//            .month(.abbreviated)
//            .day(.twoDigits)
//            .hour(.defaultDigits(amPM: .abbreviated))
//            .minute(.twoDig
//                    }
    }

}
