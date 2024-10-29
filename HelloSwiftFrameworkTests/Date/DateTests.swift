//
//  DateTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/23/24.
//

import Foundation
import Testing

struct DateTests {

    @Test func testReferenceDate() throws {
        // TimeInterval = Double

        // 2001-01-01
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

        #expect(referenceDate.timeIntervalSinceReferenceDate == 0)
        #expect(referenceDate.timeIntervalSince1970 == 978307200.0)
        #expect(referenceDate.timeIntervalSince1970 == Date.timeIntervalBetween1970AndReferenceDate)

        // 2024-10-24 08:30:10 +0000
        // 2024-10-24 17:30:10 +0900
        let date = Date(timeIntervalSinceReferenceDate: 751451410.0)

        #expect(date.timeIntervalSinceReferenceDate == 751451410.0)
        #expect(date.timeIntervalSince1970 == 1729758610.0)

        #expect(date.timeIntervalSince(referenceDate) == 751451410.0)

        #expect(referenceDate.distance(to: date) == 751451410.0)
    }

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

}
