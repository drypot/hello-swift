//
//  StructTests.swift
//  Tests
//
//  Created by drypot on 2024-04-06.
//

import XCTest

final class StructTests: XCTestCase {
    
    func testStructCopy() throws {
        struct T {
            var p = "x"
        }
        
        let a = T()
        var b = a // *** var
        
        b.p = "y"
        
        XCTAssertEqual(a.p, "x") // *** x
    }
    
    func testClassCopy() throws {
        class T {
            var p = "x"
        }
        
        let a = T()
        let b = a  // *** let
        
        b.p = "y"
        
        XCTAssertEqual(a.p, "y") // *** y
    }
    
    func testStructDeepCopy() throws {
        struct T {
            var p: [Int] = [1, 2]
        }
        
        let a = T()
        var b = a // *** var
        
        b.p.append(3)
        
        XCTAssertEqual(a.p.count, 2) // *** 2
        XCTAssertEqual(b.p.count, 3)
    }
    
    func testClassDeepCopy() throws {
        class T {
            var p: [Int] = [1, 2]
        }
        
        let a = T()
        let b = a // *** let
        
        b.p.append(3)
        
        XCTAssertEqual(a.p.count, 3) // *** 3
        XCTAssertEqual(b.p.count, 3)
    }
    
    func testStructDeepCopy2() throws {
        struct T {
            var p: [[Int]] = [[1, 2]]
        }
        
        let a = T()
        var b = a // *** var
        
        b.p[0].append(3)
        
        XCTAssertEqual(a.p[0].count, 2) // *** 2
        XCTAssertEqual(b.p[0].count, 3)
    }
    
    func testClassDeepCopy2() throws {
        class T {
            var p: [[Int]] = [[1, 2]]
        }
        
        let a = T()
        let b = a // *** let
        
        b.p[0].append(3)
        
        XCTAssertEqual(a.p[0].count, 3) // *** 3
        XCTAssertEqual(b.p[0].count, 3)
    }
}
