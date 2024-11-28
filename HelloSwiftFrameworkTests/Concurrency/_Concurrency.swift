//
//  _Concurrency.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/16/24.
//

import Foundation

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency
// https://developer.apple.com/documentation/swift/concurrency
// https://www.hackingwithswift.com/quick-start/concurrency

// An asynchronous function can be suspended while it’s partway through execution.
// Inside the body of an asynchronous function,
// you mark each of these places where execution can be suspended.

// When adding concurrent code to an existing project, work from the top down.
// Specifically, start by converting the top-most layer of code to use concurrency,
// and then start converting the functions and methods that it calls,
// working through the project’s architecture one layer at a time.
// There’s no way to take a bottom-up approach,
// because synchronous code can’t ever call asynchronous code.

// AsyncStream
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0300-continuation.md
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0314-async-stream.md

// Actor
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0304-structured-concurrency.md
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0338-clarify-execution-non-actor-async.md
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0401-remove-property-wrapper-isolation.md
// https://oleb.net/2022/swiftui-task-mainactor/

// Synchronous Programming:
// 시간이 많이 걸리는 작업이 시작됐을 때 메인 플로우가 그 자리에서 Block 된다.

// Asynchronous Programming:
// 시간이 많이 걸리는 작업은 메인 플로우와 다른, 독립된 플로우에 실행을 맞긴다.
// 메인 플로우는 자기 할 일을 계속 한다.
// non-blocking 하다.
// callbacks, futures, or async/await 등 결과를 받을 수 있는 장치들이 필요하다.

// Parallel:
// 멀티 코어 프로세서에서 태스크들이 동시에 실행되는 것을 말한다.
// Parallelism 을 구현하려면 일단 하드웨어가 뒷받침 되어야 한다.

// Concurrency:
// 각 태스크가 독립적으로 progress 하게 구조화될 수 있으면 concurrent 하다고 말한다.
// Parallel 하게 실행되는지와는 상관이 없다.
// 시스템을 효율적으로 Asynchronous, Parallel 하게 구조화 하는 것이 주요 관심사.

// JavaScript 도 concurrent 하다고 말한다.
// JavaScript 처럼 Single Thread 환경이라도 Asynchronous 할 수 있다.
// IO 에 블럭 걸리면 다른 작업 하러 가면 되니까.

// Asynchronous task 는 추후 main thread 에서 실행될 수도 있고 별도 스레드에서 실행될 수도 있다.
// Asynchronous 개념은 threading 과는 상관없다.

// Swift 는 multi thread 환경이다.

// Concurrency is the design (managing tasks efficiently),
// Parallelism is an implementation detail (tasks running simultaneously),
// Asynchronous programming is a tool to achieve concurrency by allowing non-blocking task execution.
