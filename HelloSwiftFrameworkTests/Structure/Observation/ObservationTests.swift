//
//  ObservationTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing

struct ObservationTests {

    @Observable class Pet {
        var name: String
        var age: Int

        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }

    @Test func testOnChangeShouldBeCalled() async throws {
        await confirmation(expectedCount: 1) { confirm in
            let pet = Pet(name: "max", age: 7)

            withObservationTracking {
                _ = pet.name
            } onChange: {
                confirm()
            }

            pet.name = "max juior"
        }
    }

    @Test func testOnChangeShouldNotBeCalled() async throws {
        await confirmation(expectedCount: 0) { confirm in
            let pet = Pet(name: "max", age: 7)

            withObservationTracking {
                _ = pet.name
            } onChange: {
                confirm()
            }

            pet.age = 2
        }
    }

}
