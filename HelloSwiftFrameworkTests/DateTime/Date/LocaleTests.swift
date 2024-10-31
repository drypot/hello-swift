//
//  LocaleTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/30/24.
//

import Foundation
import Testing

struct LocaleTests {

    @Test func testLocale() throws {
        let _ = Locale.current

        let locale = Locale(identifier: "ko_KR")

        #expect(locale.identifier == "ko_KR")
    }

}
