//
//  SequenceTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/4/24.
//

import Foundation
import Testing

// protocol Sequence<Element>
//
// A type that provides sequential, iterated access to its elements.

// https://github.com/swiftlang/swift/blob/main/stdlib/public/core/Sequence.swift

struct SequenceTests {

    struct Counter: Sequence {
        let limit: Int

        func makeIterator() -> Iterator {
            return Iterator(limit: limit)
        }

        struct Iterator: IteratorProtocol {
            let limit: Int
            var current = 0

            mutating func next() -> Int? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }
    }

    // Sequence, IteratorProtocol 를 동일 struct 에 구현할 수도 있다.
    //
    // makeIterator() 는 default 구현에서 온다.
    // 그냥 self 를 리턴하는데 struct 라 복제본이 넘어오는 개념일 듯.

    struct CounterCompact: Sequence, IteratorProtocol {
        let limit: Int
        var current = 0

        mutating func next() -> Int? {
            guard current < limit else { return nil }
            defer { current += 1 }
            return current
        }
    }

    @Test func testCounterIterator() throws {
        let counter = Counter(limit: 3)
        var iterator = counter.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }

    @Test func testCounterFor() throws {
        let counter = Counter(limit: 3)
        var result = [Int]()

        for count in counter {
            result.append(count)
        }

        #expect(result == [0, 1, 2])
    }

    @Test func testCounterCompactIterator() throws {
        let counter = CounterCompact(limit: 3)

        var iterator = counter.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }

    @Test func testtestCounterCompactFor() throws {
        let counter = CounterCompact(limit: 3)
        var result = [Int]()

        for count in counter {
            result.append(count)
        }

        #expect(result == [0, 1, 2])
    }
}
