//
//  ObservableTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing

struct ObservableTests {

    @Observable class Pet {
        var name: String
        var age: Int

        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }

    @Test func testWhenExposedPropertyChanged() async throws {
        let logger = SimpleLogger<Int>()
        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
        } onChange: {
            logger.append(1)
        }

        // 노출된 프로퍼티가 업데이트되면 onChange 가 호출된다.
        pet.name = "max juior"

        #expect(logger.log() == [1])
    }

    @Test func testWhenNotExposedPropertyChanged() async throws {
        let logger = SimpleLogger<Int>()
        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
        } onChange: {
            logger.append(1)
        }

        // 노출되지 않은 프로퍼티가 업데이트되면 호출되지 않는다.
        pet.age = 2

        #expect(logger.log() == [])
    }

    @Test func testWhenExposedElementChanged() async throws {
        let logger = SimpleLogger<Int>()

        let pets = [
            Pet(name: "max", age: 7),
            Pet(name: "ace", age: 9),
        ]

        withObservationTracking {
            _ = pets[0].name
        } onChange: {
            logger.append(1)
        }

        // 엘리먼트가 Observable 일 때, 다른 인자들과 상관없이 정상 작동함을 확인.
        pets[0].name = "max juior"

        #expect(logger.log() == [1])
    }

    @Test func testWhenNotExposedElementChanged() async throws {
        let logger = SimpleLogger<Int>()

        let pets = [
            Pet(name: "max", age: 7),
            Pet(name: "ace", age: 9),
        ]

        withObservationTracking {
            _ = pets[0].name
        } onChange: {
            logger.append(1)
        }

        // 노출되지 않은 엘리먼트가 업데이트 되면, 호출되지 않는다.
        pets[1].name = "ace juior"

        #expect(logger.log() == [])
    }

}
