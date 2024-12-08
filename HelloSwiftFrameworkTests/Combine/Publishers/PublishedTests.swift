//
//  PublishedTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import Testing

struct PublishedTests {

    @Test func testPublished() throws {
        let logger = SimpleLogger<Int>()

        class Weather {
            @Published var temperature: Int
            init(temperature: Int) {
                self.temperature = temperature
            }
        }

        let weather = Weather(temperature: 10)
        var cancellables = Set<AnyCancellable>()

        weather.$temperature
            .sink {
                logger.append($0)
            }
            .store(in: &cancellables)

        // Subscriber 를 어디에 저정하지 않으면 걍 날아가 버려서
        // 아래 이벤트를 처리하지 못한다.

        weather.temperature = 20
        weather.temperature = 30
        weather.temperature = 40

        #expect(logger.log() == [10, 20, 30, 40])
    }

}
