//
//  main.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 10/14/24.
//

import Foundation
import HelloSwiftFramework

// How to Unit Test Swift CLI applications in XCode
// https://dev.to/sokol8/how-to-unit-test-cli-application-in-swift-5f5o
//
// Xcode command line tool project 에는 바로 테스트를 연결할 수 없다.
// static binary 는 테스트할 수 없기 때문.
//
// console 코드를 테스트하려면 프레임웍 타켓을 따로 생성해서 테스트해야 한다.
// 생성한 프레임웍은 메인 타겟에 몇 가지 절차를 수행해서 연결한다.
// public func / import framework 문장은 기본이고.
// Project -> Targets -> Main Target -> Build Phases -> Target Deps 에서 프레임웍을 추가한다.

print("Hello, World!")
print(helloSwiftFramework())
