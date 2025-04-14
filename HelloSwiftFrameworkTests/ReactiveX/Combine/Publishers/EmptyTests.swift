//
//  EmptyTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwiftFramework
import Testing

struct EmptyTests {

    @Test func testEmpty() throws {
        let logger = SimpleLogger<Int>()

        let _ = Empty()
            .sink { value in
                logger.log(value)
            }

        #expect(logger.result() == [])
    }

}
