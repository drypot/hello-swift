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

// Swift 6으로 앱을 마이그레이션하기
// https://developer.apple.com/videos/play/wwdc2024/10169

// Swift 의 global var initializer 는 lazy 하고 atomic 하다.
// thread safe 하기 때문에 두 스레드가 동시에 초기화 하려고 하면 다른 스레드는 잠시 블럭된다.

// Swift 6 동시성 에러를 해결하려면
// 해당 변수를 Sendable 하게 만들던지
// Actor 를 명시적으로 적어주던지
// @preconcurrency 로 이미 Actor 로 격리되고 있음을 선언하던지,
// nonisolated(unsafe) 적어서 검사를 무시하던지,
// 정말 원하는 액터에서 실행되고 있는지는 MainActor.assumeIsolated { ... } 로 확인할 수 있다.

// Protect mutable state with Swift actors
// https://developer.apple.com/videos/play/wwdc2021/10133

// Actor 에서 밸류 타입을 외부로 내보내는 것은 Actor 내부에 영향이 없으나,
// Class 오브젝트를 Actor 안의 어레이에 보관하다가 밖으로 내보내면
// 외부에서 오브젝트를 수정하면서 Data race 가 발생한다.

// Sendable: 두 액터에서 공유할 수 있는 값의 타입.
// Value types
// Actor types
// Immutable classes
// Internally-synchronized class
// @Sendable function types

// Explore structured concurrency in Swift
// https://developer.apple.com/videos/play/wwdc2021/10134

// A task provides a fresh execution context to run asynchronous code.
// Each task runs concurrently.
// They will be automatically scheduled to run in parallel when it is safe and efficient to do so.

// async let 은 child task 를 만들고 실행시킨다.
// child task 중 어느 한 task 가 exception 을 던지면서 중지하면
// 다른 child 들은 모두 cancelled 상태가 된다.
// cancelled 된다고 강제 종료되지 않기 때문에 cancelled 상태를 주기적으로 확인해야 한다.

// Task Group, dynamic amount concurrency 가 필요할 때 쓴다.
// group 에 추가하는 child task 는 바로 실행을 시작한다.
// Task group child 클로져에서 외부 변수를 수정하는 건 왠만하면 바람직하지 않다.
// 가능하면 결과를 리턴하고 밖에서 결과를 취합하는 것이 무난하다.
// Task group child 는 task context 를 계승하지만 actor 를 계승하진 않는다.

// Task 는 non-async 환경에서 async 환경을 만들 때 사용한다.
// async let 이나 Task Group 과 달리 제한 Scope 가 없다.
// Task 는 Task 를 생성한 액터에서 실행되도록 스케쥴링 된다.
// Task task context 와 actor 를 계승한다.
// Calcellation 이 자동 전파되지 않는다.
// 필요없는 Task 를 중지시키려면 Dictionary 를 만들어 관리하는 것이 좋다.
// MainActor 에서 생성한 Task 의 경우 MainActor isolation 이 보장되므로
// Task 안에서 외부의 Dictionary 를 수정할 수 있다.

// Detatched Task 는 Actor context 를 계승하지 않는다.

// Swift concurrency: Behind the scenes
// https://developer.apple.com/videos/play/wwdc2021/10254

// UI + Database + Networking 앱을 GCD 로 만든다고 했을 때,
// UI 는 main thread 에서 실행되고,
// Database 작업을 전담하는 Serial Queue 로 요청 목록을 보낸다,
// Serial Queue 를 쓰는 목적은 1. main thread 의 부하를 피하고,
// 2. Database 로의 접근을 동기화하기 위함,
// Database Serial Queue 에서는 Network Concurrent Queue 에 필요한 Request 를 보낸다.
// Network Queue 는 동기화가 필요없기 때문에 Concurrent 가 적합하다.
// Network Queue 가 결과를 받으면 Database Serial Queue 를 통해 DB 를 업데이트 한다.
// 마지막 단계로 main thread 를 통해서 UI 를 업데이트한다.
// 여기서 문제는 Network Request 결과가 쏟아져 들어오면
// 그 결과를 처리하는 Database Serial Queue 가 병목현상을 일으켜
// Network Concurrent Queue 에 블럭이 폭발하고
// 이를 실행하기 위한 스레드들이 늘어나 비효율을 유발한다는 것이다.

// Swift Concurrency 에서는 아래와 같이 바뀐다.
// CPU Core 만큼의 Thread 만 만들어 진다.
// Thread context switching 이 없다.
// 기존 Thread 들 대신 좀더 가벼운 Continuation 들이 만들어 진다.
// Thread switching 대신 Continuation swiching 이 이루어 진다.

// Swift Concurrency 가 가능하려면 Thread 가 블럭되면 안 된다.
// 필요할 때마다 await 써주면 무난하게 해결된다.
// Concurrent Queue 가 하던 일은 TaskGroup 으로 대체한다.

