% [SS] Plokščio grafo braižymas.

% !- Define vertices and edges of a graph
vertex(Vertex).
edge(Vertex1, Vertex2) :- vertex(Vertex1), vertex(Vertex2), Vertex1 \= Vertex2.

coordinate(X, Y) :- integer(X), integer(Y), X >= 0, Y >= 0.

position(Vertex, X, Y) :- vertex(Vertex), coordinate(X, Y).

grid(SizeX, SizeY) :- integer(SizeX), integer(SizeY), SizeX > 0, SizeY > 0.

scale(ScaleX, ScaleY) :- integer(ScaleX), integer(ScaleY), ScaleX > 0, ScaleY > 0.

% !- Define drawing canva
ascii_position(Char) :- char_code(Char, Code), Code >= 32, Code =< 126.

canva_size(SizeX, SizeY) :- grid(SizeX, SizeY).

canva(SizeX, SizeY, List) :-
    canva_size(SizeX, SizeY),
    is_list(List).

% canva_set('A', canva(2, 2, [' ',' ',' ',' ']), coordinate(0,0), X). % X = canva(2, 2, ['A', ' ', ' ', ' ']).
% canva_set('B', canva(2, 2, ['A', ' ', ' ', ' ']), coordinate(1,0), X). % X = canva(2, 2, ['A', 'B', ' ', ' ']).
% canva_set('B', canva(2, 2, ['A', 'C', ' ', ' ']), coordinate(1,0), X). % X = canva(2, 2, ['A', 'B', ' ', ' ']).
% canva_set('B', canva(2, 2, ['A', 'C', ' ', ' ']), coordinate(2,0), X). % false
canva_set(Char, Canva, Coord, New_Canva) :-
    ascii_position(Char),
    Coord = coordinate(X, Y),
    Canva = canva(SizeX, SizeY, List),
    0 =< X, X < SizeX,
    0 =< Y, Y < SizeY,
    N is Y * SizeX + X + 1,
    replace_nth(List, N, Char, New_List),
    New_Canva = canva(SizeX, SizeY, New_List), !.

% canva_get(Char, canva(2, 2, ['A', 'B', ' ', ' ']), coordinate(0,0)). % Char = 'A'.
canva_get(Char, Canva, Coord) :-
    Coord = coordinate(X, Y),
    Canva = canva(SizeX, SizeY, List),
    0 =< X, X < SizeX,
    0 =< Y, Y < SizeY,
    N is Y * SizeX + X + 1,
    nth1(N, List, Char), !.

create_canva(SizeX, SizeY, Canva) :-
    Total is SizeX * SizeY,
    create_empty_list(Total, Empty_List),
    Canva = canva(SizeX, SizeY, Empty_List),
    !.

print_canva(Canva) :-
    Canva = canva(SizeX, SizeY, List),
    print_canva_rows(List, SizeX, SizeY, 0),
    !.

print_canva_rows(_, _, SizeY, SizeY) :- !.

print_canva_rows(List, SizeX, SizeY, Y) :-
    print_canva_row(List, SizeX, 0),
    skip_row(List, SizeX, RestList),
    Next_Y is Y + 1,
    nl,
    print_canva_rows(RestList, SizeX, SizeY, Next_Y),
    !.

print_canva_row(_, SizeX, SizeX) :- !.
print_canva_row([Char|Rest], SizeX, Count) :-
    write(Char),
    NextCount is Count + 1,
    print_canva_row(Rest, SizeX, NextCount),
    !.

skip_row(List, 0, List) :- !.
skip_row([_|Rest], N, Result) :-
    NextN is N - 1,
    skip_row(Rest, NextN, Result),
    !.


% !- Define list operations
append([], List, List).
append([Head|Tail], List, [Head|Result]) :- append(Tail, List, Result).

member(Element, [Element|_]).
member(Element, [_|Tail]) :- member(Element, Tail).

n_member(Element, List, N) :-
    N1 is N + 1,
    nth1(N1, List, Element).

member_coordinate(Vertex, Positions, Coord) :-
    member(position(Vertex, X, Y), Positions),
    Coord = coordinate(X, Y), !.

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

replace_nth([_|Tail], 1, Elem, [Elem|Tail]).
replace_nth([Head|Tail], N, Elem, [Head|New_Tail]) :-
    N > 1,
    N1 is N - 1,
    replace_nth(Tail, N1, Elem, New_Tail), !.

% create_empty_list(50, List).
create_empty_list(0, []) :- !.
create_empty_list(N, [' '|Rest]) :-
    N > 0,
    N1 is N - 1,
    create_empty_list(N1, Rest).

% subtract list from list
% subtract([1,2,3], [2,4], Result). % Result = [1,3].
subtract([], _, []) :- !.
subtract([H|T], L2, Result) :-
    member(H, L2), !,
    subtract(T, L2, Result).
subtract([H|T], L2, [H|Result]) :-
    subtract(T, L2, Result).

