//
//  TypeErasingWrapperTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/7/24.
//

import Foundation
import Testing

struct TypeErasingWrapperTests {

    // Self 나 associated type 이 없는 경우

    @Test func testProtocolWithoutConstrant() throws {

        protocol Shape {
            func area() -> Double
        }

        struct Circle: Shape {
            var radius: Double
            func area() -> Double {
                return .pi * radius * radius
            }
        }

        struct Rectangle: Shape {
            var width: Double
            var height: Double
            func area() -> Double {
                return width * height
            }
        }

        var shape: Shape

        shape = Circle(radius: 5)
        #expect(abs(shape.area() - 78.53981) < 1e-5)

        shape = Rectangle(width: 2, height: 2)
        #expect(shape.area() == 4.0)

        var _ : [any Equatable]
    }



//    // type-erasing wrapper
//    struct AnyShape: Shape {
//        private let _area: () -> Double
//
//        init<S: Shape>(_ shape: S) {
//            _area = shape.area
//        }
//
//        func area() -> Double {
//            return _area()
//        }
//    }


}
