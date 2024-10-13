//
//  HelloSwiftTesting.swift
//  HelloSwiftTesting
//
//  Created by Kyuhyun Park on 9/19/24.
//

import Testing

struct HelloSwiftTesting {

    @Test func example() async throws {
        #expect("abc" == "abc")
    }

}
