% Autor:  Vincent R., André B.
% ------------------------------------

male(sascha).
male(steven).
male(benno).
male(justin).

female(michelle).
female(mandy).
female(chantal).
female(jacqueline).

married(sascha, michelle).
married(steven, mandy).

is_child(sascha,benno).
is_child(sascha,chantal).
is_child(michelle,benno).
is_child(michelle,chantal).

is_child(steven,jacqueline).
is_child(mandy,jacqueline).

% ------------------------------------

siblings(A, B):-
   parent(Mother, Father, A),
   parent(Mother, Father, B),
   not(A=B).
   
brother(A, B):-
   male(A),
   siblings(A, B).
   
sister(A, B):-
   female(A),
   siblings(A, B).

parent(A, B, C):-
   mother(A, C),
   father(B, C).

mother(A, B):-
   female(A),
   child(A, B).
 
father(A, B):-
   male(A),
   child(A, B).
   
aunt(A, B):-
   true.
   
uncle(A, B):-
   true.
 
cousin(A, B):-
   child(A, Mother),
   siblings(Mother, Father),
   child(B, Father).

nephew(A, B):-
   true.

half_sister(A, B):-
   true.

grand_aunt(A, B):-
   true.
