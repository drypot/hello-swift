//
//  SubscribersTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

// https://developer.apple.com/documentation/combine

struct SubscribersTests {

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

    @Test func testAssign() throws {
        class Receiver {
            let logger = SimpleLogger<Int>()
            var value: Int {
                get { 0 }
                set {
                    logger.append(newValue)
                }
            }
        }

        let receiver = Receiver()

        let _ = [1, 2, 3, 4, 5].publisher
            .assign(to: \.value, on: receiver)

        receiver.logger.append(99)

        #expect(receiver.logger.log() == [1, 2, 3, 4, 5, 99])
    }

}
