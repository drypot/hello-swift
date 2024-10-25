//
//  CalendarTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/26/24.
//

import Foundation
import Testing

struct CalendarTests {

    @Test func testCalendar() throws {
        let _ = Calendar.current

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")

        #expect(calendar.identifier == .gregorian)
    }

    @Test func testTimeZone() throws {
        let _ = TimeZone.current

        let timeZone = TimeZone(identifier: "Asia/Seoul")!

        #expect(timeZone.identifier == "Asia/Seoul")

        // secondsFromGMT 은 Date 를 요구하는데 Daylight Saving Time 을 사용하는 지역 때문에 그렇다.
        // 한국은 서머 타임이 없으므로 default 를 사용하면 된다.

        #expect(timeZone.secondsFromGMT() == 60*60*9) // 9시간 차

        #expect(timeZone.localizedName(for: .generic, locale: Locale(identifier: "ko_KR")) == "대한민국 표준시")

        #expect(timeZone.localizedName(for: .generic, locale: Locale(identifier: "en_US")) == "Korean Standard Time")
    }

    @Test func testLocale() throws {
        let _ = Locale.current

        let locale = Locale(identifier: "ko_KR")

        #expect(locale.identifier == "ko_KR")
    }

}
