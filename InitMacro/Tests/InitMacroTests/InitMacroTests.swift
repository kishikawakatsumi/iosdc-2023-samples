import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(InitMacroPlugin)
import InitMacroPlugin

let testMacros: [String: Macro.Type] = [
    "Init": InitMacro.self,
]
#endif

final class InitMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(InitMacroMacros)
        assertMacroExpansion(
            """
            @Init
            class Person {
                let name: String
                let age: Int
                let birthday: Date?
            }
            """,
            expandedSource: """
            class Person {
                let name: String
                let age: Int
                let birthday: Date?

                init(
                    name: String,
                    age: Int,
                    birthday: Date?
                ) {
                    self.name = name
                    self.age = age
                    self.birthday = birthday
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
