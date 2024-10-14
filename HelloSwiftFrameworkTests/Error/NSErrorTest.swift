//
//  NSErrorTest.swift
//  HelloSwiftTesting
//
//  Created by Kyuhyun Park on 10/10/24.
//

import Foundation
import Testing

struct NSErrorTest {

    let url1 = URL(fileURLWithPath: "/non-existent")
    let url2 = URL(fileURLWithPath: "/someLocation")

    @Test func nserrorContainsProperties() {
        do {
            try FileManager.default.moveItem(at: url1, to: url2)
            fatalError("error should be generated")
        } catch let error as NSError {
            //print("\(error)")
            #expect(error.domain == NSCocoaErrorDomain)
            #expect(error.code == NSFileNoSuchFileError)
            #expect(error.userInfo[NSUnderlyingErrorKey] != nil)
            #expect(error.userInfo[NSURLErrorKey] as? URL == url1)
            #expect(error.userInfo[NSFilePathErrorKey] as? String == "/non-existent")
            #expect(error.userInfo["NSSourceFilePathErrorKey"] as? String == "/non-existent")
            #expect(error.userInfo["NSDestinationFilePath"] as? String == "/someLocation")
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }
    
    @Test func nserrorCanBePatternMatched() {
        do {
            try FileManager.default.moveItem(at: url1, to: url2)
            fatalError("error should be generated")
        } catch CocoaError.fileNoSuchFile {
            //
        } catch let error as NSError {
            fatalError("Unexpected error: \(error)")
        }
    }
    
    @Test func weCanMakeCustomNSError() {
        
        func divide(a: Double, b: Double) throws -> Double {
            if b == 0.0 {
                throw NSError(
                    domain: "CustomErrorDomainString",
                    code: 5001,
                    userInfo: ["ErrorType": "DivideByZeroError"]
                )
            }
            return a / b
        }
        
        do{
            let _ = try divide(a: 1, b: 0)
            fatalError("error should be generated")
        } catch let error as NSError {
            #expect(error.domain == "CustomErrorDomainString")
            #expect(error.code == 5001)
        } catch let error {
            fatalError("Unexpected error: \(error)")
        }
        
    }
}
