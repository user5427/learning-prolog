


% DO NOT USE ONE LETTER VARIABLE NAMES!

% !- Define vertices and edges of a graph
vertex(Vertex).
edge(Vertex1, Vertex2) :- vertex(Vertex1), vertex(Vertex2), Vertex1 \= Vertex2.

coordinate(X, Y) :- integer(X), integer(Y), X >= 0, Y >= 0.

position(Vertex, X, Y) :- vertex(Vertex), coordinate(X, Y).

grid(SizeX, SizeY) :- integer(SizeX), integer(SizeY), SizeX > 0, SizeY > 0.

attempts_limit(Limit) :- integer(Limit), Limit > 0.

% !- Define list operations
append([], List, List).
append([Head|Tail], List, [Head|Result]) :- append(Tail, List, Result).

member(Element, [Element|_]).
member(Element, [_|Tail]) :- member(Element, Tail).

range(Low, High, Low).
range(Low, High, Result) :-
    Low < High,
    Next is Low + 1,
    range(Next, High, Result).

reverse(List, Reversed) :- reverse_helper(List, [], Reversed).
reverse_helper([], Acc, Acc).
reverse_helper([Head|Tail], Acc, Reversed) :-
    reverse_helper(Tail, [Head|Acc], Reversed).

append_lists([], Acc, Acc).
append_lists([List|Lists], Acc, Result) :-
    append(Acc, List, NewAcc),
    append_lists(Lists, NewAcc, Result).


% ?- /\/\/\/\
solve(Vertices, Edges, Grid, Attempts_Limit, Positions) :-
    search_positions(Vertices, Edges, Grid, Attempts_Limit, 0, Positions).


% ?- /\/\/\/\
search_positions(_, _, _, Attempts_Limit, Attempts_Limit, _) :- !, fail.

search_positions(Vertices, Edges, Grid, Attempts_Limit, Vertex_Index, Positions) :-
    length(Vertices, Num_Vertices),
    Num_Vertices = Vertex_Index, !,
    \+ has_crossings(Edges, Positions).

search_positions(Vertices, Edges, Grid, Attempts_Limit, Vertex_Index, Positions) :-
    t_search_positions(Vertices, Edges, Grid, Attempts_Limit, Vertex_Index, [], 0, Positions).

t_search_positions(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, X, Result) :-
    X < SizeX,
    tt_search_positions_inner(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Inner_Acc, X, 0, Result), !.
    Next_X is X + 1,
    t_search_positions(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, Next_X, Result).

t_search_positions(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, SizeX, Acc).
    


tt_search_positions_inner(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, X, Y, Result) :-
    Y < SizeY,
    position_occupied(X, Y, Positions), !,
    Next_Y is Y + 1,
    tt_search_positions_inner(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, X, Next_Y, Result).

tt_search_positions_inner(Vertices, Edges, grid(SizeX, SizeY), Attempts_Limit, Vertex_Index, Acc, X, SizeY, Acc).


% ?- /\/\/\/\
position_occupied(X, Y, Positions) :- member(position(_, X, Y), Positions).


% ?- /\/\/\/\
get_positioned_edges(Edges, Positions, Result) :-
    t_get_positioned_edges(Edges, Positions, [], Result).

t_get_positioned_edges([], _, Result, Result).

t_get_positioned_edges([edge(Vertex1, Vertex2)|Edges], Positions, Acc, Result) :-
    member(position(Vertex1, _, _), Positions),
    member(position(Vertex2, _, _), Positions),
    t_get_positioned_edges(Edges, Positions, [edge(Vertex1, Vertex2)|Acc], Result).


% ?- /\/\/\/\
has_crossings(Edges, Positions) :-
    t_has_crossings(Edges, Positions).

t_has_crossings([edge(Vertex1, Vertex2)|Edges], Positions) :-
    tt_has_crossings_inner(Vertex1, Vertex2, Edges, Positions),
    t_has_crossings(Edges, Positions).

