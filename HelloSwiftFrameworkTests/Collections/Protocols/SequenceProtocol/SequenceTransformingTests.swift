//
//  SequenceTransformingTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SequenceTransformingTests {

    @Test func testMap() throws {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]

        let lowercaseNames = cast.map { $0.lowercased() }
        #expect(lowercaseNames == ["vivien", "marlon", "kim", "karl"])

        let letterCounts = cast.map { $0.count }
        #expect(letterCounts == [6, 6, 3, 4])
    }

    @Test func testCompactMap() throws {
        let possibleNumbers = ["1", "2", "three", "///4///", "5"]

        let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
        #expect(mapped == [1, 2, nil, nil, 5])

        let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
        #expect(compactMapped == [1, 2, 5])
    }

    @Test func testFlatMap() throws {
        let numbers = [1, 2, 3, 4]

        let mapped = numbers.map { Array(repeating: $0, count: $0) }
        #expect(mapped == [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]])

        let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
        #expect(flatMapped == [1, 2, 2, 3, 3, 3, 4, 4, 4, 4])
    }

    @Test func testReduce() throws {
        let numbers = [1, 2, 3, 4]
        let sum = numbers.reduce(0, { sum, n in sum + n })
        #expect(sum == 10)
    }

    @Test func testReduceInto() throws {
        let letters = "abracadabra"
        let letterCount = letters.reduce(into: [:]) { counts, letter in
            counts[letter, default: 0] += 1
        }
        #expect(letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1])
    }

    @Test func testLazy() throws {
        // 일반 Sequence 의 filter, map 등은 어레이를 리턴한다.
        // LazySequence 의 map 은 LazyMapSequence 를 리턴한다.
        // LazySequence 는 다음 아이템 요청이 들어올 때마다 Base Sequence 를 참조해 연산을 한다.

        let largeArray = Array(1...10)

        let lazy = largeArray.lazy
        let lazyfiltered = lazy.filter { $0 % 2 == 0 }  // 2, 4, 6, 8, 10
        let lazyFilteredMapped = lazyfiltered.map { $0 * $0 }  // 4, 16, 36, 64, 100

        var result: [Int] = []

        for value in lazyFilteredMapped {
            result.append(value)
        }

        #expect(result == [4, 16, 36, 64, 100])
    }

    @Test mutating func testLazyStepByStep() throws {

        struct Base: Sequence {
            let limit: Int

            func makeIterator() -> BaseIterator {
                BaseIterator(limit: limit)
            }
        }

        struct BaseIterator: IteratorProtocol {
            let limit: Int
            var current = 0

            mutating func next() -> Int? {
                guard current < limit else { return nil }
                SimpleLog.log("base \(current)", tag: "LazySequenceTest")
                defer { current += 1 }
                return current
            }
        }

        let seq = Base(limit: 10).lazy
            .filter {
                SimpleLog.log("filtering \($0)", tag: "LazySequenceTest")
                return $0 % 2 == 0
            }
            .map {
                SimpleLog.log("mapping \($0)", tag: "LazySequenceTest")
                return $0 * $0
            }

        for value in seq {
            SimpleLog.log("consuming \(value)", tag: "LazySequenceTest")
        }

        let log = SimpleLog.log(withTag: "LazySequenceTest")

        #expect(log == [
            "base 0", "filtering 0", "mapping 0", "consuming 0",
            "base 1", "filtering 1",
            "base 2", "filtering 2", "mapping 2", "consuming 4",
            "base 3", "filtering 3",
            "base 4", "filtering 4", "mapping 4", "consuming 16",
            "base 5", "filtering 5",
            "base 6", "filtering 6", "mapping 6", "consuming 36",
            "base 7", "filtering 7",
            "base 8", "filtering 8", "mapping 8", "consuming 64",
            "base 9", "filtering 9"
        ])
    }
}
