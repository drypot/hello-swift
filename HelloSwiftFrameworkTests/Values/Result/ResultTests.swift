//
//  ResultTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/9/24.
//

import Foundation
import Testing

// enum Result<Success, Failure> where Failure : Error, Success : ~Copyable
// https://developer.apple.com/documentation/swift/result

struct ResultTests {

    enum ParsingError: Error {
        case invalidString
    }

    func parseString(_ string: String) -> Result<Int, ParsingError> {
        guard let parsed = Int(string) else {
            return .failure(.invalidString)
        }
        return .success(parsed)
    }

    @Test func testSuccessCase() throws {
        let result = parseString("123")
        switch result {
        case .success(let value):
            #expect(value == 123)
        case .failure:
            fatalError()
        }
    }

    @Test func testFailCase() throws {
        let result = parseString("xxx")
        switch result {
        case .success:
            fatalError()
        case .failure(let error):
            #expect(error == .invalidString)
        }
    }

}
