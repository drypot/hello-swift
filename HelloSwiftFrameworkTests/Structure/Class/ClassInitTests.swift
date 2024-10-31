//
//  ClassInitTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 10/14/24.
//

import Foundation
import Testing

struct ClassInitTest {

    @Test func testDefaultInitializer() {

        class Vehicle {
            var speed: Int = 0
        }

        let car = Vehicle()

        #expect(car.speed == 0)
    }

    @Test func testCustomInitializer() {

        class Car {
            var speed: Int
            var brand: String

            init(speed: Int, brand: String) {
                self.speed = speed
                self.brand = brand
            }
        }

        let car = Car(speed: 100, brand: "Tesla")

        #expect(car.speed == 100)
    }

    @Test func testFailableInitializer() {

        class Car {
            var speed: Int
            var brand: String

            init?(speed: Int, brand: String) {
                guard speed > 0 else { return nil }
                self.speed = speed
                self.brand = brand
            }
        }

        let car = Car(speed: 100, brand: "Tesla")

        #expect(car?.speed == 100)

        let invalidCar = Car(speed: -10, brand: "Tesla")

        #expect(invalidCar == nil)
    }

    @Test func testConvenienceInitializer() {

        class Car {
            var speed: Int
            var brand: String

            // Designated initializer
            init(speed: Int, brand: String) {
                self.speed = speed
                self.brand = brand
            }

            // Convenience initializer
            convenience init() {
                self.init(speed: 100, brand: "Unknown")
            }
        }

        let car = Car()

        #expect(car.speed == 100)
        #expect(car.brand == "Unknown")
    }

    @Test func testInitializerInInheritance() {

        class Vehicle {
            var speed: Int

            init(speed: Int) {
                self.speed = speed
            }
        }

        class Car: Vehicle {
            var brand: String

            // Designated initializer
            init(speed: Int, brand: String) {
                self.brand = brand
                super.init(speed: speed) // call super init
            }
        }

        let car = Car(speed: 120, brand: "Toyota")

        #expect(car.speed == 120)
        #expect(car.brand == "Toyota")
    }

    @Test func testRequiredInitializer() {

        class Animal {
            var species: String

            // Required initializer
            required init(species: String) {
                self.species = species
            }
        }

        // subclass must implement required initializer.

        class Dog: Animal {
            required init(species: String) {
                super.init(species: species)
            }
        }

        let dog = Dog(species: "Canis familiaris")

        #expect(dog.species == "Canis familiaris")
    }

    @Test func testDeinitializer() {

        class Handler {

            static var checker = "uninited"

            init() {
                Self.checker = "inited"
            }

            deinit {
                Self.checker = "deinited"
            }
        }

        #expect(Handler.checker == "uninited")

        var handler: Handler? = Handler()
        _ = handler // remove unused variable warning

        #expect(Handler.checker == "inited")

        handler = nil

        #expect(Handler.checker == "deinited")
    }
}
