//
//  FailTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwiftFramework
import Testing

struct FailTests {

    @Test func testFail() throws {
        let logger = SimpleLogger<Int>()

        enum CustomError: Error {
            case someError
        }

        let _ = Fail(outputType: Int.self, failure: CustomError.someError)
            .sink { completion in
                switch completion {
                case .finished:
                    logger.log(1)
                case .failure:
                    logger.log(2)
                }
            } receiveValue: { _ in
                logger.log(3)
            }

        #expect(logger.result() == [2])
    }

}
