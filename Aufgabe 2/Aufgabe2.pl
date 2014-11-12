:- ensure_loaded([readsentence]).
:- ensure_loaded([stammbaum]).

start :-
	writeln('Was willst du denn?'),
	read_sentence(Satz),
	frage(Satz, []).

% Ergänzungsfrage
% Wer ist der Bruder von Chantal?
frage -->
	interrogativpronomen,
	verbalphrase(_, Funk, _),
	praepositionphase(Name, _),
	[?],
	{
		Funktion =.. [Funk, Wer, Name],
		Funktion,
		write(Wer)
	}.

% Entscheidungsfrage
% Ist Benno der Bruder von Chantal?
frage -->
	verbalphrase(_, _, Numerus),
	nominalphrase(Name1, _, Numerus),
	nominalphrase(Name2, Funk, _),
	[?],
	{
		Funktion =.. [Funk, Name1, Name2],
		Funktion
	}.

verbalphrase(_, _, Numerus) -->
	verb(Numerus).
	
verbalphrase(Name, Funk, Numerus) -->
	verb(Numerus),
	nominalphrase(Name, Funk, Numerus).
	
nominalphrase(Name, _, Numerus) -->
	eigenname(Name, Numerus).
	
nominalphrase(_, Funk, Numerus) -->
	artikel(Genus, Numerus),
	nomen(Genus, Funk, Numerus).
	
nominalphrase(Name, Funk, Numerus) -->
	artikel(Genus, Numerus),
	nomen(Genus, Funk, Numerus),
	praepositionphase(Name, Funk).

praepositionphase(Name, Funk) -->
	praeposition,
	nominalphrase(Name, Funk, _).

interrogativpronomen --> [X], {lex(X, _, interrogativpronomen, _, _)}.
praeposition --> [X], {lex(X, _, praeposition, _, _)}.
eigenname(Name, Numerus) --> [Name], {lex(Name, _, eigenname, _, Numerus)}.
artikel(Genus, Numerus) --> [X], {lex(X, _, artikel, Genus, Numerus)}.
nomen(Genus, Funk, Numerus) --> [X], {lex(X, Funk, nomen, Genus, Numerus)}.
verb(Numerus) --> [X], {lex(X, _, verb, _, Numerus)}.

lex(wer, _, interrogativpronomen, _, _).
lex(ist, _, verb, _, singular).
lex(sind, _, verb, _, plural).
lex(der, _, artikel, maskulin, singular).
lex(die, _, artikel, feminin, singular).
lex(die, _, artikel, _, plural).
lex(brueder, brother, nomen, maskulin, plural).
lex(bruder, brother, nomen, maskulin, singular).
lex(schwester, sister, nomen, feminin, singular).
lex(von, _, praeposition, _, _).

lex(Name, _, eigenname, _, singular) :- male(Name).
lex(Name, _, eigenname, _, singular) :- female(Name).
