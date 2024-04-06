//
//  StructTests.swift
//  Tests
//
//  Created by drypot on 2024-04-06.
//

import XCTest

final class StructTests: XCTestCase {
  
  func testCopyStruct() throws {
    struct T {
      var p = "x"
    }
    
    let a = T()
    var b = a // *** var
    
    b.p = "y"
    
    XCTAssertEqual(a.p, "x") // *** x
  }
  
  func testCopyClass() throws {
    class T {
      var p = "x"
    }
    
    let a = T()
    let b = a  // *** let
    
    b.p = "y"
    
    XCTAssertEqual(a.p, "y") // *** y
  }
  
}
