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
            let end: Int

            init(end: Int) {
                self.end = end
            }

            func makeIterator() -> Iterator {
                Iterator(self)
            }

            struct Iterator: IteratorProtocol {
                let end: Int
                var nextValue = 0

                init(_ counter: Counter) {
                    end = counter.end
                }

                mutating func next() -> Int? {
                    let returnValue = nextValue
                    guard returnValue < end else { return nil }

                    nextValue += 1

                    return returnValue
                }
            }
        }

        var joined = ""

        for count in Counter(end: 3) {
            joined += String(count)
        }

        #expect(joined == "012")
    }
}
