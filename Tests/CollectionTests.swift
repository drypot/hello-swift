//
//  CollectionTests.swift
//  Tests
//
//  Created by drypot on 2024-04-07.
//

import XCTest

final class CollectionTests: XCTestCase {

    func test() throws {
      let a = [1, 2, 3, 4, 5]
      let b = a.first(where: { $0 > 3})
      let _ = a.first { $0 > 3}
      XCTAssertEqual(b, 4)
      XCTAssertEqual(b, 4)
    }

}
