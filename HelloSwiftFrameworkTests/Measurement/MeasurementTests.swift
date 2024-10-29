//
//  MeasurementTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

struct MeasurementTests {

    @Test func test() throws {
        let m = Measurement(value: 90, unit: UnitDuration.seconds)

        #expect(m.value == 90)
        #expect(m.unit == .seconds)
        #expect(m.converted(to: .minutes).value == 1.5)

        // TO DO
//        var style = Duration.UnitsFormatStyle(
//        style.locale = Locale(identifier: "en_US_POSIX")
//        #expect(m.formatted(style) == "1.5 minutes")

    }

}
