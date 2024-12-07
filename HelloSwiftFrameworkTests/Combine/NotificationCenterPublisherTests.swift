//
//  Counter.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/8/24.
//

import Foundation
import Combine
import Testing

struct NotificationCenterPublisherTests {

    @Test func testNotificationCenterPublisher() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        let customNotification = Notification.Name("CustomNotification")

        NotificationCenter.default.publisher(for: customNotification)
        .sink {
            logger.append($0.userInfo?["mark"] as? Int ?? -99)
        }
        .store(in: &cancellables)

        NotificationCenter.default.post(name: customNotification, object: nil, userInfo: ["mark" : 99])

        #expect(logger.log() == [99])
    }

}
