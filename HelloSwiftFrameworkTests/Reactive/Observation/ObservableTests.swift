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

    // 노출된 프로퍼티가 업데이트되면 onChange 가 호출되지만,

    @Test func testOnChangeShouldBeCalled() async throws {
        let logger = SimpleLogger<Int>()
        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
        } onChange: {
            logger.append(1)
        }

        logger.append(2)
        pet.name = "max juior"

        #expect(logger.log() == [2, 1])
    }

    // 노출되지 않은 프로퍼티가 업데이트되면 호출되지 않음을 확인,

    @Test func testOnChangeShouldNotBeCalled() async throws {
        let logger = SimpleLogger<Int>()
        let pet = Pet(name: "max", age: 7)

        withObservationTracking {
            _ = pet.name
        } onChange: {
            logger.append(1)
        }

        logger.append(2)
        pet.age = 2

        #expect(logger.log() == [2])
    }

    // Observable 이 어레이 엘리먼트일 때, 다른 인자들과 상관없이 정상 작동함을 확인.

    @Test func testOnChangeShouldBeCalledForArrayElement() async throws {
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

        logger.append(2)
        pets[0].name = "max juior"

        #expect(logger.log() == [2, 1])
    }

    @Test func testOnChangeShouldNotBeCalledForArrayElement() async throws {
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

        logger.append(2)
        pets[1].name = "ace juior"

        #expect(logger.log() == [2])
    }

}
