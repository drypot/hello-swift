//
//  MeasurementFormatStyleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/29/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/foundation/measurement/formatstyle
// https://developer.apple.com/documentation/foundation/measurement/formatstyle/unitwidth

// https://developer.apple.com/documentation/foundation/measurement/formatstyle/3816386-usage
// https://developer.apple.com/documentation/foundation/measurementformatunitusage

struct MeasurementFormatStyleTests {

    @Test func testUnitDuration() throws {
        let m1 = Measurement<UnitDuration>(value: 90, unit: .seconds)
        var style = Measurement<UnitDuration>.FormatStyle(
            width: .abbreviated,
            locale: Locale(identifier: "en_US"),
            usage: .general,
            numberFormatStyle: nil
        )

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "90초")

        // width: .abbreviated
        #expect(m1.formatted(style) == "90 sec")

        style.width = .wide
        #expect(m1.formatted(style) == "90 seconds")

        style.width = .narrow
        #expect(m1.formatted(style) == "90s")

    }

    @Test func testUnitLength() throws {
        let m1 = Measurement<UnitLength>(value: 173, unit: .centimeters)
        var style = Measurement<UnitLength>.FormatStyle(
            width: .abbreviated,
            locale: Locale(identifier: "ko_KR"),
            usage: .personHeight,
            numberFormatStyle: nil
        )

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "1.7m")
        #expect(m1.formatted(.measurement(width: .abbreviated, usage: .personHeight)) == "173cm")

        // width: .abbreviated
        #expect(m1.formatted(style) == "173cm")

        style.width = .wide
        #expect(m1.formatted(style) == "173센티미터")

        style.width = .narrow
        #expect(m1.formatted(style) == "173cm")
    }

    @Test func testByteCount() throws {

        // Measurement.FormatStyle.ByteCount 기닌까
        // 보통은 ByteCountFormatStyle 을 사용하면 되겠다.

        let m1 = Measurement<UnitInformationStorage>(value: 128, unit: .megabytes)
        var style = Measurement<UnitInformationStorage>.FormatStyle.ByteCount(
            style: .memory,
            allowedUnits: .all,
            spellsOutZero: true,
            includesActualByteCount: true,
            locale: Locale(identifier: "en_US")
        )

        #expect(m1.formatted(.measurement(width: .abbreviated)) == "128MB")

        #expect(m1.formatted(style) == "122.1 MB (128,000,000 bytes)")

        style.includesActualByteCount = false
        #expect(m1.formatted(style) == "122.1 MB")

        style.style = .file
        #expect(m1.formatted(style) == "128 MB")

        style.allowedUnits = .kb
        #expect(m1.formatted(style) == "128,000 kB")
    }

}