% list intersection
% list_intersection([1,2,3], [2,3,4], Result). % Result = [2,3].
list_intersection([], _, []) :- !.
list_intersection([H|T], L2, [H|Result]) :-
    member(H, L2), !,
    list_intersection(T, L2, Result).
list_intersection([_|T], L2, Result) :-
    list_intersection(T, L2, Result).

% exclude last element
% exclude_last([1,2,3], Result). % Result = [1,2].
exclude_last([_], []) :- !.
exclude_last([H|T], [H|Result]) :-
    exclude_last(T, Result).

% !- Printer
print(Data) :-
    printer(Data),
    nl.

% Base case: empty list
printer([]) :- !.

% Single element (last in list)
printer([H]) :-
    is_list(H), !,
    write('['),
    printer(H),
    write(']').
printer([H]) :-
    compound(H), !,
    H =.. [Functor|Args],
    write(Functor), write('('),
    printer(Args),
    write(')').
% Handle character atoms - print without quotes
printer([H]) :-
    atom(H), !,
    write(H).  % Just write the atom directly
printer([H]) :-
    !, write(H).

% Multiple elements: head is a list
printer([H|T]) :-
    T \= [], is_list(H), !,
    write('['),
    printer(H),
    write('], '),
    printer(T).

% Multiple elements: head is compound
printer([H|T]) :-
    T \= [], compound(H), !,
    H =.. [Functor|Args],
    write(Functor), write('('),
    printer(Args),
    write('), '),
    printer(T).

% Multiple elements: head is an atom (character)
printer([H|T]) :-
    T \= [], atom(H), !,
    write(H), write(', '),
    printer(T).

% Multiple elements: head is atomic (non-atom)
printer([H|T]) :-
    T \= [],
    write(H), write(', '),
    printer(T).


% Graph Layout Solver Test Cases

% Test 1: Simple Linear Chain (4 vertices)
% try([v1, v2, v3, v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4)], grid(4,4), Positions).

% Test 2: Triangle (3 vertices, cycle)
% try([a, b, c], [edge(a, b), edge(b, c), edge(c, a)], grid(3,3), Positions).

% Test 3: Star Graph (center with 4 branches)
% try([center, n1, n2, n3, n4], [edge(center, n1), edge(center, n2), edge(center, n3), edge(center, n4)], grid(5,5), Positions).

% Test 4: Square (4 vertices in a cycle)
% try([v1, v2, v3, v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4), edge(v4, v1)], grid(4,4), Positions).

% Test 5: Y-shape (branching)
% try([root, left, right, stem], [edge(root, left), edge(root, right), edge(root, stem)], grid(4,4), Positions).

% Test 6: Longer path (6 vertices)
% try([p1, p2, p3, p4, p5, p6], [edge(p1, p2), edge(p2, p3), edge(p3, p4), edge(p4, p5), edge(p5, p6)], grid(6,6), Positions).

% Test 7: Diamond shape
% try([top, left, right, bottom], [edge(top, left), edge(top, right), edge(left, bottom), edge(right, bottom)], grid(4,4), Positions).

% Test 8: Small cross (plus sign)
% try([c, n, s, e, w], [edge(c, n), edge(c, s), edge(c, e), edge(c, w)], grid(5,5), Positions).
% ?- Entry point for trying to solve and display a graph
try(Vertices, Edges, Grid, Positions) :-
    solve(Vertices, Edges, Grid, 100, Positions, scale(4,4)),
    display(Vertices, Edges, Positions, Grid, scale(4,4), 3).

try(Vertices, Edges, Grid, Positions, Depth_Limit, Scale, Name_Limit) :-
    solve(Vertices, Edges, Grid, Depth_Limit, Positions, Scale),
    display(Vertices, Edges, Positions, Grid, Scale, Name_Limit).


% !- Debug predicate
start :- test_k33.
    
start.


% ! K3,3 Test
test_k33 :-
    Vertices = [a1,a2,a3,b1,b2,b3],
    Edges = [
        edge(a1,b1), edge(a1,b2), edge(a1,b3),
        edge(a2,b1), edge(a2,b2), edge(a2,b3),
        edge(a3,b1), edge(a3,b2), edge(a3,b3)
    ],
    Grid = grid(6,6),
    Limit = 1000,
    solve(Vertices, Edges, Grid, Limit, Positions),
    writeln('K3,3 positions:'),
    print(Positions).


% ! K5 Test
test_k5 :-
    Vertices = [v1,v2,v3,v4,v5],
    Edges = [
        edge(v1,v2), edge(v1,v3), edge(v1,v4), edge(v1,v5),
        edge(v2,v3), edge(v2,v4), edge(v2,v5),
        edge(v3,v4), edge(v3,v5),
        edge(v4,v5)
    ],
    Grid = grid(5,5),
    Limit = 1000,
    solve(Vertices, Edges, Grid, Limit, Positions),
    writeln('K5 positions:'),
    print(Positions).


