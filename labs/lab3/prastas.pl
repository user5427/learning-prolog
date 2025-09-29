
i_skaiciu([], 0).
i_skaiciu([H|T], Skaicius) :-
    i_skaiciu(T, Dalis),
    length(T, Ilgis),
    Skaicius is H * 10^Ilgis + Dalis.

is_skaicios(0, [0]).
is_skaicios(Skaicius, Sarasas) :-
    Skaicius > 0,
    is_skaicios_akumuliatyvi(Skaicius, [], Sarasas).

is_skaicios_akumuliatyvi(0, Akumuliatorius, Akumuliatorius).
is_skaicios_akumuliatyvi(Skaicius, Akumuliatorius, Sarasas) :-
    Skaicius > 0,
    Skaicius1 is Skaicius // 10,
    Skaicius2 is Skaicius mod 10,
    is_skaicios_akumuliatyvi(Skaicius1, [Skaicius2 | Akumuliatorius], Sarasas).


skirt(S1, S2, Skirt) :-
    i_skaiciu(S1, Skaicius1),
    i_skaiciu(S2, Skaicius2),
    SkirtasSkaicius is Skaicius1 - Skaicius2,
    is_skaicios(SkirtasSkaicius, Skirt).

% Operacijos su natūraliaisiais skaičiais, išreikštais skaitmenų sąrašais. Skaitmenų sąrašo elementai turi būti natūralūs skaičiai nuo 0 iki 9 (ne simboliai '0', '1',...). Nenaudokite Prolog konvertavimo tarp sąrašo ir skaičiaus predikatų (number_chars/2, number_codes/2 ir kt...):

% Questionable requirements for the task above, maybe rewrite it using simple arithmetics...????