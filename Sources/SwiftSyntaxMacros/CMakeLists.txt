# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for Swift project authors

add_swift_host_library(SwiftSyntaxMacros
  MacroProtocols/AccessorMacro.swift
  MacroProtocols/AttachedMacro.swift
  MacroProtocols/CodeItemMacro.swift
  MacroProtocols/ConformanceMacro.swift
  MacroProtocols/DeclarationMacro.swift
  MacroProtocols/ExpressionMacro.swift
  MacroProtocols/FreestandingMacro.swift
  MacroProtocols/Macro.swift
  MacroProtocols/MemberAttributeMacro.swift
  MacroProtocols/MemberMacro.swift
  MacroProtocols/PeerMacro.swift

  AbstractSourceLocation.swift
  BasicMacroExpansionContext.swift
  MacroExpansionContext.swift
  MacroSystem.swift
  Syntax+MacroEvaluation.swift
)

target_link_libraries(SwiftSyntaxMacros PUBLIC
  SwiftParser
  SwiftSyntaxBuilder
  )
