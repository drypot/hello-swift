//
//  TaskTests.swift
//  Tests
//
//  Created by Kyuhyun Park on 6/5/24.
//

import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Tasks-and-Task-Groups
// https://developer.apple.com/documentation/swift/task

// A task is a unit of work that can be run asynchronously as part of your program.
// All asynchronous code runs as part of some task.
// A task itself does only one thing at a time,
// but when you create multiple tasks, Swift can schedule them to run simultaneously.

struct TaskTests {

    // TaskGroup 을 사용해서 명시적으로 Task 트리 짜는 것을 structured concurrency 라고 부른다.
    // 아래 처럼 TaskGroup 없이 단독 Task 생성해 쓰는 것을 unstructured task 라고 부른다.

    // Task 는 caller 의 actor context 를 계승한다.

    @Test func testAwaitTaskValue() async throws {
        let task = Task {
            return "done"
        }

        let value = await task.value

        #expect(value == "done")
    }

    // actor context 를 계승하지 않으려면 detached task 를 만든다.

    @Test func testAwaitDetachedTaskValue() async throws {
        let task = Task.detached {
            return "done"
        }

        let value = await task.value

        #expect(value == "done")
    }

    @Test func testAwaitTaskResult() async throws {
        let task = Task {
            return "done"
        }

        let result = await task.result

        #expect(result == .success("done"))
    }

    @Test func testIsCancelled() async throws {
        let task = Task {
            return if Task.isCancelled {
                "cancelled"
            } else {
                "done"
            }
        }

        task.cancel()
        let value = await task.value

        #expect(value == "cancelled")
    }

    @Test func testTryCheckCancellationWithValue() async throws {
        let task = Task<String, Error> {
            try Task.checkCancellation()
            return "done"
        }

        do {
            task.cancel()
            let _ = try await task.value
            fatalError()
        } catch {
            #expect(error is CancellationError)
        }
    }

    @Test func testTryCheckCancellationWithResult() async throws {
        let task = Task<String, Error> {
            try Task.checkCancellation()
            return "done"
        }

        task.cancel()
        let result = await task.result

        switch result {
        case .success:
            fatalError()
        case .failure(let error):
            #expect(error is CancellationError)
        }
    }

    @Test func testTaskYield() async throws {
        let task = Task {
            for _ in 0..<2 {
                await Task.yield()   // 의도적으로 suspension point 를 만들 수 있다.
            }
            return "done"
        }

        let value = await task.value

        #expect(value == "done")
    }

    @Test func testTaskSleep() async throws {
        try await Task.sleep(for: .milliseconds(10))
    }
    
}
