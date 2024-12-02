//
//  PublishersTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

struct PublishersTests {

    @Test func testFuture() throws {
        let logger = SimpleLogger<Int>()

        // Future 는 single value 를 생성하고 종료한다.
        // Future 는 클로져를 인자로 받는데 이 클로져는 promise 펑션을 인자로 받는다.
        // promise 펑션은 Result 타입을 인자로 받는다.
        // Future 클로져에서 작업이 끝나면 promise 를 콜해서 결과를 넘기면 된다.

        let _ = Future { promise in
            promise(.success(10))
        }
        .sink { value in
            logger.append(value)
        }

        #expect(logger.log() == [10])
    }

    @Test func testFutureAwait() async throws {

        // 동기 코드를 비동기 환경에 연결하는데 사용할 수도 있다.
        // value 를 await 한다.

        let value1 = await Future { promise in
            promise(.success(10))
        }.value

        #expect(value1 == 10)

        // 하지만 withCheckedContinuation 이 기능상 더 무난해 보인다.

        let value2 = await withCheckedContinuation { continuation in
            continuation.resume(returning: 20)
        }

        #expect(value2 == 20)
    }

    @Test func testJust() throws {
        let logger = SimpleLogger<Int>()

        // 값 하나를 출력한다.

        let _ = Just(42)
            .sink { value in
                logger.append(value)
            }

        #expect(logger.log() == [42])
    }

    @Test func testDeffered() throws {
        let logger = SimpleLogger<Int>()

        // Subscriber 가 붙으면 Publisher 를 생성한다.

        let _ = Deferred {
            return Just(42)
        }
        .sink { value in
            logger.append(value)
        }

        #expect(logger.log() == [42])
    }

    @Test func testEmpty() throws {
        let logger = SimpleLogger<Int>()

        let _ = Empty()
            .sink { value in
                logger.append(value)
            }

        #expect(logger.log() == [])
    }

    @Test func testFail() throws {
        let logger = SimpleLogger<Int>()

        struct SomeError: Error {
        }

        let _ = Fail(outputType: Int.self, failure: SomeError())
            .sink { completion in
                switch completion {
                case .finished:
                    logger.append(1)
                case .failure:
                    logger.append(2)
                }
            } receiveValue: { _ in
                logger.append(3)
            }

        #expect(logger.log() == [2])
    }

}
