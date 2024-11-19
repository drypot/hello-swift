//
//  ID.swift
//  HelloSwiftFramework
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation

class IntIDGenerator {
    private var currentID: Int = 0
    private let lock = NSLock()

    func nextID() -> Int {
        lock.lock()
        defer { lock.unlock() }
        currentID += 1
        return currentID
    }
}

struct IntID: Identifiable, Equatable, Hashable {
    nonisolated(unsafe) private static let generator = IntIDGenerator()

    let id: Int

    init() {
        id = Self.generator.nextID()
    }
}
