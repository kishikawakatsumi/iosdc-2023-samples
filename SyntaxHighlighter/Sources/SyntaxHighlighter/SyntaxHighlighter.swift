import Foundation
import SwiftSyntax

class SyntaxHighlighter: SyntaxAnyVisitor {
  var html = """
    <!DOCTYPE html>
    <head>\(style)</head>
    """

  override func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
    html += """
      <span class="\(node.syntaxNodeType)">
      """
    return .visitChildren
  }

  override func visitAnyPost(_ node: Syntax) {
    html += "</span>"
  }

  override func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
    var kind = "\(node.tokenKind)"
    if let index = kind.firstIndex(of: "(") {
      kind = String(kind.prefix(upTo: index))
    }
    if kind.hasSuffix("Keyword") {
      kind = "keyword"
    }

    html += node.leadingTrivia.pieces.map { $0.html() }.joined()
    html += """
      <span class="\(kind.htmlEscaped())">\(node.text.htmlEscaped())</span>
      """
    html += node.trailingTrivia.pieces.map { $0.html() }.joined()

    return .visitChildren
  }

  override func visitPost(_ node: TokenSyntax) {}
}

private extension String {
  func htmlEscaped() -> String {
    var escaped = ""
    for character in self {
      switch character {
      case "<":
        escaped.append("&lt;")
      case ">":
        escaped.append("&gt;")
      case "\"":
        escaped.append("&quot;")
      case "&":
        escaped.append("&amp;")
      default:
        escaped.append(character)
      }
    }
    return escaped
  }

  func htmlWhiteSpaceEscaped() -> String {
    var escaped = ""
    for character in self {
      switch character {
      case " ":
        escaped.append("&nbsp;")
      case "\n":
        escaped.append("<br>")
      default:
        escaped.append(character)
      }
    }
    return escaped
  }
}

private extension TriviaPiece {
  func wrapWithSpanTag(class c: String, text: String) -> String {
    "<span class='\(c.htmlEscaped())'>\(text.htmlEscaped().htmlWhiteSpaceEscaped())</span>"
  }

  func html() -> String {
    var trivia = ""
    switch self {
    case .spaces(let count):
      trivia += String(repeating: "&nbsp;", count: count)
    case .tabs(let count):
      trivia += String(repeating: "&nbsp;", count: count * 2)
    case .verticalTabs, .formfeeds:
      break
    case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
      trivia += String(repeating: "<br/>", count: count)
    case .lineComment(let text):
      trivia += wrapWithSpanTag(class: "lineComment", text: text)
    case .blockComment(let text):
      trivia += wrapWithSpanTag(class: "blockComment", text: text)
    case .docLineComment(let text):
      trivia += wrapWithSpanTag(class: "docLineComment", text: text)
    case .docBlockComment(let text):
      trivia += wrapWithSpanTag(class: "docBlockComment", text: text)
    case .unexpectedText(let text):
      trivia += wrapWithSpanTag(class: "unexpectedText", text: text)
    case .backslashes(let count):
      trivia += String(repeating: #"\"#, count: count)
    case .pounds(let count):
      trivia += String(repeating: "#", count: count)
    }
    return trivia
  }
}
