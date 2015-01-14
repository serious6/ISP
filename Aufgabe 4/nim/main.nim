import sets, problem, tables

let
  colors = toSet(["blau", "rot", "grün", "weiß", "gelb"])
  nationalities = toSet(["Brite", "Schwede", "Däne", "Norweger", "Deutsche"])
  pets = toSet(["Vogel", "Hund", "Katze", "Pferd", "Fisch"])
  drinks = toSet(["Tee", "Kaffee", "Milch", "Bier", "Wasser"])
  cigarettes = toSet(["Pall Mall", "Dunhill", "Malboro", "Rothmanns", "Winfield"])


var p: Problem = newProblem()

p.addVariables(colors + nationalities + pets + drinks + cigarettes, 1..5)

for vars in [colors, nationalities, pets, drinks, cigarettes]:
  p.allDifferent(vars)

#1. Der Brite lebt im roten Haus.
p.addConstraint("Brite" |=| "rot")
#2. Der Schwede hält sich einen Hund.
p.addConstraint("Schwede" |=| "Hund")
#3. Der Däne trinkt gern Tee.
p.addConstraint("Däne" |=| "Tee")
#4. Das grüne Haus steht links neben dem weißen Haus.
p.addConstraint(proc (a, b: int): bool = a + 1 == b, "grün", "weiß")
#5. Der Besitzer des grünen Hauses trinkt Kaffee.
p.addConstraint("grün" |=| "Kaffee")
#6. Die Person, die Pall Mall raucht, hat einen Vogel.
p.addConstraint("Pall Mall" |=| "Vogel")
#7. Der Mann im mittleren Haus trinkt Milch.
p.addConstraint("Milch" |=| 3)
#8. Der Bewohner des gelben Hauses raucht Dunhill.
p.addConstraint("gelb" |=| "Dunhill")
#9. Der Norweger lebt im ersten Haus.
p.addConstraint("Norweger" |=| 1)
#10. Der Malboro-Raucher wohnt neben der Person mit der Katze.
p.addConstraint(proc (a, b: int): bool = abs(a - b) == 1, "Malboro", "Katze")
#11. Der Mann mit dem Pferd lebt neben der Person, die Dunhill raucht.
p.addConstraint(proc (a, b: int): bool = abs(a - b) == 1, "Pferd", "Dunhill")
#12. Der Winfield-Raucher trinkt gern Bier.
p.addConstraint("Winfield" |=| "Bier")
#13. Der Norweger wohnt neben dem blauen Haus.
p.addConstraint(proc (a, b: int): bool = abs(a - b) == 1, "Norweger", "blau")
#14. Der Deutsche raucht Rothmanns.
p.addConstraint("Deutsche" |=| "Rothmanns")
#15. Der Malboro-Raucher hat einen Nachbarn, der Wasser trinkt.
p.addConstraint(proc (a, b: int): bool = abs(a - b) == 1, "Malboro", "Wasser")

solve p

echo(p.variables)

for name in nationalities:
  if p.variables[name] == p.variables["Fisch"]:
    echo("Der " & name & " hält einen Fisch")