% ! Large Tree Test (binary tree, 7 nodes)
test_large_tree :-
    Vertices = [a,b,c,d,e,f,g],
    Edges = [
        edge(a,b), edge(a,c),
        edge(b,d), edge(b,e),
        edge(c,f), edge(c,g)
    ],
    Grid = grid(5,5),
    Limit = 1000,
    solve(Vertices, Edges, Grid, Limit, Positions),
    writeln('Large tree positions:'),
    print(Positions).


% ! Large outerplanar graph test (8 nodes)
test_outerplanar :-
    Vertices = [v1,v2,v3,v4,v5,v6,v7,v8],
    Edges = [
        % outer cycle
        edge(v1,v2), edge(v2,v3), edge(v3,v4), edge(v4,v5),
        edge(v5,v6), edge(v6,v7), edge(v7,v8), edge(v8,v1),
        % chords for triangulation
        edge(v1,v3), edge(v1,v4),
        edge(v4,v6), edge(v4,v7),
        edge(v7,v1)
    ],
    Grid = grid(8,8),
    Limit = 1500,
    solve(Vertices, Edges, Grid, Limit, Positions),
    writeln('Outerplanar graph positions:'),
    print(Positions).


% ?- /\/\/\/\
solve(Vertices, Edges, Grid, Limit, Positions, Scale) :-
    search_positions(0, Vertices, Edges, Grid, Limit, 0, [], Positions, Scale).


% ?- /\/\/\/\
% search_positions(0, [v1, v2, v3, v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4)], grid(2,1), 10, 0, [], Result).
% search_positions(0, [v1, v2, v3, v4, v5], [edge(v1,v2), edge(v1,v3), edge(v1,v4), edge(v1,v5), edge(v2,v3), edge(v2,v4), edge(v2,v5), edge(v3,v4), edge(v3,v5), edge(v4,v5)], grid(5,5), 100, 0, [], Result).
search_positions(_, _, _, _, Limit, Depth, _, _, _) :-
    Depth > Limit,
    !, 
    fail.

search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, Acc, Positions, Scale) :-
    length(Vertices, Num_Vertices),
    Vertex_Index = Num_Vertices, 
    not(has_crossings(Edges, Acc, Scale)),
    !,
    Positions = Acc.

search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, Acc, Positions, Scale) :-
    !,
    Next_Depth is Depth + 1,
    t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Next_Depth, 0, Acc, Positions, Scale).

% t_search_positions(0, [v1, v2, v3, v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4)], grid(4,4), 10, 0, 0, [], Result). % 
t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Acc, Result, Scale) :-
    Grid = grid(SizeX, SizeY),
    X < SizeX,
    tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, 0, Acc, Result, Scale).

t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Acc, Result, Scale) :-
    Grid = grid(SizeX, SizeY),
    X < SizeX,
    Next_X is X + 1,
    !,
    t_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, Next_X, Acc, Result, Scale).

% tt_search_positions(0, [v1, v2, v3, v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4)], grid(4,4), 10, 0, 0, 0, [], Result). % 
tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Y, Acc, Result, Scale) :-
    Grid = grid(SizeX, SizeY),
    Y < SizeY,
    position_occupied(X, Y, Acc), 
    !,
    Next_Y is Y + 1,
    tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Next_Y, Acc, Result, Scale).

tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Y, Acc, Result, Scale) :-
    Grid = grid(SizeX, SizeY),
    Y < SizeY,
    n_member(Vertex, Vertices, Vertex_Index),
    New_Positions = [position(Vertex, X, Y) | Acc],
    vertex_on_edge(Vertex, coordinate(X, Y), Edges, New_Positions),
    !,
    Next_Y is Y + 1,
    tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Next_Y, Acc, Result, Scale).

tt_search_positions(Vertex_Index, Vertices, Edges, Grid, Limit, Depth, X, Y, Acc, Result, Scale) :-
    Grid = grid(SizeX, SizeY),
    Y < SizeY,
    !,
    n_member(Vertex, Vertices, Vertex_Index),
    New_Positions = [position(Vertex, X, Y) | Acc],
    get_positioned_edges(Edges, New_Positions, Positioned_Edges_Result),
    not(has_crossings(Positioned_Edges_Result, New_Positions, Scale)),
    Next_Vertex_Index is Vertex_Index + 1,
    search_positions(Next_Vertex_Index, Vertices, Edges, Grid, Limit, Depth, New_Positions, Result, Scale).


% ?- /\/\/\/\
% position_occupied(1, 2, [position(v1,1,2), position(v2,0,0)]). % true
% position_occupied(2, 2, [position(v1,1,2), position(v2,0,0)]). % false
% position_occupied(0, 0, [position(v1,1,2), position(v2,0,0)]). % false
% position_occupied(0, 1, []). % false
position_occupied(X, Y, Positions) :- member(position(_, X, Y), Positions), !.


