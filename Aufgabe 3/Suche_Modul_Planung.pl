start_description([
        block(block1),
        block(block2),
        block(block3),
        block(block4),  %mit Block4
        on(table,block2),
        on(table,block3),
        on(block2,block1),
        on(table,block4), %mit Block4
        clear(block1),
        clear(block3),
        clear(block4), %mit Block4
        handempty
]).

goal_description([
        block(block1),
        block(block2),
        block(block3),
        block(block4), %mit Block4
        on(block4,block2), %mit Block4
        on(table,block3),
        on(table,block1),
        on(block1,block4), %mit Block4
%       on(block1,block2), %ohne Block4
        clear(block3),
        clear(block2),
        handempty
]).


start_node((start,_,_)).

goal_node((_,State,_)):-
  goal_description(GoalState),
  mysubset(GoalState, State).

state_member(_,[]):- !,fail.

state_member(State,[FirstState|_]):-
  mysubset(State,FirstState),
  mysubset(FirstState,State),
  !.

state_member(State,[_|RestStates]):-  
  state_member(State,RestStates).



eval_path(Algorithm, Path) :-
        length(Path, G),
        eval_state(Algorithm, Path, G).


eval_state(aStar, [(_, State, Value) | _], G) :-
        heuristic(correctPos, State, Heuristic),
        Value is Heuristic + G.

eval_state(_, [(_, State, Value) | _], _) :-
        heuristic(correctPos, State, Value).


heuristic(wrongPos, State, Value) :-
        goal_description(GoalState),
        lists:subtract(GoalState, State, WrongPositions),
        length(WrongPositions, Value).

heuristic(correctPos, State, Value) :-
        goal_description(GoalState),
        intersection(State, GoalState, Intersection),
        length(Intersection, CorrectPositions),
        length(GoalState, Abstand),
        Value is (Abstand - CorrectPositions).


action(pick_up(X),
       [handempty, clear(X), on(table,X)],
       [handempty, clear(X), on(table,X)],
       [holding(X)]).

action(pick_up(X),
       [handempty, clear(X), on(Y,X), block(Y)],
       [handempty, clear(X), on(Y,X)],
       [holding(X), clear(Y)]).

action(put_on_table(X),
       [holding(X)],
       [holding(X)],
       [handempty, clear(X), on(table,X)]).

action(put_on(Y,X),
       [holding(X), clear(Y)],
       [holding(X), clear(Y)],
       [handempty, clear(X), on(Y,X)]).

mysubset([],_).
mysubset([H|T],List):-
  member(H,List),
  mysubset(T,List).


expand_help(State, Name, Result):-
  action(Name, CondList, DelList, AddList),
  mysubset(CondList, State),
  lists:subtract(State, DelList, SubtractResult),
  lists:union(AddList, SubtractResult, Result).
  
expand((_, State, _), Result):-
  findall((Name, NewState, _), expand_help(State, Name, NewState), Result).
