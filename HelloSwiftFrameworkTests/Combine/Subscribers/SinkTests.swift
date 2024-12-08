//
//  SinkTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

// https://developer.apple.com/documentation/combine

struct SinkTests {

    @Test func testSink() throws {
        let logger = SimpleLogger<Int>()

        let _ = [1, 2, 3, 4, 5].publisher
            .sink { completion in
                logger.append(90)
            } receiveValue: { value in
                logger.append(value)
            }

        logger.append(99)

        #expect(logger.log() == [1, 2, 3, 4, 5, 90, 99])
    }

}
