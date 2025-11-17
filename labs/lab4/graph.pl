


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

n_member(Element, List, N) :-
    N1 is N - 1,
    nth1(N1, List, Element).

member_coordinate(Vertex, Positions, Coord) :-
    member(position(Vertex, X, Y), Positions),
    Coord = coordinate(X, Y).

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
solve(Vertices, Edges, Grid, Limit, Positions) :-
    search_positions(0, Vertices, Edges, Grid, Limit, 0, [], Positions).


% ?- /\/\/\/\
search_positions(_, _, _, _, Limit, Attempts, _, _) :- 
    Attempts > Limit,
    !, 
    fail.

search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, Acc, Positions) :-
    length(Vertices, Num_Vertices),
    Vertex_Index = Num_Vertices, 
    not(has_crossings(Edges, Positions)),
    !,
    Positions = Acc.

search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, Acc, Positions) :-
    !,
    Next_Attempt is Attempts + 1,
    t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Next_Attempt, 0, [], Positions).


t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, Acc, Result) :-
    Grid = grid(SizeX, SizeY),
    X < SizeX,
    tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, 0, Acc, Result).

t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, Acc, Result) :-
    Grid = grid(SizeX, SizeY),
    X < SizeX,
    not(tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, 0, _, _)),
    Next_X is X + 1,
    t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, Next_X, Acc, Result).

    
tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, Y, Acc, Result) :-
    Grid = grid(SizeX, SizeY),
    Y < SizeY,
    position_occupied(X, Y, Acc), 
    !,
    Next_Y is Y + 1,
    tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, Next_Y, Acc, Result).

tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, X, Y, Acc, Result) :-
    Grid = grid(SizeX, SizeY),
    Y < SizeY,
    not(position_occupied(X, Y, Acc)),
    !,
    n_member(Vertex, Vertices, Vertex_Index),
    New_Positions = [position(Vertex_Index, X, Y) | Acc],
    Positioned_Edges = get_positioned_edges(Edges, New_Positions, Positioned_Edges_Result),
    not(has_crossings(Positioned_Edges_Result, New_Positions)),
    Next_Vertex_Index is Vertex_Index + 1,
    search_positions(Next_Vertex_Index, Vertices, Edges, Grid, Limit, Attempts, New_Positions, Result).


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

t_has_crossings([edge(Vertex1, Vertex2)|Rest_Edges], Positions) :-
    tt_has_crossings_inner(Vertex1, Vertex2, Rest_Edges, Positions).

t_has_crossings([edge(Vertex1, Vertex2)|Rest_Edges], Positions) :-
    not(tt_has_crossings_inner(Vertex1, Vertex2, Rest_Edges, Positions)),
    t_has_crossings(Rest_Edges, Positions).

tt_has_crossings_inner(Vertex1, Vertex2, [edge(Vertex3, Vertex4)|Rest_Edges], Positions) :-
    member_coordinate(Vertex1, Positions, Coord1),
    member_coordinate(Vertex2, Positions, Coord2),
    member_coordinate(Vertex3, Positions, Coord3),
    member_coordinate(Vertex4, Positions, Coord4),
    segments_intersect(Coord1, Coord2, Coord3, Coord4), !.

tt_has_crossings_inner(Vertex1, Vertex2, [edge(Vertex3, Vertex4)|Rest_Edges], Positions) :-
    member_coordinate(Vertex1, Positions, Coord1),
    member_coordinate(Vertex2, Positions, Coord2),
    member_coordinate(Vertex3, Positions, Coord3),
    member_coordinate(Vertex4, Positions, Coord4),
    not(segments_intersect(Coord1, Coord2, Coord3, Coord4)),
    tt_has_crossings_inner(Vertex1, Vertex2, Rest_Edges, Positions).

% ?- /\/\/\/\
orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), collinear) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val = 0.

orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), clockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val > 0.

orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), counterclockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val < 0.


% ?- /\/\/\/\
on_segment(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY)) :-
    QX =< max(PX, RX), QX >= min(PX, RX),
    QY =< max(PY, RY), QY >= min(PY, RY).


% ?- /\/\/\/\
segments_intersect(Coord1, Coord2, Coord1, Coord3) :- !, fail.
segments_intersect(Coord1, Coord2, Coord3, Coord1) :- !, fail.
segments_intersect(Coord1, Coord2, Coord2, Coord3) :- !, fail.
segments_intersect(Coord1, Coord2, Coord3, Coord2) :- !, fail.

% General case
segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),
    O1 \= O2,
    O3 \= O4.

% Special Cases - Collinear points
segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),
    
    O3 = collinear,
    on_segment(Coord1, Coord3, Coord2).

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord1, Coord4, Coord2).

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord3, Coord1, Coord4).

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord3, Coord2, Coord4).

t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
    O1, O2, O3, O4) :-
    orientation(Coord1, Coord2, Coord3, O1),
    orientation(Coord1, Coord2, Coord4, O2),
    orientation(Coord3, Coord4, Coord1, O3),
    orientation(Coord3, Coord4, Coord2, O4).

