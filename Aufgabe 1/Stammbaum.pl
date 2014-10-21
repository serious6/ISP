% Autor:  Vincent R., André B.
% ------------------------------------

male(sascha).
male(steven).
male(benno).
male(justin).
male(rob).
male(mike).

female(michelle).
female(mandy).
female(chantal).
female(jacqueline).
female(rosie).
female(claire).

married(sascha, michelle).
married(steven, mandy).
married(mike, claire).

child(sascha,benno).
child(sascha,chantal).
child(benno,steven).
child(michelle,benno).
child(michelle,chantal).
child(michelle,mandy).

child(steven,jacqueline).
child(mandy,jacqueline).

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
   
daughter(A, B):-
   female(A),
   parent(B, A).
   
son(A, B):-
   male(A),
   parent(B, A).

parent(A, B, C):-
   mother(A, C),
   father(B, C).

grand_parent(A, B, C):-
   grand_father(A, C),
   grand_mother(B, C),
   married(A, B).

mother(A, B):-
   female(A),
   child(A, B).

grand_mother(A, B):-
   mother(A, X),
   parent(X, B).
   
mother_in_law(A, B):-
   mother(A, X),
   married(X, B).
 
father(A, B):-
   male(A),
   child(A, B).
   
grand_father(A, B):-
   father(A, X),
   parent(X, B).
   
father_in_law(A, B):-
   father(A, X),
   married(X, B).
   
aunt(A, B):-
   female(A),
   sister(A, X),
   mother(X, B).
   
uncle(A, B):-
   sibling(A,X),
   parent(X,B),
   male(A).
 
cousin(A, B):-
   sibling(X1,X2),
   parent(X2,A),
   parent(X1,B),
   not(A=B).
   
nephew(A, B):-
   child(A,X),
   parent(B,X).

% half_sister(A, B):-
%   .
