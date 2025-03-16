//
//  DurationTimeFormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/30/24.
//

import Foundation
import Testing

struct DurationTimeFormatTests {

    @Test func testFactoryVariable() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(.time(pattern: .hourMinute)) == "3:45")
        #expect(seconds.formatted(.time(pattern: .hourMinuteSecond)) == "3:45:15")
        #expect(seconds.formatted(.time(pattern: .minuteSecond)) == "225:15")
    }

    @Test func testHourMinute() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        let style = Duration.TimeFormatStyle(
            pattern: .hourMinute(padHourToLength: 2),
            locale: Locale(identifier: "ko_KR")
        )

        #expect(seconds.formatted(style) == "03:45")
    }

    @Test func testHourMinuteWithRoundSeconds() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        let style = Duration.TimeFormatStyle(
            pattern: .hourMinute(padHourToLength: 2, roundSeconds: .up),
            locale: Locale(identifier: "ko_KR")
        )

        #expect(seconds.formatted(style) == "03:46")
    }

    @Test func testHourMinuteSecond() throws {
        // 수식을 milliseconds() 에 바로 넣으니 컴파일 타임 초과 에러가 난다;
        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        let style = Duration.TimeFormatStyle(
            pattern: .hourMinuteSecond(padHourToLength: 2, fractionalSecondsLength: 3),
            locale: Locale(identifier: "ko_KR")
        )

        #expect(millis.formatted(style) == "03:45:15.777")
    }

    @Test func testMinuteSecond() throws {
        // 수식을 milliseconds() 에 바로 넣으니 컴파일 타임 초과 에러가 난다;
        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        let style = Duration.TimeFormatStyle(
            pattern: .minuteSecond(padMinuteToLength: 0, fractionalSecondsLength: 3),
            locale: Locale(identifier: "ko_KR")
        )

        #expect(millis.formatted(style) == "225:15.777")
    }

}
