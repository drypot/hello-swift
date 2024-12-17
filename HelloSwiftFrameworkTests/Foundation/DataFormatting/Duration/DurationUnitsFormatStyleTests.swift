//
//  DurationUnitsFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/30/24.
//

import Foundation
import Testing

struct DurationUnitsFormatStyleTests {

    @Test func testFactoryVariable() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        #expect(seconds.formatted(.units(allowed: [.hours, .minutes, .seconds])) == "3시간 45분 15초")
    }

    @Test func testHourMinute() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes],
            width: .wide
        )
        style.locale = Locale(identifier: "en_US")

        #expect(seconds.formatted(style) == "3 hours, 45 minutes")
    }

    @Test func testHourMinuteWithRoundSeconds() throws {
        let secondsRaw = 3*60*60 + 45*60 + 15 // 3:45:15
        let seconds = Duration.seconds(secondsRaw)

        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes],
            width: .wide,
            fractionalPart: .hide(rounded: .up)
        )
        style.locale = Locale(identifier: "en_US")

        #expect(seconds.formatted(style) == "3 hours, 46 minutes")
    }

    @Test func testHourMinuteSecond() throws {
        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes, .seconds, .milliseconds],
            width: .abbreviated
        )
        style.locale = Locale(identifier: "en_US")

        #expect(millis.formatted(style) == "3 hr, 45 min, 15 sec, 777 ms")
    }

    @Test func testMinuteSecond() throws {
        let millisRaw = (3*60*60 + 45*60 + 15)*1000 + 777 // 3:45:15.777
        let millis = Duration.milliseconds(millisRaw)

        var style = Duration.UnitsFormatStyle(
            allowedUnits: [.minutes, .seconds, .milliseconds],
            width: .abbreviated
        )
        style.locale = Locale(identifier: "en_US")

        #expect(millis.formatted(style) == "225 min, 15 sec, 777 ms")
    }

}
