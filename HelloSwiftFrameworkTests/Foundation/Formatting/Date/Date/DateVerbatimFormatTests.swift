//
//  DateVerbatimFormatTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/foundation/date/verbatimformatstyle/
// https://developer.apple.com/documentation/foundation/date/formatstring
// https://developer.apple.com/documentation/foundation/date/formatstring/stringinterpolation

struct DateVerbatimFormatTests {

    // 2024-10-24 08:30:10 +0000
    // 2024-10-24 17:30:10 +0900
    let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

    @Test func testFormatStyleWithDefaults() throws {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Seoul")!

        let style = Date.VerbatimFormatStyle(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)",
            timeZone: timeZone,
            calendar: calendar
        )

        let string1 = date.formatted(style)
        let string2 = style.format(date)

        #expect(string1 == string2)
        #expect(string1 == "2024-10-24 17:30:10")
    }
}
