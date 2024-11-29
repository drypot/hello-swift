//
//  DispatchQueueTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/dispatch
// https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091-CH1-SW1

// Dispatch, also known as Grand Central Dispatch (GCD), ...

// 옛날 기술들이지만, 그래도 한번 정리하고 가야할 것 같아서,

struct DispatchQueueTests {

    @Test func testDispatchGroup() throws {
        let logger = SimpleLogger<Int>()

        let group = DispatchGroup()

        logger.append(1)

        group.enter()
        DispatchQueue.global().async {
            logger.append(2)
            group.leave()
        }

        logger.append(3)

        // 비동기 블럭이 복수개 실행됐을 때 모두를 기다리는데 유용하다.

        group.wait()

        logger.append(4)

        #expect(logger.log() == [1, 3, 2, 4])
    }

    @Test func testSemaphore() throws {
        let logger = SimpleLogger<Int>()

        let semaphore = DispatchSemaphore(value: 0)

        logger.append(1)

        DispatchQueue.global().async {
            logger.append(2)
            semaphore.signal()
        }

        logger.append(3)

        // 비동기 블럭을 한 개만 실행하고 기다리는데 유용하다.
        // 아니면 공용 리소스 n 개중 남는 것이 나올 때까지 대기할 때.

        semaphore.wait()

        logger.append(4)

        #expect(logger.log() == [1, 3, 2, 4])
    }

    @Test func testContinuation() async throws {
        let logger = SimpleLogger<Int>()

        logger.append(1)

        await withCheckedContinuation { continuation in
            logger.append(2)
            DispatchQueue.global().async {
                logger.append(3)
                continuation.resume()
            }
            logger.append(4)
        }

        logger.append(5)

        #expect(logger.log() == [1, 2, 4, 3, 5])
    }

    @Test func testDispatchQueueSync() async throws {
        let logger = SimpleLogger<Int>()

        let queue = DispatchQueue(label: "testDispatchQueueSync")
        var value = 0

        logger.append(1)

        // 리소스 접근을 DispatchQueue.sync 로 동기화할 수도 있다.
        queue.sync {
            logger.append(2)
            value += 1
        }

        logger.append(3)

        #expect(logger.log() == [1, 2, 3])
    }

}