% ?- /\/\/\/\
% get_positioned_edges([edge(v1, v2), edge(v2, v3)], [position(v1,0,0), position(v2,1,1)], Result). % Result = [edge(v1, v2)].
% get_positioned_edges([], [position(v1,0,0), position(v2,1,1)], Result). % Result = [].
% get_positioned_edges([edge(v1, v2), edge(v2, v3)], [], Result). % Result = [].
% get_positioned_edges([], [], Result). % Result = [].
get_positioned_edges(Edges, Positions, Result) :-
    !,
    t_get_positioned_edges(Edges, Positions, [], Result).

t_get_positioned_edges([], _, Result, Result) :- !.

t_get_positioned_edges([edge(Vertex1, Vertex2)|Edges], Positions, Acc, Result) :-
    member(position(Vertex1, _, _), Positions),
    member(position(Vertex2, _, _), Positions),
    !,
    t_get_positioned_edges(Edges, Positions, [edge(Vertex1, Vertex2)|Acc], Result).

t_get_positioned_edges([_|Edges], Positions, Acc, Result) :-
    !,
    t_get_positioned_edges(Edges, Positions, Acc, Result).

% ?- /\/\/\/\
% has_crossings([edge(v1, v2), edge(v2, v3)], [position(v1,0,0), position(v2,1,1), position(v3,0,1)]). % false
% has_crossings([edge(v1, v2), edge(v2, v3)], [position(v1,0,0), position(v2,1,1), position(v3,2,2)]). % false
% has_crossings([edge(v1, v2), edge(v2, v3), edge(v1, v3)], [position(v1,0,0), position(v2,1,1), position(v3,0,1)]). % false
% has_crossings([], [position(v1,0,0), position(v2,1,1), position(v3,0,1)]). % false

% Diagonal crossing in the middle
% has_crossings([edge(v1, v2), edge(v3, v4)], [position(v1,0,0), position(v2,2,2), position(v3,0,2), position(v4,2,0)]). % true

% X-pattern crossing
% has_crossings([edge(v1, v3), edge(v2, v4)], [position(v1,0,0), position(v2,0,2), position(v3,2,2), position(v4,2,0)]). % true

% Multiple edges, one crossing
% has_crossings([edge(v1, v2), edge(v3, v4), edge(v5, v6)], [position(v1,0,0), position(v2,4,0), position(v3,2,1), position(v4,2,-1), position(v5,5,0), position(v6,6,0)]). % true

% Horizontal and vertical crossing
% has_crossings([edge(v1, v2), edge(v3, v4)], [position(v1,0,1), position(v2,4,1), position(v3,2,0), position(v4,2,3)]). % true

% Complex star pattern with multiple crossings
% has_crossings([edge(v1, v3), edge(v2, v4), edge(v1, v4)], [position(v1,0,0), position(v2,0,2), position(v3,2,2), position(v4,2,0)]). % true
has_crossings(Edges, Positions, Scale) :-
    t_has_crossings(Edges, Positions, Scale),
    !.

t_has_crossings([edge(Vertex1, Vertex2)|Rest_Edges], Positions, Scale) :-
    tt_has_crossings_inner(Vertex1, Vertex2, Rest_Edges, Positions, Scale),
    !.
% optimization, above did not used to have cut

t_has_crossings([edge(Vertex1, Vertex2)|Rest_Edges], Positions, Scale) :-
    !,
    t_has_crossings(Rest_Edges, Positions, Scale).
% optimization, above did not used to have cut, it used not(tt_has_crossings_inner(...))

tt_has_crossings_inner(Vertex1, Vertex2, [edge(Vertex3, Vertex4)|Rest_Edges], Positions, Scale) :-
    member_coordinate(Vertex1, Positions, Coord1),
    member_coordinate(Vertex2, Positions, Coord2),
    member_coordinate(Vertex3, Positions, Coord3),
    member_coordinate(Vertex4, Positions, Coord4),
    helper_crossing(Coord1, Coord2, Coord3, Coord4, Scale),
    !.
% optimization, above did not used to have cut

tt_has_crossings_inner(Vertex1, Vertex2, [edge(Vertex3, Vertex4)|Rest_Edges], Positions, Scale) :-
    !,
    tt_has_crossings_inner(Vertex1, Vertex2, Rest_Edges, Positions, Scale).
% optimization, above did not used to have cut, it used not(segments_intersect(...))


% ?- /\/\/\/\
helper_crossing(Coord1, Coord2, Coord3, Coord4, Scale) :-
    segments_intersect(Coord1, Coord2, Coord3, Coord4),
    !.

helper_crossing(Coord1, Coord2, Coord3, Coord4, Scale) :-
    edges_overlap(Coord1, Coord2, Coord3, Coord4, Scale),
    !.


