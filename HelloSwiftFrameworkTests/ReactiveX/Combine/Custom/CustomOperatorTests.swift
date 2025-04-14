//
//  CustomOperatorTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/3/24.
//

import Foundation
import Combine
import HelloSwiftFramework
import Testing

// https://github.com/drypot/swift-memo/blob/main/md/swift-combine-chain.md

struct CustomOperatorTests {

    struct CustomOperator<Upstream, Output>: Publisher
    where Upstream: Publisher {
        typealias Failure = Upstream.Failure

        let upstream: Upstream
        let transform: (Upstream.Output) -> Output?

        // 1차, 위에서 아래로 Publisher, Operator 들이 만들어 진다.
        init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.transform = transform
        }

        // 2차, 아래서 위로 하위 Subscription 을 상위 Subscription 연결한다.
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

        // 3차, 위에서 아래로 상위 Subscription 을 하위 Subscription 에 연결한다.
        func receive(subscription: Subscription) {
            self.subscription = subscription
            subscriber?.receive(subscription: self)
        }

        // 4차, 아래에서 위로 request 를 올려보낸다.
        func request(_ demand: Subscribers.Demand) {
            subscription?.request(demand)
        }

        // 5차, 위에서 아래로 value 를 내려보낸다.
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
            logger.log(99)
        } receiveValue: { value in
            logger.log(value)
        }

        operator_.subscribe(subscriber)

        #expect(logger.result() == [2, 4, 6, 8, 10, 99])
    }
}
