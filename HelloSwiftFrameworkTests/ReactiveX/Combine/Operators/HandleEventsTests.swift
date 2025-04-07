//
//  HandleEventsTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/16/24.
//

import Foundation
import Combine
import Testing

// https://developer.apple.com/documentation/combine

struct HandleEventsTests {

    @Test func test() throws {
        let logger = SimpleLogger<String>()

        let _ = Just("value")

            .handleEvents(receiveSubscription: { _ in
                logger.append("receiveSubscription")
            }, receiveOutput: { _ in
                logger.append("receiveOutput")
            }, receiveCompletion: { _ in
                logger.append("receiveCompletion")
            }, receiveCancel: {
                logger.append("receiveCancel")
            }, receiveRequest: { _ in
                logger.append("receiveRequest")
            })

            .sink { completion in
                logger.append("sink completion")
            } receiveValue: { value in
                logger.append("sink value")
            }

        logger.append("end")

        #expect(logger.result() == [
            "receiveSubscription",
            "receiveRequest",
            "receiveOutput",
            "sink value",
            "receiveCompletion",
            "sink completion",
            "end"
        ])
    }

}