% ?- /\/\/\/\
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(1,4), coordinate(4,1)). % true
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(1,2), coordinate(2,1)). % true
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(2,2), coordinate(3,3)). % true
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(0,0), coordinate(5,5)). % true
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(5,5), coordinate(6,6)). % false
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(4,4), coordinate(5,5)). % false
% segments_intersect(coordinate(1,1), coordinate(4,4), coordinate(0,0), coordinate(1,1)). % false
segments_intersect(Coord1, Coord2, Coord1, Coord3) :- !, fail.
segments_intersect(Coord1, Coord2, Coord3, Coord1) :- !, fail.
segments_intersect(Coord1, Coord2, Coord2, Coord3) :- !, fail.
segments_intersect(Coord1, Coord2, Coord3, Coord2) :- !, fail.

% General case
segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),
    O1 \= O2,
    O3 \= O4,
    !.

% Special Cases - Collinear points
segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),
    
    O3 = collinear,
    on_segment(Coord1, Coord3, Coord2),
    !.

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord1, Coord4, Coord2),
    !.

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord3, Coord1, Coord4),
    !.

segments_intersect(Coord1, Coord2, Coord3, Coord4) :-
    t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
        O1, O2, O3, O4),

    O3 = collinear,
    on_segment(Coord3, Coord2, Coord4),
    !.

t_segments_orientation(Coord1, Coord2, Coord3, Coord4,
    O1, O2, O3, O4) :-
    orientation(Coord1, Coord2, Coord3, O1),
    orientation(Coord1, Coord2, Coord4, O2),
    orientation(Coord3, Coord4, Coord1, O3),
    orientation(Coord3, Coord4, Coord2, O4).


% ?- /\/\/\/\
% orientation(coordinate(0,0), coordinate(4,4), coordinate(1,2), Result). Result = counterclockwise.
% orientation(coordinate(0,0), coordinate(4,4), coordinate(2,2), Result). Result = collinear.
% orientation(coordinate(0,0), coordinate(4,4), coordinate(3,2), Result). Result = clockwise.
orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), collinear) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val = 0,
    !.

orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), clockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val > 0,
    !.

orientation(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY), counterclockwise) :-
    Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
    Val < 0,
    !.

% ?- /\/\/\/\
% on_segment(coordinate(0,0), coordinate(2,2), coordinate(4,4)). % true
% on_segment(coordinate(0,0), coordinate(5,5), coordinate(4,4)). % false
% on_segment(coordinate(0,0), coordinate(4,4), coordinate(4,4)). % true
% on_segment(coordinate(0,0), coordinate(0,0), coordinate(4,4)). % true
% on_segment(coordinate(0,0), coordinate(2,3), coordinate(4,4)). % true
on_segment(coordinate(PX, PY), coordinate(QX, QY), coordinate(RX, RY)) :-
    QX =< max(PX, RX), QX >= min(PX, RX),
    QY =< max(PY, RY), QY >= min(PY, RY).


% ?- /\/\/\/\
% vertex_on_edge(v1, coordinate(2,2), [edge(v1,v2), edge(v2,v3)], [position(v1,2,2), position(v2,4,4), position(v3,0,4)]). % false
% vertex_on_edge(v2, coordinate(4,4), [edge(v1,v2), edge(v2,v3)], [position(v1,0,0), position(v2,4,4), position(v3,0,4)]). % false
% vertex_on_edge(v1, coordinate(3,3), [edge(v1,v2)], [position(v1,0,0), position(v2,4,4), position(v3,3,3)]). % true
% vertex_on_edge(v2, coordinate(2,0), [edge(v1,v2), edge(v3,v4)], [position(v1,2,4), position(v2,2,0), position(v3,0,0), position(v4,4,0)]). % true
vertex_on_edge(Vertex, Coord, Edges, Positions) :-
    t_vertex_on_edge(Vertex, Coord, Edges, Positions),
    !.

t_vertex_on_edge(_, _, [], _) :- !, fail.

t_vertex_on_edge(Vertex, Coord, [edge(Vertex1, Vertex2)|Rest_Edges], Positions) :-
    Vertex1 = Vertex,
    t_vertex_on_edge(Vertex, Coord, Rest_Edges, Positions),
    !.

t_vertex_on_edge(Vertex, Coord, [edge(Vertex1, Vertex2)|Rest_Edges], Positions) :-
    Vertex2 = Vertex,
    t_vertex_on_edge(Vertex, Coord, Rest_Edges, Positions),
    !.

t_vertex_on_edge(Vertex, Coord, [edge(Vertex1, Vertex2)|Rest_Edges], Positions) :-
    member_coordinate(Vertex1, Positions, Coord1),
    member_coordinate(Vertex2, Positions, Coord2),
    get_line_points(Coord1, Coord2, Points),
    length(Points, Len),
    Len > 2,
    Points = [_|Exclude_First],
    exclude_last(Exclude_First, Exclude_Last),
    member(Coord, Exclude_Last),
    !.

t_vertex_on_edge(Vertex, Coord, [edge(_, _)|Rest_Edges], Positions) :-
    t_vertex_on_edge(Vertex, Coord, Rest_Edges, Positions),
    !.