// async/await 이 작동하는 방식에 대해서,
// async 펑션이 호출되면 일단 Thread 스택 프레임이 만들어 진다.
// 스택 프레임은 (await) suspention point 에 영향을 받지 않는 local var 용으로 사용된다.
// 스택 프레임과 별도로 async 프레임이 힙에 만들어 진다.
// async 프레임은 suspention point 를 건너다니며 사용되는 변수에 사용된다.
// async 펑션에서 다른 async 펑션을 호출하면 현재 스택 프레임이 새로운 펑션의 스택 프레임으로 대체된다.
// await 이전과 이후에 계속 써야할 변수들은 힙에 있기 때문에 스택 프레임은 대체해도 된다.
// async 콜을 계속 해 가다가 최종적으로 정말 IO 가 발생해서 당장 더 할 일이 없어지게 되면
// 최종 힙의 async 프레임에 Continuation 을 박고 스레드는 다른 작업에 할당한다.
// IO 에서 결과가 리턴되고 아무 스레드가 사용 가능하게 되면
// 스택에 resume 할 펑션의 스택 프레임을 만들고
// 아까 박아 두었던 Continuation 을 통해 힙의 async 프레임을 연결해서 작업을 재개한다.
// 요컨데 async/await 을 통해서 thread 를 블럭하지 않고 concurrent 하게 작업을 실행할 수 있다.

// GCD 환경에서는 서브 시스템마다 적당한 사이즈의 Serial Queue 를 두고 쓰는 방식이 권장되었다.
// Swift Concurrency 에서는 기본 런타임이 최적의 상태를 유지하기 때문에 신경써야 할 일들이 많이 사라졌다.

// Cooperative thread pool is the default executor for Swift.
// Threads will always be able to make forward progress. Swfit Concurrency 의 기본 요구사항.

// Swift Concurrency 가 유지되게 하려면 가능한 await, actor, TaskGroup 같은 primitive 들을 사용한다.
// 필요하다면 sync 코드에서 os_unfair_lock, NSLock 을 잠깐씩 쓸 수 있다.
// 왜냐면 이놈들을 sync 코드에서 잠시 쓰는 건 thread 를 블럭하지 않기 때문이다.
// Semaphore 는 가능하면 쓰지 않는다.
// Task 바운더리를 넘어서 semaphore 를 쓰다간 디펜던시에 문제를 야기할 수 있다.
// semaphore.wait() 같은 것은 thread 는 블럭되지 않고 계속 실행되어야 한다는 요구사항을 만족하지 않는다.

// 코드에서 semaphore 같은 위험한 것을 쓰고 있는지 확인하려면 아래 옵션으로 Thread 를 1로 하고 앱을 테스트해 본다.
// LIBDISPATCH_COOPERATIVE_POOL_STRICT=1

// Mutual exclusion 에 대해서,

// DispatchQueue.sync,
// 큐가 사용중이 아니라면 현재 스레드가 Work Item 을 바로 실행한다.
// 큐가 사용중이면 실행 스레드가 블럭되면서 스레드 폭발이 발생 수 있는 환경이 된다.

// DispatchQueue.async,
// 현재 스레드가 블럭되지 않지만,
// 리퀘스트 실행될 때마다 새로운 스레드가 만들어 진다,
// 스레드 스위칭이 많이 발생할 수 있다,

// Actor,
// protect mutable state from concurrent access,
// mutual exclusion,
// 액터가 사용중이 아니라면 현재 스레드로 바로 실행한다,
// 액터가 이미 사용중이라면 실행하던 펑션 멈추고 다른 작업을 하러 간다, 스레드가 블럭되지 않는다,

// Actor hopping, 액터에서 다른 액터를 콜하는 상황,
// Actor 실행은 Work Item 이 한다,
// Actor A 에서 Actor B 를 콜하는 겨우,
// Actor B 가 사용중이 아니라면 B 실행을 위한 Work Item 을 만들어 A 를 실행하던 스레드가 B 를 이어서 실행한다,
// 스레드가 중지하는 일도 없고, 스레드가 스위칭되는 일도 없다,
// Actor C 가 Actor B 를 콜했는데 B가 사용중이라면, 즉 Work Item B1 이 아직 실행중이라면,
// Work Item B2 가 만들어진 후 대기 상태가 된다,
// Actor C 는 Suspend 되고, Actor C 를 실행하던 스레드는 다른 작업을 하러 간다.
// B1 이 끝나면 B2 가 실행될 수도 있고 다른 Suspend 된 것들이 실행될 수도 있고, 그런 스케튤러가 알아서,

// Actor Reentrancy
// Actor B 가 Work Item B1 으로 실행중, await 콜로 suspend 되면
// 다른 액터에서 Work Item B2 를 만들어 B 를 실행할 수 있다,
// 즉 액터 메서드가 다 실행되기 전에 Suspend 되고 다른 Work Item 으로 실행이 시작될 수 있다.
// 그러니 Suspend 위치 전후에 액터의 상태가 다를 수 있음을 주의해야 한다.
// 이후 생성된 Work Item B2 가 B1 보다 먼저 완료될 수도 있다.

// Main Actor 는 시스템 Main thread 를 추상화하기 때문에 조금 특별하다.
// Main thread 는 Cooperative thread pool 과 다르기 때문에
// 서로간 이동시 Thread context switching 이 발생한다.
// 예로 MainActor 에서 Database Actor 를 호출하면 Thread 스위칭이 발생한다.
// Context swiching 이 많이 발생할 로직이라면 batch 작업으로 만들어서 스위칭을 가능한 줄이는 것이 좋다.
