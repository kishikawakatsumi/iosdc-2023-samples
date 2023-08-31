# iOSDC 2023 "Mastering SwiftSyntax" Sample Code

### SyntaxHighlighter

Convert Swift source code to HTML with syntax highlight. Learn how to use `SyntaxVisitor`.

Swift ソースコードを HTML に変換します。`SyntaxVisitor`の使い方を学びます。

### InitMacro

Automatically generate a memberwise initializer for any `class`, `struct` or `actor`.

Try implementing the following issues to make the macro more practical.

- Do not apply to types other than `class`, `struct` and `actor`.
- Match the access modifier attached to the type (public, private, etc.) with the access level of the initialiser.  
  e.g. `public struct` => `public init() {`
- Exclude computed property
- Support function type properties

任意の Class、Struct、Actor について Memberwise initializer を自動生成します。

より実用的なマクロにするために次の課題を実装してみてください。

- Class、Struct、Actor 以外の型に適用しない
- 型につくアクセス修飾子(public、private など)とイニシャライザのアクセスレベルを一致させる  
  例: `public struct` => `public init() {`
- Computed Property を除外する
- 関数型のプロパティに対応する

### SwiftLint

#### Rewrite Opening Brace Spacing rule with SwiftSyntax

- https://github.com/realm/SwiftLint/pull/5164

#### Fix Collection Element Alignment rule false positive

- https://github.com/realm/SwiftLint/pull/5173

### Xcode Source Editor Extension

Xcode Source Editor Extension that converts `XCTAssert*()` function to Power Assert macro.

It is difficult to configure Xcode Source Editor Extension, so I prepared a sample code that implements only the processing of SwiftSyntax.

`XCTAssert*()`関数を Power Assert マクロに変換する Xcode Source Editor Extension です。

Xcode Source Editor Extension を動かすための設定が難しいので、SwiftSyntax の処理だけを実装したサンプルコードを用意しました。

The actual implementation is here.

本来の実装はこちらです。

- https://github.com/kishikawakatsumi/swift-power-assert/pull/278
