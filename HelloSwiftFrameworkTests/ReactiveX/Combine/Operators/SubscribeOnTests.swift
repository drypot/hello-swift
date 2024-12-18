//
//  SubscribeOnTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/18/24.
//

import Foundation
import Combine
import Testing

struct SubscribeOnTests {

    // 상단은 background 에서 실행시키고
    // 결과는 main thread 에서 받으려면
    // subscribe(on: DispatchQueue.global())
    // redeive(on: DispatchQueue.main)
    // 조합을 사용한다.

    @Test func test() async throws {
        let logger = SimpleLogger<String>()

        await withCheckedContinuation { continuation in
            let _ = Just("good day")
                .handleEvents(
                    receiveRequest: { _ in
                        logger.append(Thread.isMainThread ?
                            "receiveRequest on main thread" :
                            "receiveRequest on background thread")
                    }
                )
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .handleEvents(
                    receiveOutput: { _ in
                        logger.append(Thread.isMainThread ?
                            "receiveOutput on main thread" :
                            "receiveOutput on background thread")
                    }
                )
                .sink {
                    logger.append($0)
                    continuation.resume()
                }
        }

        #expect(
            logger.log() == [
                "receiveRequest on background thread",
                "receiveOutput on main thread",
                "good day"
            ]
        )
    }

}
