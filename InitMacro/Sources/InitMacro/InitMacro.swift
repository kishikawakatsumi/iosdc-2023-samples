/// Generate memberwise initializer
@attached(member, names: named(init))
public macro Init() = #externalMacro(module: "InitMacroPlugin", type: "InitMacro")
