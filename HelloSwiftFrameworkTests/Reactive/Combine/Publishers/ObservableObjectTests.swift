//
//  ObservableObjectTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/9/24.
//

import Foundation
import Combine
import Testing

// https://developer.apple.com/documentation/combine/observableobject

struct ObservableObjectTests {

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

        weather.temperature = 20
        weather.temperature = 30
        weather.temperature = 40

        #expect(logger.log() == [10, 20, 30, 40])
    }

    @Test func testObjectWillChange() throws {
        let logger = SimpleLogger<Int>()

        // An ObservableObject synthesizes an objectWillChange publisher
        // that emits the changed value before any of its @Published properties changes.

        class Contact: ObservableObject {
            @Published var name: String
            @Published var age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }

        let john = Contact(name: "John Appleseed", age: 24)
        var cancellables = Set<AnyCancellable>()

        john.objectWillChange
            .sink { _ in
                logger.append(99)
            }
            .store(in: &cancellables)

        john.$age
            .sink {
                logger.append($0)
            }
            .store(in: &cancellables)

        #expect(logger.log() == [24])

        john.age += 1

        #expect(logger.log() == [24, 99, 25])

        john.age += 1

        #expect(logger.log() == [24, 99, 25, 99, 26])
    }


}
