//
//  ActorTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/11/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Actors
// tasks to break up your program into isolated, concurrent pieces.
// but sometimes you need to share some information between tasks.

// actors are reference types.
// only one task to access actor's mutable state at a time.

struct ActorTests {

    actor TemperatureLogger {
        let label: String
        var measurements: [Int]
        private(set) var max: Int

        init(label: String, measurement: Int) {
            self.label = label
            self.measurements = [measurement]
            self.max = measurement
        }

        func update(with measurement: Int) {
            // Actor 내부에서 내부로 접근할 때는 await 이 필요없다.
            measurements.append(measurement)
            if measurement > max {
                max = measurement
            }
        }
    }

    @Test func testActor() async throws {
        let logger = TemperatureLogger(label: "Outdoors", measurement: 25)

        // Actor 외부에서 Actor 내부로 접근하려면 await 이 필요하다.
        let max = await logger.max

        #expect(max == 25)
    }

}
