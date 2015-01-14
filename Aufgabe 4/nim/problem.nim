import sets, tables, sequtils

type
  DomainBackup = tuple[name: string, domain: seq[int]]
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
proc addNeighbours(problem: var Problem, constraint: Constraint, queue: var seq[Constraint])
proc cmp(constraint: Constraint, a, b: int): bool
proc arcReduce(problem: var Problem, constraint: Constraint): bool
proc addAllBinaryConstraints(problem: var Problem, queue: var seq[Constraint])
proc printQueue(queue: var seq[Constraint])
proc solve2(problem: var Problem, queue: var seq[Constraint]): bool
proc ac3la(problem: var Problem, queue: var seq[Constraint]): bool
proc saveDomains(problem: var Problem): seq[DomainBackup]
proc restoreDomains(problem: var Problem, domains: seq[DomainBackup])
proc addInvolvedConstraints(problem: var Problem, variable: string, queue: var seq[Constraint])



proc newProblem*(): Problem =
  result.constraints = @[]
  result.variables = newTable[string, Variable]()

proc addVariables*(problem: var Problem, vars: HashSet[string], domain: Slice[int]) =
  for variable in vars:
    var v: Variable
    v.domain = toSeq(domain.a .. domain.b)
    problem.variables[variable] = v

proc addConstraint*(problem: var Problem, constraint: Constraint) =
  if constraint.right == nil: # unary
    problem.variables.mget(constraint.left).domain = @[constraint.value]
  else:
    problem.constraints.add(constraint)

    var c2: Constraint
    c2.left = constraint.right
    c2.right = constraint.left
    c2.value = constraint.value
    c2.op = constraint.op
    if constraint.custom != nil:
      c2.custom = proc (a, b: int): bool = constraint.custom(b, a)
    problem.constraints.add(c2)

proc addConstraint*(problem: var Problem, custom: proc (a, b: int): bool, a, b: string) =
  var c: Constraint
  c.left = a
  c.right = b
  c.custom = custom
  problem.constraints.add(c)

  var c2: Constraint
  c2.left = b
  c2.right = a
  c2.custom = proc (a, b: int): bool = custom(b, a)
  problem.constraints.add(c2)

proc allDifferent*(problem: var Problem, vars: HashSet[string]) =
  var svars: seq[string] = @[]
  for v in vars:
    svars.add(v)
  for i, v1 in svars:
    for j, v2 in svars:
      if j > i:
        problem.addConstraint(v1 |~=| v2)

proc solve*(problem: var Problem) =
  var queue: seq[Constraint] = @[]
  problem.addAllBinaryConstraints(queue)
  if not problem.ac3la(queue):
    return
  else:
    var emptyQueue: seq[Constraint] = @[]
    discard problem.solve2(emptyQueue)
    
proc solve2(problem: var Problem, queue: var seq[Constraint]): bool =
  if queue.len() > 0 and not problem.ac3la(queue):
    return false
  while true:
    var hasGreaterDomain = false
    for k, v in pairs(problem.variables):
      if v.domain.len() > 1:
        hasGreaterDomain = true
        var domain: seq[int] = problem.variables[k].domain
        for value in domain:
          var backup: seq[DomainBackup] = problem.saveDomains()
          problem.variables.mget(k).domain = @[value]
          var queue: seq[Constraint] = @[]
          problem.addInvolvedConstraints(k, queue)
          if problem.solve2(queue):
            return true
          else:
            problem.restoreDomains(backup)
    if not hasGreaterDomain:
      break
  return true
    
proc saveDomains(problem: var Problem): seq[DomainBackup] =
  result = @[]
  for k, v in pairs(problem.variables):
    var backup: DomainBackup = (k, v.domain)
    result.add(backup)

proc restoreDomains(problem: var Problem, domains: seq[DomainBackup]) =
  for v in domains:
    problem.variables.mget(v.name).domain = v.domain

proc ac3la(problem: var Problem, queue: var seq[Constraint]): bool =
  result = true
  #printQueue(queue)
  
  while queue.len() > 0 and result:
    var c: Constraint = queue[0]
    queue.delete(first = 0, last = 0)
    if problem.arcReduce(c):
      problem.addNeighbours(c, queue)
      result = problem.variables[c.left].domain.len() > 0
    #else:
      #echo("REVISE(" & c.left & ", " & c.right & ") bewirkt nichts")
    #printQueue(queue)

proc arcReduce(problem: var Problem, constraint: Constraint): bool = # aka REVISE
  var len = problem.variables[constraint.left].domain.len()
  var i = len - 1
  while i >= 0:
    var found = false
    var v1: int = problem.variables[constraint.left].domain[i]
    #echo(constraint.left & " domain " & $(problem.variables[constraint.left].domain))
    for v2 in problem.variables[constraint.right].domain:
      #echo(constraint.left & " = " & $(v1) & " cmp " & constraint.right & " = " & $(v2) & " === " & $(constraint.cmp(v1, v2)))
      if constraint.cmp(v1, v2): # kaputt?
        found = true
        break
    if not found:
      problem.variables.mget(constraint.left).domain.del(i)
      result = true
    dec i
  #if len != problem.variables[constraint.left].domain.len():
    #echo("REVISE(" & constraint.left & ", " & constraint.right & ") bewirkt " & constraint.left & " ∈ " & $(problem.variables[constraint.left].domain))

proc addAllBinaryConstraints(problem: var Problem, queue: var seq[Constraint]) =
  for constraint in problem.constraints:
    queue.add(constraint)

proc addNeighbours(problem: var Problem, constraint: Constraint, queue: var seq[Constraint]) =
  for c in problem.constraints:
    if constraint.left == c.right and c.left != constraint.right: # before: rückwärtskante WAR NICHT in problem.constraints drin
      #echo("(" & c.left & ", " & c.right & ") gefunden zum adden")
      var found = false
      for cQ in queue:
        if cQ.left == c.left and cQ.right == c.right:
          found = true
          break
      if not found:
        queue.insert(c, 0)

proc addInvolvedConstraints(problem: var Problem, variable: string, queue: var seq[Constraint]) =
  for c in problem.constraints:
    if c.right == variable:
      queue.insert(c, 0)

proc printQueue(queue: var seq[Constraint]) =
  var s = "{"
  for c in queue:
    s = s & "(" & c.left & ", " & c.right & "), "
  s = s & "}"
  echo(s)

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


