import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InitMacro: MemberMacro {
  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [SwiftSyntax.DeclSyntax] {
    guard declaration.is(ActorDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) || declaration.is(StructDeclSyntax.self) else {
      return []
    }

    let variableDecls: [(pattern: IdentifierPatternSyntax, typeAnnotation: TypeAnnotationSyntax)]
    variableDecls = declaration.memberBlock.members.compactMap {
      guard let decl = $0.decl.as(VariableDeclSyntax.self) else { return nil }

      guard let binding = decl.bindings.first else { return nil }

      guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else { return nil }
      guard let typeAnnotation = binding.typeAnnotation else { return nil }
      
      return (pattern, typeAnnotation)
    }

    return [
          """
          init(
              \(raw: variableDecls.map { "\($0.pattern)\($0.typeAnnotation)" }.joined(separator: ",\n"))
          ) {
              \(raw: variableDecls.map { "self.\($0.pattern) = \($0.pattern)" }.joined(separator: "\n"))
          }
          """
    ]

    // return [
    //   DeclSyntax(
    //     InitializerDeclSyntax(
    //       signature: FunctionSignatureSyntax(
    //         parameterClause: FunctionParameterClauseSyntax(
    //           parameters: FunctionParameterListSyntax(
    //             variableDecls.enumerated().map { (index, variableDecl) in
    //               let (pattern, typeAnnotation) = variableDecl
    //               let trailingComma: TokenSyntax = index < variableDecls.count - 1 ? .commaToken() : .identifier("")
    //               return FunctionParameterSyntax(firstName: pattern.identifier, type: typeAnnotation.type, trailingComma: trailingComma)
    //             }
    //           )
    //         )
    //       ),
    //       body: CodeBlockSyntax(
    //         statements: CodeBlockItemListSyntax(
    //           variableDecls.map { (pattern, typeAnnotation) in
    //             CodeBlockItemSyntax(
    //               item: CodeBlockItemSyntax.Item(
    //                 InfixOperatorExprSyntax(
    //                   leftOperand: MemberAccessExprSyntax(
    //                     base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
    //                     name: pattern.identifier
    //                   ),
    //                   operator: AssignmentExprSyntax(),
    //                   rightOperand: DeclReferenceExprSyntax(baseName: pattern.identifier)
    //                 )
    //               )
    //             )
    //           }
    //         )
    //       )
    //     )
    //   )
    // ]
  }
}

@main
struct InitMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InitMacro.self,
    ]
}
