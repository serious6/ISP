% Autor:  Vincent R., André B.
% ------------------------------------

male(sascha).
male(steven).
male(benno).
male(justin).
male(rob).
male(mike).

male(brother1).
male(brother2).

female(michelle).
female(mandy).
female(chantal).
female(jacqueline).
female(rosie).
female(claire).

female(mother1).
female(child1).

married(sascha, michelle).
married(steven, mandy).
married(mike, claire).

is_married(X,Y):-
	married(Y,X), !.

is_married(X,Y):-
	married(X,Y), !.

child(sascha,benno).
child(sascha,chantal).
child(benno,steven).
child(michelle,benno).
child(michelle,chantal).
child(michelle,mandy).
child(sascha,claire).
child(mandy,claire).


child(mike, brother1).
child(mike, brother2).
child(claire, brother1).
child(claire, brother2).

child(brother1, child1).

child(steven,jacqueline).
child(mandy,jacqueline).

% ------------------------------------

siblings(A, B):-
   parent(Mother, Father, A),
   parent(Mother, Father, B),
   not(A=B),
   !.
   
brother(A, B):-
   male(A),
   siblings(A, B).

sister(A, B):-
	female(A),
   siblings(A, B).
   
daughter(A, B):-
   female(A),
   parent(B, _, A).

daughter(A, B):-
   female(A),
   parent(_, B, A).
   
son(A, B):-
   male(A),
   parent(B, _, A).
   
son(A, B):-
   male(A),
   parent(_, B, A).

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
   parent(X, _, B).
   
mother_in_law(A, B):-
   mother(A, X),
   married(X, B).
 
father(A, B):-
   male(A),
   child(A, B).
   
grand_father(A, B):-
   father(A, X),
   parent(_, X, B).
   
father_in_law(A, B):-
   father(A, X),
   married(X, B).
   
aunt(A, B):-
   female(A),
   sister(A, X),
   mother(X, B).
   
uncle(A, B):-
   brother(A, X),
   parent(_, X,B).
 
cousin(A, B):-
   uncle(X, A),
   father(X, B).
   
nephew(A, B):-
   male(A),
   child(X, A),
   siblings(B, X).

half_sister(A, B):-
	female(A),
	parent(Y, X, A),
	parent(Z, X, B),
	Y \= Z,
	!.

half_sister(A, B):-
	female(A),
	parent(X, Y, A),
	parent(X, Z, B),
	Y \= Z,
	!.