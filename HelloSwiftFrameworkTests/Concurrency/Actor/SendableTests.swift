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

// Sendable: A type that can be shared from one concurrency domain to another.

// Sendable protocol doesn’t have any code requirements,
// but it does have semantic requirements that Swift enforces.

// Value types
// Reference types with no mutable storage
// Reference types that internally manage access to their state
// Functions and closures (by marking them with @Sendable)

struct SendableTests {

    // 클로져 타입 선언할 때 @Sendable 넣을 수 있다.
    fileprivate func fetchData(completion: @Sendable @escaping (Result<String, Error>) -> Void) {
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