tt_has_crossings_inner(Vertex1, Vertex2, [edge(Vertex3, Vertex4)|Edges], Positions) :-
    segments_intersect(Vertex1, Vertex2, Vertex3, Vertex4, Positions),
    tt_has_crossings_inner(Vertex1, Vertex2, Edges, Positions).


% ?- /\/\/\/\
orientation(position(P, PX, PY), position(Q, QX, QY), position(R, RX, RY), collinear) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val = 0.

orientation(position(P, PX, PY), position(Q, QX, QY), position(R, RX, RY), clockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val > 0.

orientation(position(P, PX, PY), position(Q, QX, QY), position(R, RX, RY), counterclockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val < 0.


% ?- /\/\/\/\
on_segment(position(P, PX, PY), position(Q, QX, QY), position(R, RX, RY)) :-
    QX =< max(PX, RX), QX >= min(PX, RX),
    QY =< max(PY, RY), QY >= min(PY, RY).


% ?- /\/\/\/\
segments_intersect(Vertex1, Vertex2, Vertex1, Vertex3, _) :- !, fail.
segments_intersect(Vertex1, Vertex2, Vertex3, Vertex1, _) :- !, fail.
segments_intersect(Vertex1, Vertex2, Vertex2, Vertex3, _) :- !, fail.
segments_intersect(Vertex1, Vertex2, Vertex3, Vertex2, _) :- !, fail.

segments_intersect(Vertex1, Vertex2, Vertex3, Vertex4, Positions) :-
    t_segments_intersect(Vertex1, Vertex2, Vertex3, Vertex4, Positions,
        O1, O2, O3, O4,
        _, _, _, _),
    O1 \= O2,
    O3 \= O4.

segments_intersect(Vertex1, Vertex2, Vertex1, Vertex3, Positions) :-
    t_segments_intersect(Vertex1, Vertex2, Vertex1, Vertex3, Positions,
        O1, O2, O3, O4,
        P1, P2, P3, P4),
    
    O3 = collinear,
    on_segment(P1, P3, P2).

segments_intersect(Vertex1, Vertex2, Vertex2, Vertex3, Positions) :-
    t_segments_intersect(Vertex1, Vertex2, Vertex2, Vertex3, Positions,
        O1, O2, O3, O4,
        P1, P2, P3, P4),

    O3 = collinear,
    on_segment(P1, P4, P2).

segments_intersect(Vertex1, Vertex2, Vertex3, Vertex1, Positions) :-
    t_segments_intersect(Vertex1, Vertex2, Vertex3, Vertex1, Positions,
        O1, O2, O3, O4,
        P1, P2, P3, P4),

    O3 = collinear,
    on_segment(P3, P1, P4).

segments_intersect(Vertex1, Vertex2, Vertex3, Vertex2, Positions) :-
    t_segments_intersect(Vertex1, Vertex2, Vertex3, Vertex2, Positions,
        O1, O2, O3, O4,
        P1, P2, P3, P4),

    O3 = collinear,
    on_segment(P3, P2, P4).

t_segments_intersect(Vertex1, Vertex2, Vertex3, Vertex4, Positions,
    O1, O2, O3, O4,
    P1, P2, P3, P4) :-
    member(position(Vertex1, X1, Y1), Positions),
    member(position(Vertex2, X2, Y2), Positions),
    member(position(Vertex3, X3, Y3), Positions),
    member(position(Vertex4, X4, Y4), Positions),

    P1 = position(Vertex1, X1, Y1),
    P2 = position(Vertex2, X2, Y2),
    P3 = position(Vertex3, X3, Y3),
    P4 = position(Vertex4, X4, Y4),

    orientation(P1, P2, P3, O1),
    orientation(P1, P2, P4, O2),
    orientation(P3, P4, P1, O3),
    orientation(P3, P4, P2, O4).

