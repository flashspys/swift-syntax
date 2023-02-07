
//// Automatically Generated by generate-swiftbasicformat
//// Do Not Edit Directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//


import SwiftSyntax

open class BasicFormat: SyntaxRewriter {
  public var indentationLevel: Int = 0
  
  open var indentation: TriviaPiece { 
    .spaces(indentationLevel * 4) 
  }
  
  public var indentedNewline: Trivia { 
    Trivia(pieces: [.newlines(1), indentation]) 
  }
  
  private var lastRewrittenToken: TokenSyntax?
  
  private var putNextTokenOnNewLine: Bool = false
  
  open override func visitPre(_ node: Syntax) {
    if let keyPath = getKeyPath(node), shouldIndent(keyPath) {
      indentationLevel += 1
    }
    if let parent = node.parent, childrenSeparatedByNewline(parent) {
      putNextTokenOnNewLine = true
    }
  }
  
  open override func visitPost(_ node: Syntax) {
    if let keyPath = getKeyPath(node), shouldIndent(keyPath) {
      indentationLevel -= 1
    }
  }
  
  open override func visit(_ node: TokenSyntax) -> TokenSyntax {
    var leadingTrivia = node.leadingTrivia
    var trailingTrivia = node.trailingTrivia
    if requiresLeadingSpace(node) && leadingTrivia.isEmpty && lastRewrittenToken?.trailingTrivia.isEmpty != false {
      leadingTrivia += .space
    }
    if requiresTrailingSpace(node) && trailingTrivia.isEmpty {
      trailingTrivia += .space
    }
    if let keyPath = getKeyPath(Syntax(node)), requiresLeadingNewline(keyPath), !(leadingTrivia.first?.isNewline ?? false) {
      leadingTrivia = .newline + leadingTrivia
    }
    leadingTrivia = leadingTrivia.indented(indentation: indentation)
    trailingTrivia = trailingTrivia.indented(indentation: indentation)
    let rewritten = TokenSyntax(
        node.tokenKind, 
        leadingTrivia: leadingTrivia, 
        trailingTrivia: trailingTrivia, 
        presence: node.presence
      
    )
    lastRewrittenToken = rewritten
    putNextTokenOnNewLine = false
    return rewritten
  }
  
  open func shouldIndent(_ keyPath: AnyKeyPath) -> Bool {
    switch keyPath {
    case \AccessorBlockSyntax.accessors: 
      return true
    case \ArrayExprSyntax.elements: 
      return true
    case \ClosureExprSyntax.statements: 
      return true
    case \CodeBlockSyntax.statements: 
      return true
    case \DictionaryElementSyntax.valueExpression: 
      return true
    case \DictionaryExprSyntax.content: 
      return true
    case \FunctionCallExprSyntax.argumentList: 
      return true
    case \FunctionTypeSyntax.arguments: 
      return true
    case \MemberDeclBlockSyntax.members: 
      return true
    case \ParameterClauseSyntax.parameterList: 
      return true
    case \SwitchCaseSyntax.statements: 
      return true
    case \TupleExprSyntax.elementList: 
      return true
    case \TupleTypeSyntax.elements: 
      return true
    default: 
      return false
    }
  }
  
  open func requiresLeadingNewline(_ keyPath: AnyKeyPath) -> Bool {
    switch keyPath {
    case \AccessorBlockSyntax.rightBrace: 
      return true
    case \ClosureExprSyntax.rightBrace: 
      return true
    case \CodeBlockSyntax.rightBrace: 
      return true
    case \MemberDeclBlockSyntax.rightBrace: 
      return true
    case \SwitchExprSyntax.rightBrace: 
      return true
    default: 
      return putNextTokenOnNewLine
    }
  }
  
  open func childrenSeparatedByNewline(_ node: Syntax) -> Bool {
    switch node.as(SyntaxEnum.self) {
    case .accessorList: 
      return true
    case .codeBlockItemList: 
      return true
    case .memberDeclList: 
      return true
    case .switchCaseList: 
      return true
    default: 
      return false
    }
  }
  
  /// If this returns a value that is not `nil`, it overrides the default
  /// leading space behavior of a token.
  open func requiresLeadingSpace(_ keyPath: AnyKeyPath) -> Bool? {
    switch keyPath {
    case \AvailabilityArgumentSyntax.entry: 
      return false
    default: 
      return nil
    }
  }
  
  open func requiresLeadingSpace(_ token: TokenSyntax) -> Bool {
    if let keyPath = getKeyPath(token), let requiresLeadingSpace = requiresLeadingSpace(keyPath) {
      return requiresLeadingSpace
    }
    switch token.tokenKind {
    case .leftBrace: 
      return true
    case .equal: 
      return true
    case .arrow: 
      return true
    case .binaryOperator: 
      return true
    case .keyword(.`catch`): 
      return true
    case .keyword(.`in`): 
      return true
    case .keyword(.`where`): 
      return true
    default: 
      return false
    }
  }
  
