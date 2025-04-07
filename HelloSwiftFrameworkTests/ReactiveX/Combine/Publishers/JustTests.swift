//
//  JustTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

struct JustTests {

    @Test func testJust() throws {
        let logger = SimpleLogger<Int>()

        // 값 하나를 출력한다.

        let _ = Just(42)
            .sink { value in
                logger.append(value)
            }

        #expect(logger.result() == [42])
    }

}
