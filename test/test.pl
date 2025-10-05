f(1).
f(2).
f(3).

g(X, Y) :- f(X), f(Y).

h(X, Y) :- f(Y), f(X).