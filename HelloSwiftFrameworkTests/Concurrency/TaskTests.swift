//
//  TaskTests.swift
//  Tests
//
//  Created by Kyuhyun Park on 6/5/24.
//

import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Tasks-and-Task-Groups

// A task is a unit of work that can be run asynchronously as part of your program.
// All asynchronous code runs as part of some task.
// A task itself does only one thing at a time,
// but when you create multiple tasks, Swift can schedule them to run simultaneously.

// The async-let syntax implicitly creates a child task

// Tasks are arranged in a hierarchy. ... this approach is called structured concurrency.

struct TaskTests {

    static func echoAsync(_ message: String) async -> String {
        return message
    }

    @Test func testParallelWithAsyncLet() async throws {
        async let first = TaskTests.echoAsync("abc")
        async let second = TaskTests.echoAsync("123")
        async let third = TaskTests.echoAsync("xyz")

        let echoes = await [first, second, third]

        #expect(echoes == ["abc", "123", "xyz"])
    }

    @Test func testParallelWithTaskGroup() async throws {
        let echoes = await withTaskGroup(of: String.self) { group in
            for message in ["abc", "123", "xyz"] {
                group.addTask { await TaskTests.echoAsync(message) }
            }

            var echoes = [String]()

            for await echo in group {
                echoes.append(echo)
            }

            return echoes
        }

        #expect(Set(echoes) == Set(["abc", "123", "xyz"]))
    }

    @Test func testCheckCancellation() async throws {
        let echoes = await withTaskGroup(of: String?.self) { group in
            for message in ["abc", "123", "xyz"] {
                let added = group.addTaskUnlessCancelled {
                    guard !Task.isCancelled else { return nil }
                    return await TaskTests.echoAsync(message)
                }
                guard added else { break }
            }

            var echoes = [String]()
            for await echo in group {
                if let echo {
                    echoes.append(echo)
                }
            }
            return echoes
        }

        #expect(Set(echoes) == Set(["abc", "123", "xyz"]))
    }

    @Test func testCancelationHandler() async throws {
        let echo = await withTaskCancellationHandler(
            operation: {
                await TaskTests.echoAsync("abc")
            },
            onCancel: {
                //
            }
        )

        #expect(echo == "abc")
    }

    // unstructured task:  task that doesn’t have a parent task.

    @Test func testTask() async throws {
        let task1 = Task {
            await TaskTests.echoAsync("abc")
        }

        let echo = await task1.value
        #expect(echo == "abc")
    }

    // a detached task: unstructured task that’s not part of the current actor.

    @Test func testDetachedTask() async throws {
        let task1 = Task.detached {
            await TaskTests.echoAsync("abc")
        }

        let echo = await task1.value
        #expect(echo == "abc")
    }

}
