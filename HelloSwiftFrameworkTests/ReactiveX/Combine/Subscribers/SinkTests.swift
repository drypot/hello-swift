//
//  SinkTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwiftFramework
import Testing

// https://developer.apple.com/documentation/combine

struct SinkTests {

    @Test func testSink() throws {
        let logger = SimpleLogger<Int>()

        // sink, assign(to:on:) 은 AnyCancellable(subscriber) 을 리턴한다.
        // 체인을 사용하는 중에는 이 값을 저장해 둬야 한다.
        // 저장 안 해서 그냥 날아가면 cancel 이 호출되면서 체인이 종료된다.
        
        let _ = [1, 2, 3, 4, 5].publisher
            .sink { completion in
                logger.log(90)
            } receiveValue: { value in
                logger.log(value)
            }

        logger.log(99)

        #expect(logger.result() == [1, 2, 3, 4, 5, 90, 99])
    }

}
