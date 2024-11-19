//
//  IntIDTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing

struct IntIDTests {

    @Test func test() throws {
        let id1 = IntID()
        let id2 = IntID()

        #expect(id1 != id2)
    }

}
