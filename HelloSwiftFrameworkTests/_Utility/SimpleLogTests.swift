//
//  SimpleLogTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/5/24.
//

import Foundation
import Testing

struct SimpleLogTests {

    @Test func testLog() throws {
        let category1 = "category1"
        let category2 = "category2"

        #expect(SimpleLog.log(withTag: category1) == nil)
        #expect(SimpleLog.log(withTag: category2) == nil)

        SimpleLog.log("job1", tag: category1)
        #expect(SimpleLog.log(withTag: category1) == ["job1"])
        #expect(SimpleLog.log(withTag: category2) == nil)

        SimpleLog.log("job2", tag: category1)
        #expect(SimpleLog.log(withTag: category1) == ["job1", "job2"])
        #expect(SimpleLog.log(withTag: category2) == nil)

        SimpleLog.log("job3", tag: category2)
        #expect(SimpleLog.log(withTag: category1) == ["job1", "job2"])
        #expect(SimpleLog.log(withTag: category2) == ["job3"])
    }

}
