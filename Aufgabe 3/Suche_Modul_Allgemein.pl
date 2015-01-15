eval_used_time([]).
eval_used_time([CurrentStrategy|Rest]):-
   write('###########################################'),
   nl,
   write('Measuring time for '+CurrentStrategy),
   nl,
   time(solve(CurrentStrategy)),
   eval_used_time(Rest),
   write('###########################################'),
   nl.


solve(Strategy):-
  start_description(StartState),
  solve((start, StartState, _), Strategy).

solve(StartNode, Strategy) :-
  start_node(StartNode),
  search([[StartNode]], Strategy, Path),
  reverse(Path, Path_in_correct_order),
  write_solution(Path_in_correct_order).


search([[FirstNode | Predecessors] | _], _, [FirstNode | Predecessors]) :- 
  goal_node(FirstNode),
  nl, write('SUCCESS'), nl, !.

search([[FirstNode | Predecessors] | RestPaths], Strategy, Solution) :-
  expand(FirstNode, Children),
  generate_new_paths(Children, [FirstNode | Predecessors], NewPaths),
  insert_new_paths(Strategy, NewPaths, RestPaths, AllPaths),
  search(AllPaths, Strategy, Solution).


generate_new_paths(Children, Path, NewPaths):-
  maplist(get_state, Path, States),
  generate_new_paths_help(Children, Path, States, NewPaths).

generate_new_paths_help([],_,_,[]).

generate_new_paths_help([FirstChild|RestChildren],Path,States,RestNewPaths):- 
  get_state(FirstChild,State),state_member(State,States),!,
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).

generate_new_paths_help([FirstChild|RestChildren],Path,States,[[FirstChild|Path]|RestNewPaths]):- 
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).


get_state((_,State,_),State).


insert_new_paths(Strategy, [], OldPaths, OldPaths):-
  write_fail(Strategy, OldPaths), !.

% Tiefensuche
insert_new_paths(depth, NewPaths, OldPaths, AllPaths):-
  append(NewPaths, OldPaths, AllPaths),
  write_action(NewPaths).

% Breitensuche
insert_new_paths(breadth, NewPaths, OldPaths, AllPaths):-
  append(OldPaths, NewPaths, AllPaths),
  write_next_state(AllPaths),
  write_action(AllPaths).

% A*
insert_new_paths(aStar, NewPaths, OldPaths, AllPaths):-
  eval_paths(aStar, NewPaths),
  insert_new_paths_informed(NewPaths, OldPaths, AllPaths),
  write_action(AllPaths),
  write_state(AllPaths).

% Optimistisches Bergsteigen
insert_new_paths(ob, NewPaths, _, [BestPath]):-
  eval_paths(optimistischesBergsteigen, NewPaths),
  insert_new_paths_informed(NewPaths, [], [BestPath|Verworfen]),
  cheaper2(BestPath),
  write_Verworfen(Verworfen),
  write_action([BestPath]),
  write_state([BestPath]).

% Bergsteigen mit Backtracking
insert_new_paths(bergsteigenMitBacktracking, NewPaths, OldPaths, AllPaths):-
  eval_paths(bergsteigenMitBacktracking, NewPaths),
  insert_new_paths_informed(NewPaths, [], SortedNewPaths),
  lists:append(SortedNewPaths, OldPaths, AllPaths),
  write_action(AllPaths),
  write_state(AllPaths).

% Gierige Bestensuche
insert_new_paths(gierigeBestensuche, NewPaths, OldPaths, AllPaths):-
  eval_paths(gierigeBestensuche, NewPaths),
  insert_new_paths_informed(NewPaths, OldPaths, AllPaths),
  write_action(AllPaths),
  write_state(AllPaths).

cheaper2([(_, _, _),(_, _, _)]).
cheaper2([(_, _, V1),(_, _, V2)|_]):-
	V1 =< V2.
  
write_solution(Path):-
  nl, write('SOLUTION:'), nl,
  write_actions(Path).

write_actions([]).

write_actions([(Action, _, _) | Rest]):-
  write('Action: '), write(Action), nl,
  write_actions(Rest).

write_action([[(Action,_)|_]|_]):-
  nl,write('Action: '),write(Action),nl.

write_next_state([[_,(_,State)|_]|_]):-
  nl,write('Go on with: '),write(State),nl.

write_state([[(_,State)|_]|_]):-
  write('New State: '),write(State),nl.

write_fail(depth,[[(_,State)|_]|_]):-
  nl,write('FAIL, go on with: '),write(State),nl.

write_fail(_,_):-  nl,write('FAIL').

write_Verworfen([]).

write_Verworfen([[(_,State)|_]|_]):-
  nl, write('Verworfen:'), nl,
  write('State: '),write(State),nl.
