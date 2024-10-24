//
//  DateFormatterTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/24/24.
//

import Foundation
import Testing

struct DateFormatterTests {

    @Test func testDateFormatter() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        print(dateString)
    }

}
