//
//  SequenceMakingTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/4/24.
//

import Foundation
import Testing

struct SequenceMakingTests {

    @Test func testIterator() throws {
        let range = 0...2
        var iterator = range.makeIterator()

        #expect(iterator.next() == 0)
        #expect(iterator.next() == 1)
        #expect(iterator.next() == 2)
        #expect(iterator.next() == nil)
    }

    @Test func testMakingSequence() throws {

        struct Counter: Sequence {
            let limit: Int

            init(limit: Int) {
                self.limit = limit
            }

            func makeIterator() -> CounterIterator {
                CounterIterator(self)
            }
        }

        struct CounterIterator: IteratorProtocol {
            let limit: Int
            var current = 0

            init(_ counter: Counter) {
                limit = counter.limit
            }

            mutating func next() -> Int? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }

        var joined = ""

        for count in Counter(limit: 3) {
            joined += String(count)
        }

        #expect(joined == "012")
    }

    @Test func testMakingCompactSequence() throws {

        // Sequence, IteratorProtocol 두 프로토콜을 하나의 struct 에서 구현할 수도 있다.
        // 그런데 별로 좋진 않아 보인다. 나중에 보면 헷갈릴 듯.

        struct Counter: Sequence, IteratorProtocol {
            let limit: Int
            var current = 0

            init(limit: Int) {
                self.limit = limit
            }

            init(_ counter: Counter) {
                limit = counter.limit
            }

            // makeIterator() 는 default 구현에서 온다.

            mutating func next() -> Int? {
                guard current < limit else { return nil }
                defer { current += 1 }
                return current
            }
        }

        var joined = ""

        for count in Counter(limit: 3) {
            joined += String(count)
        }

        #expect(joined == "012")
    }
}
