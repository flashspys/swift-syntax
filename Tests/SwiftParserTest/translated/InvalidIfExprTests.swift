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

// This test file has been translated from swift/test/Parse/invalid_if_expr.swift

import XCTest

final class InvalidIfExprTests: XCTestCase {
  func testInvalidIfExpr1() {
    AssertParse(
      """
      (a ? b1️⃣)
      """,
      diagnostics: [
        DiagnosticSpec(message: "expected ':' and expression after '? ...' in ternary expression", fixIts: ["insert ':' and expression"])
      ],
      fixedSource: "(a ? b: <#expression#>)"
    )
  }

  func testInvalidIfExpr2() {
    AssertParse(
      """
      (a ? b : c ? d1️⃣)
      """,
      diagnostics: [
        DiagnosticSpec(message: "expected ':' and expression after '? ...' in ternary expression", fixIts: ["insert ':' and expression"])
      ],
      fixedSource: "(a ? b : c ? d: <#expression#>)"
    )
  }

  func testInvalidIfExpr3() {
    AssertParse(
      """
      (a ? b ? c : d1️⃣
      """,
      diagnostics: [
        DiagnosticSpec(message: "expected ':' and expression after '? ...' in ternary expression", fixIts: ["insert ':' and expression"]),
        DiagnosticSpec(message: "expected ')' to end tuple"),
      ],
      fixedSource: "(a ? b ? c : d: <#expression#>)"
    )
  }

  func testInvalidIfExpr4() {
    AssertParse(
      """
      (a ? b ? c1️⃣)
      """,
      diagnostics: [
        DiagnosticSpec(message: "expected ':' and expression after '? ...' in ternary expression", fixIts: ["insert ':' and expression"]),
        DiagnosticSpec(message: "expected ':' and expression after '? ...' in ternary expression", fixIts: ["insert ':' and expression"]),
      ],
      fixedSource: "(a ? b ? c: <#expression#>: <#expression#>)"
    )
  }

}
