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
// Reference types with no mutable storage
// Reference types that internally manage access to their state
// Functions and closures (by marking them with @Sendable)

struct SendableTests {

    @Test func testValue() async throws {
        var value = 10

        let result = await Task {
            let result = value + 20
            value += 10
            return result
        }.value

        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            value += 1
        }

        #expect(value == 20)
        #expect(result == 30)
    }
    
    // 클로져 타입 선언할 때 @Sendable 넣을 수 있다.
    // @Sendable 클로저는 클로저 내에서 캡처된 변수나 참조 타입을 변경할 수 없다.
    func fetchData(completion: @Sendable @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async {
            completion(.success("abc"))
        }
    }

    @Test func test() async throws {
        // 여기선 필요없지만, 클로저 정의할 때 인자 앞에 @Sendable 넣을 수 있다.
        let result = await withCheckedContinuation { continuation in
            fetchData { @Sendable result in
                continuation.resume(returning: result)
            }
        }
        _ = result
    }

}
