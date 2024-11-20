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
    // 노출되지 않은 프로퍼티가 업데이트되면 호출되지 않음을 확인,

    @Test func testObservable() async throws {
        await confirmation { confirm in
            let pet = Pet(name: "max", age: 7)

            withObservationTracking {
                _ = pet.name
            } onChange: {
                confirm()
            }

            pet.name = "max juior"
        }

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

    // Observable 이 어레이 엘리먼트일 때, 다른 인자들과 상관없이 정상 작동함을 확인.

    @Test func testArrayOfObservables() async throws {
        await confirmation { confirm in
            let pets = [
                Pet(name: "max", age: 7),
                Pet(name: "ace", age: 9),
            ]

            withObservationTracking {
                let pet = pets[0]
                _ = pet.name
            } onChange: {
                confirm()
            }

            let pet = pets[0]
            pet.name = "max juior"
        }

        await confirmation(expectedCount: 0) { confirm in
            let pets = [
                Pet(name: "max", age: 7),
                Pet(name: "ace", age: 9),
            ]

            withObservationTracking {
                let pet = pets[0] // max
                _ = pet.name
            } onChange: {
                confirm()
            }

            let pet = pets[1] // ace
            pet.name = "ace juior"
        }
    }

}