% ?- /\/\/\/\
% edges_overlap(coordinate(0,0), coordinate(4,4), coordinate(1,1), coordinate(3,3), scale(1,1)). % true
% edges_overlap(coordinate(0,0), coordinate(4,4), coordinate(5,5), coordinate(6,6), scale(1,1)). % false
% edges_overlap(coordinate(0,0), coordinate(4,4), coordinate(0,0), coordinate(4,4), scale(1,1)). % true
% edges_overlap(coordinate(0,0), coordinate(4,4), coordinate(1,1), coordinate(4,4), scale(1,1)). % true
% edges_overlap(coordinate(0,0), coordinate(4,4), coordinate(1,1), coordinate(3,3), scale(1,1)). % true
% edges_overlap(coordinate(0,0), coordinate(1,0), coordinate(0,0), coordinate(3,0), scale(1,1)). % true
edges_overlap(Coord1, Coord2, Coord3, Coord4, Scale) :-
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    Coord3 = coordinate(X3, Y3),
    Coord4 = coordinate(X4, Y4),
    Scale = scale(ScaleX, ScaleY),
    X1S is X1 * ScaleX,
    Y1S is Y1 * ScaleY,
    X2S is X2 * ScaleX,
    Y2S is Y2 * ScaleY,
    X3S is X3 * ScaleX,
    Y3S is Y3 * ScaleY,
    X4S is X4 * ScaleX,
    Y4S is Y4 * ScaleY,
    Scaled_Coord1 = coordinate(X1S, Y1S),
    Scaled_Coord2 = coordinate(X2S, Y2S),
    Scaled_Coord3 = coordinate(X3S, Y3S),
    Scaled_Coord4 = coordinate(X4S, Y4S),

    get_line_points(Scaled_Coord1, Scaled_Coord2, Points1),
    get_line_points(Scaled_Coord3, Scaled_Coord4, Points2),
    list_intersection(Points1, Points2, Shared),

    length(Shared, Len),
    Len > 0,

    shared_endpoints(Scaled_Coord1, Scaled_Coord2, Scaled_Coord3, Scaled_Coord4, Points),
    subtract(Shared, Points, Remaining),
    length(Remaining, Rem_Len),
    Rem_Len > 0,
    !.


% ?- /\/\/\/\
% shared_endpoints(coordinate(0,0), coordinate(4,4), coordinate(1,4), coordinate(1,0), Points). % Points = [].
% shared_endpoints(coordinate(0,0), coordinate(4,4), coordinate(0,0), coordinate(1,0), Points). % Points = [coordinate(0, 0)].
% shared_endpoints(coordinate(0,0), coordinate(4,4), coordinate(0,0), coordinate(0,0), Points). % Points = [coordinate(0, 0)].
% shared_endpoints(coordinate(0,0), coordinate(4,4), coordinate(4,4), coordinate(0,0), Points). % Points = [coordinate(0, 0), coordinate(4, 4)].
shared_endpoints(Coord1, Coord2, Coord3, Coord4, Points) :-
    shared_1(Coord1, Coord2, Coord3, Coord4, Point1),
    shared_2(Coord1, Coord2, Coord3, Coord4, Point2),
    Point1 \= Point2,
    Points = [Point1, Point2],
    !.

shared_endpoints(Coord1, Coord2, Coord3, Coord4, [Point]) :-
    shared_1(Coord1, Coord2, Coord3, Coord4, Point),
    !.

shared_endpoints(Coord1, Coord2, Coord3, Coord4, [Point]) :-
    shared_2(Coord1, Coord2, Coord3, Coord4, Point),
    !.

shared_endpoints(_, _, _, _, []) :- !.

shared_1(Coord1, Coord2, Coord3, Coord4, Point) :-
    Coord1 = Coord3,
    Point = Coord1,
    !.

shared_1(Coord1, Coord2, Coord3, Coord4, Point) :-
    Coord1 = Coord4,
    Point = Coord1,
    !.

shared_2(Coord1, Coord2, Coord3, Coord4, Point) :-
    Coord2 = Coord3,
    Point = Coord2,
    !.

shared_2(Coord1, Coord2, Coord3, Coord4, Point) :-
    Coord2 = Coord4,
    Point = Coord2,
    !.
    

% ?- /\/\/\/\
% get_line_points(coordinate(0,0), coordinate(4,4), Points). % Points = [coordinate(0, 0), coordinate(1, 1), coordinate(2, 2), coordinate(3, 3), coordinate(4, 4)].
get_line_points(Coord1, Coord2, Points) :-
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    Dx is abs(X2 - X1),
    Dy is abs(Y2 - Y1),

    determine_direction(Coord1, Coord2, Dx, Dy, Sx, Sy),

    % Bresenham's line algorithm
    Err is Dx - Dy,
    t_get_line_points(Coord1, Coord2, Dx, Dy, Sx, Sy, Err, [], Points),
    !.

t_get_line_points(Coord1, Coord2, Dx, Dy, Sx, Sy, Err, Acc, Points) :-
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    New_Points = [Coord1 | Acc],
    X1 = X2,
    Y1 = Y2,
    Points = New_Points,
    !.

