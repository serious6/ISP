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
	verb,
	anpe(Funk, Name),
	{
		Funktion =.. [Funk, Wer, Name],
		call(Funktion),
		write(Wer)
	}.
	
% Artikel, Nomen, Präposition, Eigenname
anpe(Funk, Name) -->
	artikel,
	nomen(Funk),
	praeposition,
	eigenname(Name).

interrogativpronomen --> [X], {lex(X, _, interrogativpronomen)}.
praeposition --> [X], {lex(X, _, praeposition)}.
eigenname(Name) --> [Name], {lex(Name, _, eigenname)}.
artikel --> [X], {lex(X, _, artikel)}.
nomen(Funk) --> [X], {lex(X, Funk, nomen)}.
verb --> [X], {lex(X, _, verb)}.

lex(wer, _, interrogativpronomen).
lex(ist, _, verb).
lex(der, _, artikel).
lex(bruder, brother, nomen).
lex(von, _, praeposition).

lex(Name, _, eigenname) :- male(Name).
lex(Name, _, eigenname) :- female(Name).
