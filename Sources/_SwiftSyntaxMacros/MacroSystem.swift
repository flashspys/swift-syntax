import SwiftDiagnostics
import SwiftSyntax

/// Describes the kinds of errors that can occur within a macro system.
public enum MacroSystemError: Error {
  /// Indicates that a macro with the given name has already been defined.
  case alreadyDefined(new: Macro.Type, existing: Macro.Type)

  /// Indicates that an unknown macro was encountered during expansion.
  case unknownMacro(name: String, node: Syntax)

  /// Indicates that a macro evaluated as an expression by the given node
  /// is not an expression macro.
  case requiresExpressionMacro(macro: Macro.Type, node: Syntax)

  /// Indicates that a macro evaluated as a code item by the given node
  /// is not suitable for code items.
  case requiresCodeItemMacro(macro: Macro.Type, node: Syntax)

  /// Indicates that a macro produced diagnostics during evaluation. The
  /// diagnostics might not specifically include errors, but will be reported
  /// nonetheless.
  case evaluationDiagnostics(node: Syntax, diagnostics: [Diagnostic])
}

/// A system of known macros that can be expanded syntactically
public struct MacroSystem {
  var macros: [String : Macro.Type] = [:]

  /// Create an empty macro system.
  public init() { }

  /// Add a macro to the system.
  ///
  /// Throws an error if there is already a macro with this name.
  public mutating func add(_ macro: Macro.Type) throws {
    if let knownMacro = macros[macro.name] {
      throw MacroSystemError.alreadyDefined(new: macro, existing: knownMacro)
    }

    macros[macro.name] = macro
  }
}

/// Syntax rewriter that evaluates any macros encountered along the way.
class MacroApplication : SyntaxRewriter {
  let macroSystem: MacroSystem
  let context: MacroEvaluationContext
  let errorHandler: (MacroSystemError) -> Void

  init(
    macroSystem: MacroSystem,
    context: MacroEvaluationContext,
    errorHandler: @escaping (MacroSystemError) -> Void
  ) {
    self.macroSystem = macroSystem
    self.context = context
    self.errorHandler = errorHandler
  }

  override func visitAny(_ node: Syntax) -> Syntax? {
    guard node.evaluatedMacroName != nil else {
      return nil
    }

    return node.evaluateMacro(
      with: macroSystem, context: context, errorHandler: errorHandler
    )
  }

  override func visit(_ node: CodeBlockItemListSyntax) -> Syntax {
    var newItems: [CodeBlockItemSyntax] = []
    for item in node {
      // Recurse on the child node.
      let newItem = visit(item.item)

      // Flatten if we get code block item list syntax back.
      if let itemList = newItem.as(CodeBlockItemListSyntax.self) {
        newItems.append(contentsOf: itemList)
      } else {
        newItems.append(item.withItem(newItem))
      }
    }

    return Syntax(CodeBlockItemListSyntax(newItems))
  }
}

extension MacroSystem {
  /// Expand all macros encountered within the given syntax tree.
  ///
  /// - Parameter node: The syntax node in which macros will be evaluated.
  /// - Parameter context: The context in which macros are evaluated.
  /// - Parameter errorHandler: Errors encountered during traversal will
  ///   be passed to the error handler.
  /// - Returns: the syntax tree with all macros evaluated.
  public func evaluateMacros<Node: SyntaxProtocol>(
    node: Node,
    in context: MacroEvaluationContext,
    errorHandler: (MacroSystemError) -> Void
  ) -> Syntax {
    return withoutActuallyEscaping(errorHandler) { errorHandler in
      let applier = MacroApplication(
        macroSystem: self, context: context, errorHandler: errorHandler
      )
      return applier.visit(Syntax(node))
    }
  }
}