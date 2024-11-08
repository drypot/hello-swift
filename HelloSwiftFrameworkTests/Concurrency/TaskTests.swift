//
//  TaskTests.swift
//  Tests
//
//  Created by Kyuhyun Park on 6/5/24.
//

import Testing

@MainActor
class TaskTests {

    var log = [String]()

    func doAsyncWork() async {
        log.append("Doing async work")
    }

    func doRegularWork() {
        log.append("A")
        Task {
            log.append("B")
            await doAsyncWork()
            log.append("C")

            #expect(log == ["A", "D", "B", "Doing async work", "C"])
        }
        log.append("D")
    }

    @Test func test() throws {
        doRegularWork()
    }

}
