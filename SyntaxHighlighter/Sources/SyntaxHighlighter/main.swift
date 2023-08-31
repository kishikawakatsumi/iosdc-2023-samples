import Foundation
import SwiftSyntax
import SwiftParser

let source = """
  /// The `Rank` enum represents the rank of a playing card.
  /// Each case also has an associated raw integer value.
  enum Rank: Int {

      /// Represents an Ace card. The raw value is `1`.
      case ace = 1

      /// Represents numbered cards from 2 to 10.
      /// The raw values for these will match their card number.
      case two, three, four, five, six, seven, eight, nine, ten

      /// Represents face cards. The raw values for these will be 11, 12, and 13.
      case jack, queen, king

      func simpleDescription() -> String {
          switch self {
          case .ace:
              return "ace"
          case .jack:
              return "jack"
          case .queen:
              return "queen"
          case .king:
              return "king"
          default:
              return String(self.rawValue)
          }
      }
  }

  let ace = Rank.ace
  let aceRawValue = ace.rawValue
  """
let sourceFile = Parser.parse(source: source)

let highlighter = SyntaxHighlighter(viewMode: .sourceAccurate)
highlighter.walk(sourceFile)
print(highlighter.html)
