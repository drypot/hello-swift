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
