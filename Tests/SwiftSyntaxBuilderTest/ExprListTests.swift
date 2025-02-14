//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder

final class ExprListTests: XCTestCase {
  func testExprList() {
    let testCases: [UInt: (ExprListSyntax, String)] = [
      #line: (ExprListSyntax([IntegerLiteralExprSyntax(1), BinaryOperatorExprSyntax(text: "+"), FloatLiteralExprSyntax(2.34)]), "1 + 2.34"),
      #line: ([IntegerLiteralExprSyntax(1), BinaryOperatorExprSyntax(text: "+"), FloatLiteralExprSyntax(2.34)], "1 + 2.34"),
    ]

    for (line, testCase) in testCases {
      let (builder, expected) = testCase
      AssertBuildResult(builder, expected, line: line)
    }
  }
}