t_get_line_points(Coord1, Coord2, Dx, Dy, Sx, Sy, Err, Acc, Points) :-
    New_Coord1 = coordinate(New_X, New_Y),
    New_Points = [Coord1 | Acc],
    e_helper(Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_X, New_Y),
    
    t_get_line_points(New_Coord1, Coord2, Dx, Dy, Sx, Sy, New_Err, New_Points, Points),
    !.


% ?- /\/\/\/\
determine_direction(Coord1, Coord2, Dx, Dy, Sx, Sy) :-
    determine_directionX(Coord1, Coord2, Dx, Dy, Sx),
    determine_directionY(Coord1, Coord2, Dx, Dy, Sy),
    !.

determine_directionX(coordinate(X1, Y1), coordinate(X2, Y2), Dx, Dy, Sx) :-
    Sx is 1,
    X2 > X1,
    !.

determine_directionX(coordinate(X1, Y1), coordinate(X2, Y2), Dx, Dy, Sx) :-
    Sx is -1,
    !.

determine_directionY(coordinate(X1, Y1), coordinate(X2, Y2), Dx, Dy, Sy) :-
    Sy is 1,
    Y2 > Y1,
    !.

determine_directionY(coordinate(X1, Y1), coordinate(X2, Y2), Dx, Dy, Sy) :-
    Sy is -1,
    !.


% ?- /\/\/\/\
% determine_char(0, 4, Sx, Sy, Char). % Char = '|'.
% determine_char(4, 0, Sx, Sy, Char). % Char = '-'.
% determine_char(4, 4, 1, 1, Char). % Char = '\'.
% determine_char(4, 4, -1, -1, Char). % Char = '\'.
% determine_char(4, 4, 1, -1, Char). % Char = '/'.
% determine_char(4, 4, -1, 1, Char). % Char = '/'.
determine_char(Dx, Dy, Sx, Sy, Char) :-
    Dx = 0,
    Char = '|',
    !.

determine_char(Dx, Dy, Sx, Sy, Char) :-
    Dy = 0,
    Char = '-',
    !.

determine_char(Dx, Dy, Sx, Sy, Char) :-
    Sx > 0,
    Sy > 0,
    Char = '\\',
    !.

determine_char(Dx, Dy, Sx, Sy, Char) :-
    Sx < 0,
    Sy < 0,
    Char = '\\',
    !.

determine_char(Dx, Dy, Sx, Sy, Char) :-
    Char = '/',
    !.


% ?- /\/\/\/\
e_helper(Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_X, New_Y) :-
    e_helperX(Err, Dx, Dy, Sx, Sy, Coord1, Temp_Err, New_X),
    e_helperY(Temp_Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_Y),
    !.

e_helperX(Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_X) :-
    Coord1 = coordinate(X1, _),
    E2 is 2 * Err,
    E2 > -Dy,
    New_Err is Err - Dy,
    New_X is X1 + Sx,
    !.

e_helperX(Err, Dx, Dy, Sx, Sy, coordinate(X, _), Err, X) :- !.

e_helperY(Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_Y) :-
    Coord1 = coordinate(_, Y1),
    E2 is 2 * Err,
    E2 < Dx,
    New_Err is Err + Dx,
    New_Y is Y1 + Sy,
    !.

e_helperY(Err, Dx, Dy, Sx, Sy, coordinate(_, Y), Err, Y) :- !.


% ?- /\/\/\/\
% draw_line(canva(5,5,[' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ']), New_Canva, coordinate(0,0), coordinate(4,4)).
draw_line(Canva, New_Canva, Coord1, Coord2) :-
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    Dx is abs(X2 - X1),
    Dy is abs(Y2 - Y1),

    determine_direction(Coord1, Coord2, Dx, Dy, Sx, Sy),

    determine_char(Dx, Dy, Sx, Sy, Char),


    % Bresenham's line algorithm
    Err is Dx - Dy,
    t_draw_line(Canva, New_Canva, Coord1, Coord2, Dx, Dy, Sx, Sy, Err, Char).


% t_draw_line(canva(2,2,[' ',' ',' ',' ']), New_Canva, coordinate(0,0), coordinate(1,1), 1, 1, 1, 1, 0, '\\').
t_draw_line(Canva, New_Canva, Coord1, Coord2, Dx, Dy, Sx, Sy, Err, Char) :-
    Canva = canva(SizeX, SizeY, _),
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    0 =< X1, X1 < SizeX,
    0 =< Y1, Y1 < SizeY,
    canva_get(CharAt, Canva, Coord1),
    % CharAt = ' ',
    canva_set(Char, Canva, Coord1, New_Canva),
    X1 = X2,
    Y1 = Y2,
    !.

