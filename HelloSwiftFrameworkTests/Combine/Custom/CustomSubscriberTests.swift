//
//  CustomSubscriberTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/3/24.
//

import Foundation
import Combine
import Testing

// https://github.com/drypot/swift-memo/blob/main/md/swift-combine-chain.md

struct CustomSubscriberTests {

    class CustomSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never

        let logger = SimpleLogger<Int>()

        init() {
        }

        func receive(subscription: Subscription) {
            logger.append(-99)
            subscription.request(.unlimited)
        }

        func receive(_ input: Input) -> Subscribers.Demand {
            logger.append(input)
            return .unlimited
        }

        func receive(completion: Subscribers.Completion<Never>) {
            logger.append(99)
        }
    }

    @Test func testCustomSubscriber() throws {
        let publisher = [1, 2, 3, 4, 5].publisher
        let subscriber = CustomSubscriber()

        publisher.subscribe(subscriber)

        #expect(subscriber.logger.log() == [-99, 1, 2, 3, 4, 5, 99])
    }

}
