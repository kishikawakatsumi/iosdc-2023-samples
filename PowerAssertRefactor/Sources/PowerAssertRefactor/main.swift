import Foundation
import SwiftSyntax
import SwiftParser

let source = """
  let a = 0
  let b = 1

  XCTAssertEqual(a, b)
  XCTAssertEqual(a, b, "a == b")
  XCTAssertGreaterThan(a, b)

  let name: String? = "katsumi"
  XCTAssertNil(name)
  """
let sourceFile = Parser.parse(source: source)

let rewriter = PowerAssertRewriter()
print(rewriter.rewrite(sourceFile).description)
