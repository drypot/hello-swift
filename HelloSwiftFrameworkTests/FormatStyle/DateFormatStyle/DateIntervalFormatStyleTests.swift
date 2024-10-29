//
//  DateIntervalFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct DateIntervalFormatStyleTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFactoryVariable() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let next30days = date ..< calendar.date(byAdding: .day, value: 30, to: date)!

        #expect(next30days.formatted(.interval) == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")
        #expect(next30days.formatted(.interval.month(.wide).day()) == "10월 24일 ~ 11월 23일")
    }

    @Test func testPredefined() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let next30days = date ..< calendar.date(byAdding: .day, value: 30, to: date)!

        #expect(next30days.formatted() == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")

        #expect(next30days.formatted(date: .numeric, time: .omitted)     == "2024. 10. 24. ~ 2024. 11. 23.")
        #expect(next30days.formatted(date: .abbreviated, time: .omitted) == "2024년 10월 24일 ~ 11월 23일")
        #expect(next30days.formatted(date: .long, time: .omitted)        == "2024년 10월 24일 ~ 11월 23일")
        #expect(next30days.formatted(date: .complete, time: .omitted)    == "2024년 10월 24일 목요일 ~ 11월 23일 토요일")

        #expect(next30days.formatted(date: .omitted, time: .shortened)   == "2024. 10. 24. 오후 5:30 ~ 2024. 11. 23. 오후 5:30")
        #expect(next30days.formatted(date: .omitted, time: .standard)    == "2024. 10. 24. 오후 5:30:10 ~ 2024. 11. 23. 오후 5:30:10")
        #expect(next30days.formatted(date: .omitted, time: .complete)    == "2024. 10. 24. 오후 5시 30분 10초 GMT+9 ~ 2024. 11. 23. 오후 5시 30분 10초 GMT+9")

        let next3hours = date ..< calendar.date(byAdding: .hour, value: 3, to: date)!

        #expect(next3hours.formatted(date: .omitted, time: .shortened)   == "오후 5:30~8:30")
        #expect(next3hours.formatted(date: .omitted, time: .standard)    == "오후 5:30:10 ~ 오후 8:30:10")
        #expect(next3hours.formatted(date: .omitted, time: .complete)    == "오후 5시 30분 10초 GMT+9 ~ 오후 8시 30분 10초 GMT+9")
    }

    @Test func testPredefined2() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let next30days = date ..< calendar.date(byAdding: .day, value: 30, to: date)!

        var style = Date.IntervalFormatStyle(date: .abbreviated, time: .shortened)
        style.calendar = calendar
        style.locale = Locale(identifier: "ko_KR")
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(next30days.formatted(style) == "2024년 10월 24일 오후 5:30 ~ 2024년 11월 23일 오후 5:30")
        #expect(next30days.formatted(style) == next30days.formatted(date: .abbreviated, time: .shortened))
    }

    @Test func testModifiers() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let next30days = date ..< calendar.date(byAdding: .day, value: 30, to: date)!

        var style = Date.IntervalFormatStyle()
            .month(.wide)
            .day()
            .weekday(.short)
            .hour(.conversationalTwoDigits(amPM: .wide))

        style.calendar = calendar
        style.locale = Locale(identifier: "ko_KR")
        style.timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(next30days.formatted(style) == "10월 24일 (목) 오후 5시 ~ 11월 23일 (토) 오후 5시")
    }

}
