import Foundation
import InitMacro

@Init
class Person {
  let name: String
  let age: Int
  let birthday: Date?
}

print(Person(name: "katsumi", age: 43, birthday: nil))
