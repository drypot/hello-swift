//
//  DefferedTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwiftFramework
import Testing

struct DefferedTests {

    @Test func testDeffered() throws {
        let logger = SimpleLogger<Int>()

        // Subscriber 가 붙으면 Publisher 를 생성한다.

        let _ = Deferred {
            return Just(42)
        }
        .sink { value in
            logger.log(value)
        }

        #expect(logger.result() == [42])
    }

}
