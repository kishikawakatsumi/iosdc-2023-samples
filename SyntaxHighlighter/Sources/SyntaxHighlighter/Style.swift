import Foundation

let style = """
  <style>
  span {
    font-family: ui-monospace, monospace;
  }
  .keyword,
  .atSign {
    color: #c800a4;
  }
  .importKeyword {
    color: #1c00cf;
  }
  .stringLiteral {
    color: #df0002;
  }
  .StringLiteralExprSyntax {
    color: #df0002;
  }
  .IntegerLiteralExprSyntax,
  .FloatLiteralExprSyntax {
    color: #3a00dc;
  }
  .integerLiteral,
  .floatingLiteral {
    color: #3a00dc;
  }
  .lineComment,
  .blockComment,
  .docLineComment,
  .docBlockComment {
    color: #008e00;
  }
  .unexpectedText,
  .shebang {
    color: #5d6c79;
  }
  .token.missing {
    color: #a3a3a3;
  }
  </style>
  """
