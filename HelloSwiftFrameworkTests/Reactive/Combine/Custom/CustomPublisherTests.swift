//
//  CustomPublisherTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/3/24.
//

import Foundation
import Combine
import Testing

// https://github.com/drypot/swift-memo/blob/main/md/swift-combine-chain.md
// https://stackoverflow.com/questions/64290068/why-does-the-combine-publisher-protocol-have-receives-and-subscribes-with-id

struct CustomPublisherTests {

    struct CustomPublisher<Output, Failure: Error> : Publisher {

        let values: [Output]

        init(values: [Output]) {
            self.values = values
        }

        func receive<S>(subscriber: S)
        where S: Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = CustomPublisherSubscription(
                subscriber: subscriber,
                values: values
            )
            subscriber.receive(subscription: subscription)
        }
    }

    class CustomPublisherSubscription<S, Output>: Subscription
    where S: Subscriber, S.Input == Output {
        private var subscriber: S?

        let values: [Output]
        var index = 0

        init(subscriber: S, values: [Output]) {
            self.subscriber = subscriber
            self.values = values
        }

        func request(_ demand: Subscribers.Demand) {
            var remainingDemand = demand
            while remainingDemand > 0 && index < values.count {
                let value = values[index]
                index += 1
                _ = subscriber?.receive(value)
                remainingDemand -= 1
            }
            if index == values.count {
                subscriber?.receive(completion: .finished)
            }
        }

        func cancel() {
            subscriber = nil
        }
    }

    @Test func testCustomPublisher() throws {
        let logger = SimpleLogger<Int>()

        let publisher = CustomPublisher<Int, Never>(values: [1, 2, 3, 4, 5])

        let sink = Subscribers.Sink<Int, Never> { completion in
            logger.append(99)
        } receiveValue: { value in
            logger.append(value)
        }

        publisher.subscribe(sink)

        #expect(logger.log() == [1, 2, 3, 4, 5, 99])
    }

}
