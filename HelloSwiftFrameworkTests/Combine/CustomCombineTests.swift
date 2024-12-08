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

struct CustomCombineTests {

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

    struct CustomOperator<Upstream, Output>: Publisher
    where Upstream: Publisher {
        typealias Failure = Upstream.Failure

        let upstream: Upstream
        let map: (Upstream.Output) -> Output

        init(upstream: Upstream, map: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.map = map
        }

        func receive<S>(subscriber: S)
        where S: Subscriber, Output == S.Input, Failure == S.Failure {
            let subscription = CustomOperatorSubscription(
                subscriber: subscriber,
                map: map
            )
            upstream.subscribe(subscription)
        }
    }

    class CustomOperatorSubscription<S, Input, Failure>: Subscriber, Subscription
    where S: Subscriber, Failure: Error, S.Failure == Failure {

        private var subscriber: S?
        private let map: (Input) -> S.Input
        private var subscription: Subscription?

        init(subscriber: S, map: @escaping (Input) -> S.Input) {
            self.subscriber = subscriber
            self.map = map
        }

        func receive(subscription: Subscription) {
            self.subscription = subscription
            subscriber?.receive(subscription: self)
        }

        func request(_ demand: Subscribers.Demand) {
            subscription?.request(demand)
        }

        func receive(_ input: Input) -> Subscribers.Demand {
            return subscriber?.receive(map(input)) ?? .none
        }

        func receive(completion: Subscribers.Completion<Failure>) {
            subscriber?.receive(completion: completion)
        }

        func cancel() {
            subscription?.cancel()
            subscriber = nil
        }
    }

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

    @Test func testCustomSubscriber() throws {
        let publisher = CustomPublisher<Int, Never>(values: [1, 2, 3, 4, 5])
        let subscriber = CustomSubscriber()

        publisher.subscribe(subscriber)

        #expect(subscriber.logger.log() == [-99, 1, 2, 3, 4, 5, 99])
    }

    @Test func testCustomOperator() throws {
        let publisher = CustomPublisher<Int, Never>(values: [1, 2, 3, 4, 5])
        let operator_ = CustomOperator(upstream: publisher) { $0 * 2 }
        let subscriber = CustomSubscriber()

        operator_.subscribe(subscriber)

        #expect(subscriber.logger.log() == [-99, 2, 4, 6, 8, 10, 99])
    }
}
