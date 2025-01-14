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

    @Test func testFactoryVariable() throws {
        let string = date.formatted(.dateTime.year().month().day())
        #expect(string == "2024년 10월 24일")
    }

    @Test func testPredefined() throws {
        // Calendar, TimeZone, Locale 이 다르면 오류가 날 것이다;

        #expect(date.formatted() == "2024. 10. 24. 오후 5:30")

        #expect(date.formatted(date: .numeric, time: .omitted)     == "2024. 10. 24.")
        #expect(date.formatted(date: .abbreviated, time: .omitted) == "2024년 10월 24일")
        #expect(date.formatted(date: .long, time: .omitted)        == "2024년 10월 24일")
        #expect(date.formatted(date: .complete, time: .omitted)    == "2024년 10월 24일 목요일")

        #expect(date.formatted(date: .omitted, time: .shortened)   == "오후 5:30")
        #expect(date.formatted(date: .omitted, time: .standard)    == "오후 5:30:10")
        #expect(date.formatted(date: .omitted, time: .complete)    == "오후 5시 30분 10초 GMT+9")
    }

    @Test func testFormatStyle() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var style = Date.FormatStyle()
        style.calendar = calendar
        style.locale = Locale(identifier: "ko_KR")
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let string1 = date.formatted(style)
        let string2 = style.format(date)

        #expect(string1 == string2)
        #expect(string1 == "2024. 10. 24. 오후 5:30")
    }

    @Test func testModifiers() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var style = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.twoDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .weekday(.abbreviated)
            .timeZone(.omitted)

        style.calendar = calendar
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        style.locale = Locale(identifier: "ko_KR")
        #expect(date.formatted(style) == "2024년 10월 24일 (목) 오후 5:30")

        style.locale = Locale(identifier: "en_US")
        #expect(date.formatted(style) == "Thu, Oct 24, 2024 at 5:30 PM")
    }

    @Test func testLongModifiers() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

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

        style.calendar = calendar
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        style.locale = Locale(identifier: "ko_KR")
        #expect(date.formatted(style) == "서기 2024년 10월 24일 (목) (주: 43) 오후 5:30 Asia/Seoul")

        style.locale = Locale(identifier: "en_US")
        #expect(date.formatted(style) == "Thu, Oct 24, 2024 Anno Domini (week: 43) at 5:30 PM Asia/Seoul")

        style.locale = Locale(identifier: "zh_CN")
        #expect(date.formatted(style) == "公元2024年10月24日 周四 (周: 43) Asia/Seoul 17:30")

        style.locale = Locale(identifier: "ja_JP")
        #expect(date.formatted(style) == "西暦2024年10月24日(木) (週: 43) 17:30 Asia/Seoul")
    }

}
