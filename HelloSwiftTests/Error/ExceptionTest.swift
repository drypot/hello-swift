//
//  ExceptionTest.swift
//  HelloSwiftTesting
//
//  Created by Kyuhyun Park on 10/8/24.
//

import Foundation
import Testing

// Mastering macOS programming-Packt Publishing (2017), 12장,

// an Error type in Swift is literally anything you want it to be;
// you simply create a struct, or a class, or an enum, and
// declare it to conform to the Error protocol

struct ExceptionTest {
    
    enum MathError: Error, Equatable {
        case divideByZeroError
        case negativeNumberError
        case lousyNumberError(objection: String) // with an associated value
    }

    func calculate(_ a: Double, by b: Double) throws ->Double {
        if b < 0.0 {
            throw MathError.negativeNumberError
        }
        if b == 0.0 {
            throw MathError.divideByZeroError
        }
        return a / b
    }

    @Test func calculateReturnResult() throws {
        var result: Double?
        do {
            result = try calculate(10, by: 2)
        } catch {
            result = nil
        }
        #expect(result == 5)
    }
    
    @Test func calculateCanThrow() throws {
        #expect(throws: Never.self) {
            try calculate(10, by: 2)
        }
        #expect(throws: MathError.divideByZeroError) {
            try calculate(10, by: 0.0)
        }
    }
    
    @Test func weCanCatchError() throws {
        var message: String?
        
        do {
            let _ = try calculate(10, by: 0)
            message = "ok"
        } catch {
            message = "some error"
        }
        
        #expect(message == "some error")
    }

    @Test func weCanCatchError2() throws {
        var message: String?
        
        do {
            let _ = try calculate(10, by: -10)
            message = "ok"
        } catch MathError.divideByZeroError {
            message = "divide by zero"
        } catch MathError.negativeNumberError {
            message = "negative number"
        }
        
        #expect(message == "negative number")
    }
    
    @Test func weCanAssertErrorWillNotOccur() throws {
        let result: Double = try! calculate(10, by: 2)
        #expect(result == 5)
    }
    
    @Test func tryCanBeOptional() throws {
        do {
            let result: Double? = try? calculate(10, by: 2)
            #expect(result == 5)
        }
        
        do {
            let result: Double? = try? calculate(10, by: 0)
            #expect(result == nil)
        }
    }
}
