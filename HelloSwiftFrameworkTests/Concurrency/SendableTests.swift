//
//  SendableTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Sendable-Types
// https://developer.apple.com/documentation/swift/sendable

// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0430-transferring-parameters-and-results.md

// Task, and Actor:
// Concurrent 하게 실행되는 프로그램 피스들을 만들 수 있는 도구.

// Concurrency domain:
// Task 나 Actor 가 실행되는 개념적인 바운더리 또는 컨텍스트.
// 그 안에서 변수나 프로퍼티 같은 뮤터블한 상태를 관리한다.
// Actor 같은 경우 도메인을 보호하기 위해 isolation 개념을 적용한다.
// Concurrency domain 간에 공유할 수 있는 데이터와 그렇지 못하는 데이터가 있다.

// Sendable:
// protocol 이다.
// Concurrency domain 간에 공유할 수 있는 데이터 타입을 표시한다.

// Sendable protocol doesn’t have any code requirements,
// but it does have semantic requirements that Swift enforces.

// Value types
// Actor types
// Immutable classes
// Internally-synchronized class
// @Sendable function types

struct SendableTests {

    @Test func testSendable() async throws {

        actor Box {
            var intType = 10

            var arrayType = [1, 2, 3]

            actor ActorType { }
            var actorType = ActorType()

            final class SendableClass: Sendable { }
            var sendableClass = SendableClass()

            final class NonisolatedClass: Sendable {
                nonisolated(unsafe) var name = "max"
            }
            var nonisolatedClass = NonisolatedClass()

            var sendableFunction = { @Sendable in 10 }
        }

        let box = Box()

        _ = await box.intType
        _ = await box.arrayType
        _ = await box.actorType
        _ = await box.sendableClass
        _ = await box.nonisolatedClass
        _ = await box.sendableFunction
    }

}
