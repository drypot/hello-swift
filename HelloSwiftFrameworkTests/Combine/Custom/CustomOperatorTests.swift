//
//  CustomOperatorTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/3/24.
//

import Foundation
import Combine
import Testing

// https://github.com/drypot/swift-memo/blob/main/md/swift-combine-chain.md

struct CustomOperatorTests {

    struct CustomOperator<Upstream, Output>: Publisher
    where Upstream: Publisher {
        typealias Failure = Upstream.Failure

        let upstream: Upstream
        let transform: (Upstream.Output) -> Output?

        init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.transform = transform
        }

        func receive<S>(subscriber: S)
        where S: Subscriber, Output == S.Input, Failure == S.Failure {
            let subscription = CustomOperatorSubscription(
                subscriber: subscriber,
                transform: transform
            )
            upstream.subscribe(subscription)
        }
    }

    class CustomOperatorSubscription<S, Input, Failure>: Subscriber, Subscription
    where S: Subscriber, Failure: Error, S.Failure == Failure {

        private var subscriber: S?
        private let transform: (Input) -> S.Input?
        private var subscription: Subscription?

        init(subscriber: S, transform: @escaping (Input) -> S.Input?) {
            self.subscriber = subscriber
            self.transform = transform
        }

        func receive(subscription: Subscription) {
            self.subscription = subscription
            subscriber?.receive(subscription: self)
        }

        func request(_ demand: Subscribers.Demand) {
            subscription?.request(demand)
        }

        func receive(_ input: Input) -> Subscribers.Demand {
            guard let value = transform(input) else { return .none }
            return subscriber?.receive(value) ?? .none
        }

        func receive(completion: Subscribers.Completion<Failure>) {
            subscriber?.receive(completion: completion)
        }

        func cancel() {
            subscription?.cancel()
            subscriber = nil
        }
    }

    @Test func testCustomOperator() throws {
        let logger = SimpleLogger<Int>()

        let publisher = [1, 2, 3, 4, 5].publisher
        let operator_ = CustomOperator(upstream: publisher) { $0 * 2 }
        let subscriber = Subscribers.Sink<Int, Never> { completion in
            logger.append(99)
        } receiveValue: { value in
            logger.append(value)
        }

        operator_.subscribe(subscriber)

        #expect(logger.log() == [2, 4, 6, 8, 10, 99])
    }
}
