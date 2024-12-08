//
//  FutureTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

struct FutureTests {

    @Test func testFuture() throws {
        let logger = SimpleLogger<Int>()

        // Future 는 클로져를 인자로 받는데 이 클로져는 promise 펑션을 인자로 받는다.
        // promise 펑션은 Result 타입을 인자로 받는다.
        // Future 클로져에서 작업이 끝나면 promise 를 콜해서 결과를 넘긴다.
        // Future 는 single value 만 생성하고 종료된다.

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

}
