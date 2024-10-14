//
//  TaskTests.swift
//  Tests
//
//  Created by Kyuhyun Park on 6/5/24.
//

import XCTest

func doAsyncWork() async {
    print("Doing async work")
}

func doRegularWork() {
    print("A")
    Task {
        print("B")
        await doAsyncWork()
        print("C")
    }
    print("D")
}

final class TaskTests: XCTestCase {
    
    func test() throws {
        doRegularWork()
    }
    
}
