//
//  CustomPublisherTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/3/24.
//

import Foundation
import Combine
import Testing

struct CustomPublisherTests {

    struct CustomPublisher: Publisher {
        typealias Output = Int
        typealias Failure = Never

        let values: [Int]

        init(values: [Int]) {
            self.values = values
        }

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = CustomSubscription(subscriber: subscriber, values: values)
            subscriber.receive(subscription: subscription)
        }
    }

    class CustomSubscription<S: Subscriber, Input>: Subscription where S.Input == Input {
        private var subscriber: S?

        let values: [Input]
        var index = 0

        init(subscriber: S, values: [Input]) {
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

    struct CustomFilter<Upstream: Publisher>: Publisher {
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure

        let upstream: Upstream
        let filter: (Upstream.Output) -> Bool

        func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            let subscription = CustomFilterSubscription(
                subscriber: subscriber,
                upstream: upstream,
                filter: filter
            )
            upstream.subscribe(subscription)
        }
    }

    private class CustomFilterSubscription<S: Subscriber, Upstream: Publisher>: Subscriber, Subscription where S.Input == Upstream.Output, S.Failure == Upstream.Failure {
        private var subscriber: S?
        private let filter: (Upstream.Output) -> Bool
        private var subscription: Subscription?

        init(subscriber: S, upstream: Upstream, filter: @escaping (Upstream.Output) -> Bool) {
            self.subscriber = subscriber
            self.filter = filter
        }

        func receive(subscription: Subscription) {
            self.subscription = subscription
            subscriber?.receive(subscription: self)
        }

        func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            if filter(input) {
                return subscriber?.receive(input) ?? .none
            } else {
                return .none
            }
        }

        func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            subscriber?.receive(completion: completion)
        }

        func request(_ demand: Subscribers.Demand) {
            subscription?.request(demand)
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

        let _ = CustomPublisher(values: [1, 2, 3, 4, 5])
            .sink { completion in
                logger.append(99)
            } receiveValue: { value in
                logger.append(value)
            }

        #expect(logger.log() == [1, 2, 3, 4, 5, 99])
    }

    @Test func testCustomSubscriber() throws {
        let subscriber = CustomSubscriber()
        CustomPublisher(values: [1, 2, 3, 4, 5]).subscribe(subscriber)

        #expect(subscriber.logger.log() == [-99, 1, 2, 3, 4, 5, 99])
    }
}
