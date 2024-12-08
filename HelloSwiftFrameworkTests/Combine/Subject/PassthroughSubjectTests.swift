//
//  PassthroughSubjectTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 12/8/24.
//

import Foundation
import Combine
import Testing

// https://developer.apple.com/documentation/combine/passthroughsubject

// provides a convenient way to adapt existing imperative code to the Combine model.

struct PassthroughSubjectTests {

    @Test func test() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        let subject = PassthroughSubject<Int, Never>()

        subject
            .sink { completion in
                logger.append(99)
            } receiveValue: { value in
                logger.append(value)
            }
            .store(in: &cancellables)

        subject.send(1)
        subject.send(2)
        subject.send(3)
        subject.send(4)
        subject.send(completion: .finished)

        #expect(logger.log() == [1, 2, 3, 4, 99])
    }

}
