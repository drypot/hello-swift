//
//  NumberFormatterTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/25/24.
//

import Foundation
import Testing

struct NumberFormatterTests {

    @Test func test() throws {
        // TO DO
    }

    @Test func testNumberFormatter() throws {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        let priceString = numberFormatter.string(from: 19.99) // "$19.99"
    }

    @Test func testMeasurementFormatter() throws {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.locale = Locale(identifier: "en_US")
        //let measurementString = formatter.string(from: Measurement(value: 1000, unit: ))

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .medium
        let distance = Measurement(value: 5.5, unit: UnitLength.kilometers)
        let distanceString = measurementFormatter.string(from: distance) // "5.5 km"
    }
    @Test func testByteCountFormatter() throws {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useMB
        formatter.countStyle = .file
        let fileSizeString = formatter.string(fromByteCount: 1048576) // "1 MB"
    }
}
