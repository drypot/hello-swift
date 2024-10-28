//
//  StringUnicodeTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 10/28/24.
//

import Foundation
import Testing

struct StringUnicodeTests {

    // String 은 extended grapheme cluster 의 연속이다.
    // extended grapheme cluster 는 여러 Unicode scalar 의 연속이다.

    // extended grapheme cluster 는 Swift Character 타입으로 표현된다.

    // Unicode scalar is the 21-bit codes that are the basic unit of Unicode

    // scalar value is represented by a Unicode.Scalar and is equivalent to a UTF-32 code unit.

    // Unicode Codepoint, Scalar, UTF32 은 엄밀히 따지면 차이가 있지만, 대강 값이 같다.

    @Test func testUnicodeRepresentation() throws {

        // é
        // Latin Small Letter E With Acute
        // Unicode Codepoint: U+00E9
        //
        // UTF8  0xC3 0xA9
        // UTF16 0x00E9
        // UTF32 0x0000_00E9
        // Swift \u{00E9}
        //
        // https://unicodeplus.com/U+00E9

        //
        // Combining Acute Accent
        // Unicode Codepoint: U+0301
        //
        // UTF8  0xCC 0x81
        // UTF16 0x0301
        // UTF32 0x0000_0301
        // Swift \u{0301}

        // 🌍
        // Earth Globe Europe-Africa
        // Unicode Codepoint: U+1F30D
        //
        // UTF8  0xF0 0x9F 0x8C 0x8D
        // UTF16 0xD83C 0xDF0D
        // UTF32 0x0001_F30D
        // Swift \u{1F30D}

        #expect("é" == "\u{00E9}")
        #expect("é" == "e\u{0301}")
        #expect("é".unicodeScalars.first == "é")
        #expect("é".unicodeScalars.first == Unicode.Scalar(0x00E9))
        #expect("é".unicodeScalars.first?.value == 0x00E9)
        #expect(Array("é".unicodeScalars) == [Unicode.Scalar(0x00E9)])
        #expect("é".unicodeScalars.map { $0.value } == [0x00E9])
        #expect(Array("é".utf8) == [0xC3, 0xA9])
        #expect(Array("é".utf16) == [0x00E9])

        #expect("🌍" == "\u{1F30D}")
    }

    @Test func testStringElements() throws {
        let cafe = "Cafe\u{301} du 🌍"
        let array = Array(cafe)

        #expect(cafe == "Café du 🌍")
        #expect(cafe.count == 9)

        #expect(array == ["C", "a", "f", "é", " ", "d", "u", " ", "🌍"])
        #expect(array.count == 9)
    }

    @Test func testUnicodeScalars() throws {
        let cafe = "Cafe\u{301} du 🌍"
        let elements = Array(cafe.unicodeScalars)
        let values = cafe.unicodeScalars.map { $0.value }

        #expect(elements == ["C", "a", "f", "e", "\u{0301}", " ", "d", "u", " ", "\u{0001F30D}"])
        #expect(elements.count == 10)

        //                                                -------                                 -------
        #expect(values == [0x0043, 0x0061, 0x0066, 0x0065, 0x0301, 0x0020, 0x0064, 0x0075, 0x0020, 0x1F30D])
        #expect(values.count == 10)

        // let hexString2 = values.map { String(format: "0x%04X,", $0) }.joined(separator: " ")
    }

    @Test func testUTF8() throws {
        let cafe = "Cafe\u{301} du 🌍"
        let elements = Array(cafe.utf8)

        //                                          -----------                         ----------------------
        #expect(elements == [0x43, 0x61, 0x66, 0x65, 0xCC, 0x81, 0x20, 0x64, 0x75, 0x20, 0xF0, 0x9F, 0x8C, 0x8D])
        #expect(elements.count == 14)

        // let hexString = elements.map { String(format: "0x%02X,", $0) }.joined(separator: " ")

        // C API
        #expect(strlen(cafe) == 14)
    }

    @Test func testNSString() throws {
        let cafe = "Cafe\u{301} du 🌍" as NSString

        #expect(cafe.length == 11)

        // 나머지는 알고싶지 않다.
    }

}
