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

are_siblings(A, B):-
   parent(M, F, A),
   parent(M, F, B),
   A \= B.

parent(A, B, C):-
   is_mother(A, C),
   is_father(B, C).

is_mother(A, B):-
   female(A),
   is_child(A, B).
 
is_father(A, B):-
   male(A),
   is_child(A, B).
 
is_cousin(A, B):-
   true.

is_nephew(A, B):-
   true.

is_half_sister(A, B):-
   true.

is_grand_aunt(A, B):-
   true.
