% Tadas Riksas, Programu sistemos 3 kursas, variantai: 1.7; 2.6; 3.7; 4.8


% 1.7 maxlyg(S,M) - skaičius M - didžiausias lyginis skaičių sąrašo S elementas. Pavyzdžiui:
% ?- maxlyg([4,10,-2,-1,23],M).

% M = 10.

maxlyg([Pirmas | Like], M) :- max(Like, Pirmas, M).

max([], Maksimumas, Maksimumas) :- !, lyginis(Maksimumas). % atkirtimas kad neieškotų toliau

max([Pirmas | Like], Maksimumas, Grazinimas) :-
    lyginis(Pirmas),
    Pirmas > Maksimumas,
    max(Like, Pirmas, Grazinimas).

max([Pirmas | Like], Maksimumas, Grazinimas) :-
    lyginis(Pirmas),
    Pirmas =< Maksimumas, 
    max(Like, Maksimumas, Grazinimas).

lyginis(Skaicius) :- 0 is mod(Skaicius, 2).

% ?- maxlyg([1,3,5], M).
% false.

% ?- maxlyg([2,4,6], M).
% M = 6 ;
% false.

% ?- maxlyg([2], M).
% M = 2.

% ?- maxlyg([], M).
% false.

% ?- maxlyg([], 5).
% false.

% ?- maxlyg(S, 5).
% false.

% ?- maxlyg(S, 6).
% S = [6].


% 2.6 kart(S,K,E) - sąraše S yra K vienas po kito einančių vienodų elementų E. Pavyzdžiui:
% ?- kart([a,a,c,a,b,b,b,b,a,g],4,E).

% E = b.

kart([Pirmas | Like], K, E) :- 
    skaiciuoti_pakartojimus(Like, Pirmas, 1, K, E).



skaiciuoti_pakartojimus(_, Simbolis, Pasikartojimai, ReikalingiPasikartojimai, Grazinimas) :-
    Pasikartojimai == ReikalingiPasikartojimai,
    Grazinimas = Simbolis.

skaiciuoti_pakartojimus([Pirmas | Like], Pirmas, Pasikartojimai, ReikalingiPasikartojimai, Grazinimas) :-
    Pasikartojimai < ReikalingiPasikartojimai,
    Pasikartojimai1 is Pasikartojimai + 1,
    skaiciuoti_pakartojimus(Like, Pirmas, Pasikartojimai1, ReikalingiPasikartojimai, Grazinimas).

skaiciuoti_pakartojimus([Pirmas | Like], Simbolis, Pasikartojimai, ReikalingiPasikartojimai, Grazinimas) :-
    Pirmas \== Simbolis,
    skaiciuoti_pakartojimus(Like, Pirmas, 1, ReikalingiPasikartojimai, Grazinimas).

skaiciuoti_pakartojimus([Pirmas | Like], Simbolis, Pasikartojimai, ReikalingiPasikartojimai, Grazinimas) :-
    Pasikartojimai >= ReikalingiPasikartojimai,
    skaiciuoti_pakartojimus(Like, Pirmas, 1, ReikalingiPasikartojimai, Grazinimas).



% ?- kart([a,a,c,a,b,b,b,b,a,g],4,E).
% E = b ;
% false.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 4, E).
% E = b ;
% false.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 2, E).
% E = a ;
% E = b ;
% E = b ;
% E = c ;
% E = c ;
% false.

% ?- kart([a,a,a,b,b,b,b,c,c,e], X, b).
% EXCEPTION (neinicializuotas kintamasis X)

% ?- kart(X, 3, b).
% X = [b, b, b|_] ;
% X = [_A, _A, _A, b, b, b|_] ;
% X = [_A, _A, _A, _B, _B, _B, b, b, b|...] 

% ?- kart([a,a,b,b], X, Y).
% EXCEPTION (neinicializuotas kintamasis X)


% Seniau veike sitaip, taciau pakeiciau ir dabar nebeveikia. Labai sunku suderinti su kart(X, 3, b). veikimo principu.
% ?- kart([a,a,b,b], X, Y).
% X = 1,
% Y = a ;
% X = 2,
% Y = a ;
% X = 1,
% Y = b ;
% X = 2,
% Y = b ;
% false.


% 3.7 keisti(S,K,R) - duotas sąrašas S. Duotas sąrašas K, nusakantis keitinį ir susidedantis iš elementų pavidalo k(KeiciamasSimbolis, PakeistasSimbolis). R - rezultatas, gautas pritaikius sąrašui S keitinį K. Pavyzdžiui:
% ?- keisti([a,c,b],[k(a,x),k(b,y)],R).

% R = [x,c,y].

keisti(Sarasas, Keitiniai, Rezultatas) :- keitimas(Sarasas, Keitiniai, Rezultatas).

keitimas([Pirmas | Like], K, [Pakeistas | Resto]) :-
    paieska_keitimo(Pirmas, K, Pakeistas),
    keitimas(Like, K, Resto).

paieska_keitimo(Simbolis, [k(Taisykle, Pakeitimas) | Like], Pakeistas) :-
    Simbolis == Taisykle,
    Pakeistas = Pakeitimas.

paieska_keitimo(Simbolis, [k(Taisykle, _) | Like], Pakeistas) :-
    Simbolis \== Taisykle,
    paieska_keitimo(Simbolis, Like, Pakeistas).
    

% 4.8 skirt(S1,S2,Skirt) - S1 ir S2 yra skaičiai, vaizduojami skaitmenų sąrašais. Skirt - tų skaičių skirtumas, vaizduojamas skaitmenų sąrašu. Laikykite, kad S1 yra ne mažesnis už S2. Pavyzdžiui:
% ?- skirt([9,4,6,1,2,8],[3,4],Skirt).

% Skirt = [9,4,6,0,9,4].


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