  /// If this returns a value that is not `nil`, it overrides the default
  /// trailing space behavior of a token.
  open func requiresTrailingSpace(_ keyPath: AnyKeyPath) -> Bool? {
    switch keyPath {
    case \AvailabilityArgumentSyntax.entry: 
      return false
    case \DictionaryExprSyntax.content: 
      return false
    case \DynamicReplacementArgumentsSyntax.forLabel: 
      return false
    case \TryExprSyntax.questionOrExclamationMark: 
      return true
    default: 
      return nil
    }
  }
  
  open func requiresTrailingSpace(_ token: TokenSyntax) -> Bool {
    if let keyPath = getKeyPath(token), let requiresTrailingSpace = requiresTrailingSpace(keyPath) {
      return requiresTrailingSpace
    }
    switch (token.tokenKind, token.nextToken(viewMode: .sourceAccurate)?.tokenKind) {
    case (.keyword(.as), .exclamationMark), // Ensures there is not space in `as!`
     (.keyword(.as), .postfixQuestionMark), // Ensures there is not space in `as?`
     (.exclamationMark, .leftParen), // Ensures there is not space in `myOptionalClosure!()`
     (.exclamationMark, .period), // Ensures there is not space in `myOptionalBar!.foo()`
     (.postfixQuestionMark, .leftParen), // Ensures there is not space in `init?()` or `myOptionalClosure?()`s
     (.postfixQuestionMark, .rightAngle), // Ensures there is not space in `ContiguousArray<RawSyntax?>`
     (.postfixQuestionMark, .rightParen), // Ensures there is not space in `myOptionalClosure?()`
     (.keyword(.try), .exclamationMark), // Ensures there is not space in `try!`
     (.keyword(.try), .postfixQuestionMark): // Ensures there is not space in `try?`:
      return false
    default: 
      break 
    }
    switch token.tokenKind {
    case .comma: 
      return true
    case .colon: 
      return true
    case .equal: 
      return true
    case .arrow: 
      return true
    case .poundSourceLocationKeyword: 
      return true
    case .poundIfKeyword: 
      return true
    case .poundElseKeyword: 
      return true
    case .poundElseifKeyword: 
      return true
    case .poundEndifKeyword: 
      return true
    case .poundAvailableKeyword: 
      return true
    case .poundUnavailableKeyword: 
      return true
    case .binaryOperator: 
      return true
    case .keyword(.`Any`): 
      return true
    case .keyword(.`as`): 
      return true
    case .keyword(.`associatedtype`): 
      return true
    case .keyword(.async): 
      return true
    case .keyword(.`break`): 
      return true
    case .keyword(.`case`): 
      return true
    case .keyword(.`class`): 
      return true
    case .keyword(.`continue`): 
      return true
    case .keyword(.`defer`): 
      return true
    case .keyword(.`else`): 
      return true
    case .keyword(.`enum`): 
      return true
    case .keyword(.`extension`): 
      return true
    case .keyword(.`fallthrough`): 
      return true
    case .keyword(.`fileprivate`): 
      return true
    case .keyword(.`for`): 
      return true
    case .keyword(.`func`): 
      return true
    case .keyword(.`guard`): 
      return true
    case .keyword(.`if`): 
      return true
    case .keyword(.`import`): 
      return true
    case .keyword(.`in`): 
      return true
    case .keyword(.`inout`): 
      return true
    case .keyword(.`internal`): 
      return true
    case .keyword(.`is`): 
      return true
    case .keyword(.`let`): 
      return true
    case .keyword(.`operator`): 
      return true
    case .keyword(.`precedencegroup`): 
      return true
    case .keyword(.`private`): 
      return true
    case .keyword(.`protocol`): 
      return true
    case .keyword(.`public`): 
      return true
    case .keyword(.`repeat`): 
      return true
    case .keyword(.`rethrows`): 
      return true
    case .keyword(.`return`): 
      return true
    case .keyword(.`static`): 
      return true
    case .keyword(.`struct`): 
      return true
    case .keyword(.`subscript`): 
      return true
    case .keyword(.`switch`): 
      return true
    case .keyword(.`throw`): 
      return true
    case .keyword(.`throws`): 
      return true
    case .keyword(.`try`): 
      return true
    case .keyword(.`typealias`): 
      return true
    case .keyword(.`var`): 
      return true
    case .keyword(.`where`): 
      return true
    case .keyword(.`while`): 
      return true
    default: 
      return false
    }
  }
  
  private func getKeyPath<T: SyntaxProtocol>(_ node: T) -> AnyKeyPath? {
    guard let parent = node.parent else {
      return nil
    }
    guard case .layout(let childrenKeyPaths) = parent.kind.syntaxNodeType.structure else {
      return nil
    }
    return childrenKeyPaths[node.indexInParent]
  }
}
