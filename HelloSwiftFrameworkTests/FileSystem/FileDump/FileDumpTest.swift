//
//  FileDumpTest.swift
//  HelloSwiftTesting
//
//  Created by drypot on 2022/10/02.
//

import Foundation
import Testing

struct FileDumpTest {

    func stringToHex(_ string: String) -> String {
        let hexString = string.utf8.map { String(format: "%02x", $0) }.joined()
        return hexString
    }
    
    @Test func weCanDumpTextFile() {
        
        print(FileManager.default.currentDirectoryPath)
        print(#file)
        
        let sourceFileUrl = URL(fileURLWithPath: #file)
        let directorytUrl = sourceFileUrl.deletingLastPathComponent()
        let fixturePath = directorytUrl.path + "/file-dump-fixture.txt"
        
        do {
            var fileContent = try String(contentsOfFile: fixturePath, encoding: .utf8)
            let stringToCompare = "Hello, world!\n"

            print(stringToHex(fileContent))
            print(stringToHex(stringToCompare))
            
            fileContent = fileContent.replacingOccurrences(of: "\r\n", with: "\n")
            print(stringToHex(fileContent))

            #expect(fileContent == stringToCompare)
            
        } catch {
            #expect(Bool(false))
        }
        
    }
    
}
