import sets, tables, queues
from sequtils import toSeq

type
  Variable = object of RootObj
    domain*: seq[int]
  Constraint* = object of RootObj
    left: string
    right: string
    value: int
    op: string
    custom: proc (a, b: int): bool
  Problem* = object of RootObj
    constraints: seq[Constraint]
    variables*: TableRef[string, Variable]



proc `|~=|`*(a, b: string): Constraint
proc addNeighbours(problem: var Problem, constraint: Constraint, queue: var Queue[Constraint])
proc cmp(constraint: Constraint, a, b: int): bool



proc newProblem*(): Problem =
  result.constraints = @[]
  result.variables = newTable[string, Variable]()

proc addVariables*(problem: var Problem, vars: HashSet[string], domain: Slice[int]) =
  for variable in vars:
    var v: Variable
    v.domain = toSeq(domain.a .. domain.b)
    problem.variables[variable] = v

proc addConstraint*(problem: var Problem, constraint: Constraint) =
  problem.constraints.add(constraint)

proc addConstraint*(problem: var Problem, custom: proc (a, b: int): bool, a, b: string) =
  var c: Constraint
  c.left = a
  c.right = b
  c.custom = custom
  problem.constraints.add(c)

proc allDifferent*(problem: var Problem, vars: HashSet[string]) =
  for v1 in vars:
    for v2 in vars:
      if v1 != v2:
        problem.addConstraint(v1 |~=| v2)

proc addAllBinaryConstraints(problem: var Problem, queue: var Queue[Constraint]) =
  for constraint in problem.constraints:
    if constraint.right != nil:
      queue.add(constraint)
      
      var c2: Constraint
      c2.left = constraint.right
      c2.right = constraint.left
      c2.value = constraint.value
      c2.op = constraint.op
      c2.custom = constraint.custom
      
      queue.add(c2)

proc arcReduce(problem: var Problem, constraint: Constraint): bool =
  var i = problem.variables[constraint.left].domain.len() - 1
  while i >= 0:
    var found = false
    var v1: int = problem.variables[constraint.left].domain[i]
    for v2 in problem.variables[constraint.right].domain:
      if constraint.cmp(v1, v2):
        found = true
        break
    if not found:
      problem.variables.mget(constraint.left).domain.del(i)
      result = true
    dec i

proc solve*(problem: var Problem) =
  # unary constraints
  for constraint in problem.constraints:
    if constraint.right == nil:
      problem.variables.mget(constraint.left).domain = @[constraint.value]
  
  var queue: Queue[Constraint] = initQueue[Constraint](128)
  problem.addAllBinaryConstraints(queue)
  
  while queue.len() > 0:
    var c = queue.dequeue()
    if problem.arcReduce(c):
      problem.addNeighbours(c, queue)

proc addNeighbours(problem: var Problem, constraint: Constraint, queue: var Queue[Constraint]) =
  for c in problem.constraints:
    if constraint.right != nil: # filter unary constraints
      if constraint.left == c.right and c.left != constraint.right:
        var found = false
        for cQ in queue:
          if cQ.left == c.left and cQ.right == c.right:
            found = true
            break
        if not found:
          queue.add(c)

proc cmp(constraint: Constraint, a, b: int): bool =
  case constraint.op
  of "==":
    result = a == b
  of "!=":
    result = a != b
  else:
    result = constraint.custom(a, b)

proc `|=|`*(a, b: string): Constraint =
  result.left = a
  result.right = b
  result.op = "=="

proc `|=|`*(a: string, b: int): Constraint =
  result.left = a
  result.value = b

proc `|~=|`*(a, b: string): Constraint =
  result.left = a
  result.right = b
  result.op = "!="
  