import Foundation
import SwiftSyntax

private let nilLiteral = ExprSyntax(NilLiteralExprSyntax())
private let falseLiteral = ExprSyntax(BooleanLiteralExprSyntax(literal: .keyword(.false)))

class PowerAssertRewriter: SyntaxRewriter {
  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    if let calledExpression = node.calledExpression.as(DeclReferenceExprSyntax.self) {
      switch calledExpression.baseName.tokenKind {
      case .identifier("XCTAssert"):
        return super.visit(node.rewriteAssertTrue())
      case .identifier("XCTAssertEqual"):
        if node.arguments.dropFirst(2).first?.label?.tokenKind == .identifier("accuracy") {
          return super.visit(node)
        }
        return super.visit(node.rewriteComparisonExpression(op: "=="))
      case .identifier("XCTAssertFalse"):
        return super.visit(node.rewriteAssertWithExpression(falseLiteral))
      case .identifier("XCTAssertGreaterThan"):
        return super.visit(node.rewriteComparisonExpression(op: ">"))
      case .identifier("XCTAssertGreaterThanOrEqual"):
        return super.visit(node.rewriteComparisonExpression(op: ">="))
      case .identifier("XCTAssertIdentical"):
        return super.visit(node.rewriteComparisonExpression(op: "==="))
      case .identifier("XCTAssertLessThan"):
        return super.visit(node.rewriteComparisonExpression(op: "<"))
      case .identifier("XCTAssertLessThanOrEqual"):
        return super.visit(node.rewriteComparisonExpression(op: "<="))
      case .identifier("XCTAssertNil"):
        return super.visit(node.rewriteAssertWithExpression(nilLiteral))
      case .identifier("XCTAssertNotEqual"):
        if node.arguments.dropFirst(2).first?.label?.tokenKind == .identifier("accuracy") {
          return super.visit(node)
        }
        return super.visit(node.rewriteComparisonExpression(op: "!="))
      case .identifier("XCTAssertNotIdentical"):
        return super.visit(node.rewriteComparisonExpression(op: "!=="))
      case .identifier("XCTAssertTrue"):
        return super.visit(node.rewriteAssertTrue())
      default:
        break
      }
    }
    return super.visit(node)
  }
}

extension FunctionCallExprSyntax {
  func rewriteAssertTrue() -> Self {
    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.leadingTrivia, leadingTrivia)
  }

  func rewriteAssertWithExpression(_ expression: ExprSyntax) -> Self {
    guard arguments.count >= 1 else {
      return self
    }

    let first = arguments[arguments.startIndex]
    let remaining = arguments.dropFirst(1)

    var arguments = LabeledExprListSyntax(
      arrayLiteral: LabeledExprSyntax(
        expression: InfixOperatorExprSyntax(
          leftOperand: TupleExprSyntax(elements: LabeledExprListSyntax(arrayLiteral: LabeledExprSyntax(expression: first.expression))),
          operator: BinaryOperatorExprSyntax(operator: .binaryOperator("=="))
            .with(\.leadingTrivia, .space)
            .with(\.trailingTrivia, .space),
          rightOperand: expression
        ),
        trailingComma: remaining.isEmpty ? .identifier("") : .commaToken(trailingTrivia: .space)
      )
    )

    for argument in remaining {
      arguments.insert(argument, at: arguments.endIndex)
    }

    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.arguments, arguments)
    .with(\.leadingTrivia, leadingTrivia)
  }

  func rewriteComparisonExpression(op: String) -> Self {
    guard arguments.count >= 2 else {
      return self
    }

    let first = arguments[arguments.startIndex]
    let second = arguments[arguments.index(arguments.startIndex, offsetBy: 1)]

    let remainingArguments = arguments.dropFirst(2)

    var arguments = LabeledExprListSyntax(
      arrayLiteral: LabeledExprSyntax(
        expression: InfixOperatorExprSyntax(
          leftOperand: first.expression,
          operator: BinaryOperatorExprSyntax(operator: .binaryOperator(op))
            .with(\.leadingTrivia, .space)
            .with(\.trailingTrivia, .space),
          rightOperand: second.expression
        ),
        trailingComma: remainingArguments.isEmpty ? .identifier("") : .commaToken(trailingTrivia: .space)
      )
    )

    for argument in remainingArguments {
      arguments.insert(argument, at: arguments.endIndex)
    }

    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.arguments, arguments)
    .with(\.leadingTrivia, leadingTrivia)
  }
}
