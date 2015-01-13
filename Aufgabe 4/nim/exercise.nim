import sets, problem, tables

let colors = toSet(["X", "V", "Y", "Z"])

var p: Problem = newProblem()

p.addVariables(colors, 1..4)

p.addConstraint("X" |=| "V")
p.addConstraint(proc (a, b: int): bool = a * 2 == b, "X", "Z")
p.addConstraint(proc (a, b: int): bool = a < b, "X", "Y")
p.addConstraint("Y" |=| "Z")


solve p

echo(p.variables)
