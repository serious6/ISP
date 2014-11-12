:- ensure_loaded([readsentence]).
:- ensure_loaded([stammbaum]).

start :-
	writeln('Was willst du denn?'),
	read_sentence(Satz),
	frage(Satz, []), !.

% Ergänzungsfrage
% Wer ist der Bruder von Chantal?
frage -->
	interrogativpronomen,
	verbalphrase(_, Funk),
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
	verbalphrase(Name1, _),
	nominalphrase(Name2, Funk),
	[?],
	{
		Funktion =.. [Funk, Name1, Name2],
		Funktion
	}.

verbalphrase(Name, Funk) -->
	verb,
	nominalphrase(Name, Funk).
	
nominalphrase(Name, _) -->
	eigenname(Name).
	
nominalphrase(_, Funk) -->
	artikel(Genus),
	nomen(Genus, Funk).
	
nominalphrase(Name, Funk) -->
	artikel(Genus),
	nomen(Genus, Funk),
	praepositionphase(Name, Funk).

praepositionphase(Name, Funk) -->
	praeposition,
	nominalphrase(Name, Funk).

interrogativpronomen --> [X], {lex(X, _, interrogativpronomen, _)}.
praeposition --> [X], {lex(X, _, praeposition, _)}.
eigenname(Name) --> [Name], {lex(Name, _, eigenname, _)}.
artikel(Genus) --> [X], {lex(X, _, artikel, Genus)}.
nomen(Genus, Funk) --> [X], {lex(X, Funk, nomen, Genus)}.
verb --> [X], {lex(X, _, verb, _)}.

lex(wer, _, interrogativpronomen, _).
lex(ist, _, verb, _).
lex(der, _, artikel, maskulin).
lex(die, _, artikel, feminin).
lex(bruder, brother, nomen, maskulin).
lex(schwester, sister, nomen, feminin).
lex(von, _, praeposition, _).

lex(Name, _, eigenname, _) :- male(Name).
lex(Name, _, eigenname, _) :- female(Name).