t_draw_line(Canva, New_Canva, Coord1, Coord2, Dx, Dy, Sx, Sy, Err, Char) :-
    Canva = canva(SizeX, SizeY, _),
    Coord1 = coordinate(X1, Y1),
    Coord2 = coordinate(X2, Y2),
    0 =< X1, X1 < SizeX,
    0 =< Y1, Y1 < SizeY,
    canva_get(CharAt, Canva, Coord1),
    % CharAt == ' ',
    canva_set(Char, Canva, Coord1, Temp_Canva),
    e_helper(Err, Dx, Dy, Sx, Sy, Coord1, New_Err, New_X, New_Y),
    New_Coord1 = coordinate(New_X, New_Y),
    t_draw_line(Temp_Canva, New_Canva, New_Coord1, Coord2, Dx, Dy, Sx, Sy, New_Err, Char).


% ?- /\/\/\/\
draw_edges(Canva, New_Canva, [], _, _, _) :-
    New_Canva = Canva,
    !.

% draw_edges(canva(5,5,[' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ']), New_Canva, [edge(v1, v2)], [position(v1,0,0), position(v2,4,4)], 1, 1).
draw_edges(Canva, New_Canva, [edge(Vertex1, Vertex2)|Rest_Edges], Positions, Scale_X, Scale_Y) :-
    member_coordinate(Vertex1, Positions, coordinate(X1, Y1)),
    member_coordinate(Vertex2, Positions, coordinate(X2, Y2)),

    Scaled_X1 is X1 * Scale_X,
    Scaled_Y1 is Y1 * Scale_Y,
    Scaled_X2 is X2 * Scale_X,
    Scaled_Y2 is Y2 * Scale_Y,

    draw_line(Canva, Temp_Canva, coordinate(Scaled_X1, Scaled_Y1), coordinate(Scaled_X2, Scaled_Y2)),
    draw_edges(Temp_Canva, New_Canva, Rest_Edges, Positions, Scale_X, Scale_Y),
    !.


% ?- /\/\/\/\
% draw_name(canva(5,5,[' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ']), New_Canva, v1, coordinate(0,0), 0, 2).
draw_name(Canva, Newer_Canva, Vertex, coordinate(X, Y), Current_Length, Name_Length) :-
    Current_Length < Name_Length,
    atom_chars(Vertex, [Char|Rest_Chars]),
    canva_set(Char, Canva, coordinate(X, Y), New_Canva),
    New_X is X + 1,
    New_Current_Length is Current_Length + 1,
    atom_chars(New_Vertex, Rest_Chars),
    draw_name(New_Canva, Newer_Canva, New_Vertex, coordinate(New_X, Y), New_Current_Length, Name_Length),
    !.  

% used when either Current_Length >= Name_Length or we reached canva boundary or no more chars left
draw_name(Canva, Canva, _, _, _, _) :-
    !.


% ?- /\/\/\/\
% draw_vertices(canva(5,5,[' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ', ' ',' ',' ',' ',' ']), New_Canva, [v1,v2], [position(v1,0,0), position(v2,3,3)], 1, 1, 3).
draw_vertices(Canva, New_Canva, [], _, _, _, _) :-
    New_Canva = Canva,
    !.

draw_vertices(Canva, New_Canva, [Vertex|Rest_Vertices], Positions, Scale_X, Scale_Y, Name_Length) :-
    member_coordinate(Vertex, Positions, coordinate(X, Y)),
    Scaled_X is X * Scale_X,
    Scaled_Y is Y * Scale_Y,
    draw_name(Canva, Temp_Canva, Vertex, coordinate(Scaled_X, Scaled_Y), 0, Name_Length),
    draw_vertices(Temp_Canva, New_Canva, Rest_Vertices, Positions, Scale_X, Scale_Y, Name_Length),
    !.

  
% ?- /\/\/\/\
% display([v1,v2], [edge(v1,v2)], [position(v1,0,0), position(v2,3,3)], grid(5,5), 1, 1, 3).
% display([v1,v2,v3,v4], [edge(v1, v2), edge(v2, v3), edge(v3, v4)], [position(v4, 0, 1), position(v3, 0, 0), position(v2, 3, 1), position(v1, 3, 0)], grid(4,4), 5, 5, 2).
display(Vertices, Edges, [], Grid, Scale, Name_Length) :-
    print(["No positions to display."]), !.

display(Vertices, Edges, Positions, Grid, Scale, Name_Length) :-
    Grid = grid(SizeX, SizeY),
    Scale = scale(ScaleX, ScaleY),
    Scaled_SizeX is SizeX * ScaleX,
    Scaled_SizeY is SizeY * ScaleY,

    create_canva(Scaled_SizeX, Scaled_SizeY, Empty_Canva),

    print(["========================="]),
    print(["Graph Drawing"]),
    print(["========================="]),
    print([]),

    draw_edges(Empty_Canva, Canva_With_Edges, Edges, Positions, ScaleX, ScaleY),
    draw_vertices(Canva_With_Edges, Final_Canva, Vertices, Positions, ScaleX, ScaleY, Name_Length),

    print_canva(Final_Canva),
    print(["========================="]),
    print(Positions),
    !.


