% Laden der externen Dateien
:- ensure_loaded([readsentence]).
:- ensure_loaded([stammbaum]).

startup :-
        writeln('Bitte stellen Sie eine Anfrage...'),
        read_sentence(In),
        strip(Result, In),
        writeln(Result)
        .
        
post_question --> open_question.
post_question --> closed_question.
        
        
strip(Q,In) :- append(Q,['.'],In).
strip(Q,In) :- append(Q,['?'],In).
strip(Q,In) :- append(Q,['!'],In).