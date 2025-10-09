% Tadas Riksas, Programu sistemos 3 kursas, variantai: 1.7; 2.6; 3.7; 4.8


% 1.7 maxlyg(S,M) - skaičius M - didžiausias lyginis skaičių sąrašo S elementas. Pavyzdžiui:
% ?- maxlyg([4,10,-2,-1,23],M).

% M = 10.

% patikrinti ar pirmas elementas yra lyginis

maxlyg([Pirmas | Like], M) :- not(lyginis(Pirmas)), !, maxlyg(Like, M).
maxlyg([Pirmas | Like], M) :- max(Like, Pirmas, M), !.

max([], Maksimumas, Maksimumas) :- !, lyginis(Maksimumas). % atkirtimas kad neieškotų toliau

max([Pirmas | Like], Maksimumas, Grazinimas) :-
    lyginis(Pirmas),
    Pirmas > Maksimumas,
    !,
    max(Like, Pirmas, Grazinimas).

max([Pirmas | Like], Maksimumas, Grazinimas) :-
    !,
    max(Like, Maksimumas, Grazinimas).

lyginis(Skaicius) :- 0 is mod(Skaicius, 2).

% ?- maxlyg([5, 3, 4, 6], M).
% M = 6.

% ?- maxlyg([5, 3, 4], M).
% M = 4.

% ?- maxlyg([5, 2, 3, 4], M).
% M = 4.

% ?- maxlyg([5, 9, 2, 13, 12, 3, 4], M).
% M = 12.

% ?- maxlyg([3, 4], M).
% M = 4.

% ?- maxlyg([3], M).
% false.

% ?- maxlyg([], M).
% false.

% ?- maxlyg(S, 5).
% EXCEPTION (neinicializuotas kintamasis S)

% ?- maxlyg(S, 6).
% EXCEPTION (neinicializuotas kintamasis S)


% 2.6 kart(S,K,E) - sąraše S yra K vienas po kito einančių vienodų elementų E. Pavyzdžiui:
% ?- kart([a,a,c,a,b,b,b,b,a,g],4,E).

% E = b.

kart([Pirmas | Like], ReikalingiPasikartojimai, Simbolis) :- 
    skaiciuoti_pakartojimus(Like, Pirmas, 1, ReikalingiPasikartojimai, Simbolis).


tikrinti(Like, Pirmas, 1, Pasikartojimai) :-
    skaiciuoti_pakartojimus(Like, Pirmas, 1, Pasikartojimai, _), !.

skaiciuoti_pakartojimus([], Simbolis, Pasikartojimai, Pasikartojimai, Simbolis) :- !.

skaiciuoti_pakartojimus([Pirmas|Like], Simbolis, Pasikartojimai, Pasikartojimai, Simbolis) :- 
    tikrinti(Like, Pirmas, 1, Pasikartojimai).

skaiciuoti_pakartojimus([Pirmas|Like], Simbolis, Pasikartojimai, Pasikartojimai, Simbolis) :- 
    not(tikrinti(Like, Pirmas, 1, Pasikartojimai)), 
    !.
    
skaiciuoti_pakartojimus([Pirmas | Like], Pirmas, Pasikartojimai, ReikalingiPasikartojimai, Grazinimas) :-
    Pasikartojimai < ReikalingiPasikartojimai,
    Pasikartojimai1 is Pasikartojimai + 1,
    !,
    skaiciuoti_pakartojimus(Like, Pirmas, Pasikartojimai1, ReikalingiPasikartojimai, Grazinimas).

skaiciuoti_pakartojimus([Pirmas | Like], _, _, ReikalingiPasikartojimai, Grazinimas) :-
    !,
    skaiciuoti_pakartojimus(Like, Pirmas, 1, ReikalingiPasikartojimai, Grazinimas).


% ?- kart([a,a,c,a,b,b,b,b,a,g],4,E).
% E = b.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 4, E).
% E = b.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 40, E).
% false.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 0, E).
% false.

% ?- kart([a,a,a,b,b,b,b,c,c,e], 2, E).
% E = a ;
% E = b ;
% E = b ;
% E = c.

% ?- kart([a,a,a,b,b,b,b,c,c,e], X, b).
% EXCEPTION (neinicializuotas kintamasis X)

% ?- kart(X, 3, b).
% X = [b, b, b].

% ?-  kart(X,3,Y).
% X = [Y, Y, Y].

% ?- kart([a,a,b,b], X, Y).
% EXCEPTION (neinicializuotas kintamasis X)


% 3.7 keisti(S,K,R) - duotas sąrašas S. Duotas sąrašas K, nusakantis keitinį ir
% susidedantis iš elementų pavidalo k(KeiciamasSimbolis, PakeistasSimbolis). R -
% rezultatas, gautas pritaikius sąrašui S keitinį K. Pavyzdžiui: ?-
% keisti([a,c,b],[k(a,x),k(b,y)],R).

% R = [x,c,y].

keisti([], _, []).
keisti([Pirmas | Like], K, [Pakeistas | Resto]) :-
    is_list(K),
    paieska_keitimo(Pirmas, K, Pakeistas, _),
    keisti(Like, K, Resto).

tikrinti_keitima(Simbolis, Like) :- 
    paieska_keitimo(Simbolis, Like, Pakeista, pakeistas), 
    !.

paieska_keitimo(Simbolis, [], Simbolis, nepakeistas) :- 
    !.

paieska_keitimo(Simbolis, [k(Simbolis, Pakeistas) | LikeKeitiniai], Pakeistas, pakeistas) :- 
    not(tikrinti_keitima(Simbolis, LikeKeitiniai)),
    !.

paieska_keitimo(Simbolis, [k(Simbolis, Pakeistas) | LikeKeitiniai], Pakeistas, pakeistas) :-
    tikrinti_keitima(Simbolis, LikeKeitiniai).

paieska_keitimo(Simbolis, [k(_, _) | Like], Pakeitimas, Keisti) :-
    !,
    paieska_keitimo(Simbolis, Like, Pakeitimas, Keisti).


% ?- keisti([a,c,b],[k(a,x),k(a,y),k(c,g)],R).
% R = [x, g, b] ;
% R = [y, g, b].

% ?- keisti([a,c,b],[k(a,x),k(b,y)],R).
% R = [x, c, y].

% ?- keisti([a,c,b],[k(a,x),k(a,y),k(a,a)],R).
% R = [x, c, b] ;
% R = [y, c, b] ;
% R = [a, c, b].

% ?- keisti([a,c,b],X,[x, c, y]).
% false.

% ?- keisti(X,[k(a,x),k(b,y)],[x, c, y]).
% X = [a, c, b].

% ?- keisti(X,U,[x, c, y]).
% false.

% 4.8 skirt(S1,S2,Skirt) - S1 ir S2 yra skaičiai, vaizduojami skaitmenų
% sąrašais. Skirt - tų skaičių skirtumas, vaizduojamas skaitmenų sąrašu.
% Laikykite, kad S1 yra ne mažesnis už S2. Pavyzdžiui: ?-
% skirt([9,4,6,1,2,8],[3,4],Skirt).

% Skirt = [9,4,6,0,9,4].

% ?
skirt(PirmasSarasas, AntrasSarasas, Skirt) :-
    apsukti(PirmasSarasas, PirmasApsuktas),
    islyginti(PirmasApsuktas, AntrasSarasas, AntrasIslygintas),
    apsukti(AntrasIslygintas, AntrasIslygintasApsuktas),
    skirtumas_akum(PirmasApsuktas, AntrasIslygintasApsuktas, [], Skirtumas),
    panaikinti_nulius_priekyje(Skirtumas, Skirt), !.

skirtumas_akum([], [], Rezultatas, Rezultatas).
skirtumas_akum(PirmasSarasas, [AntrasSkaitmuo|LikeAntri], Akumuliatorius, Rezultatas) :-
    atimti_skaitmeni(PirmasSarasas, AntrasSkaitmuo, [Rez|LikePirmiApdoroti]),
    skirtumas_akum(LikePirmiApdoroti, LikeAntri, [Rez|Akumuliatorius], Rezultatas).

% ?
apsukti(Sarasas, Rezultatas) :-
    apsukti_akum(Sarasas, [], Rezultatas).

apsukti_akum([], Rezultatas, Rezultatas).
apsukti_akum([Elementas|Like], Kaupiamas, Rezultatas) :-
    apsukti_akum(Like, [Elementas|Kaupiamas], Rezultatas).


% ?
saraso_ilgis(Sarasas, Ilgis) :-
    saraso_ilgis_akum(Sarasas, 0, Ilgis).

saraso_ilgis_akum([], Akumuliatorius, Akumuliatorius).
saraso_ilgis_akum([_|Like], Akumuliatorius, Rezultatas) :-
    NaujasAkumuliatorius is Akumuliatorius + 1,
    saraso_ilgis_akum(Like, NaujasAkumuliatorius, Rezultatas).


% ?
islyginti(PirmasSarasas, AntrasSarasas, Rezultatas) :- 
    saraso_ilgis(PirmasSarasas, PirmoIlgis),
    saraso_ilgis(AntrasSarasas, AntroIlgis),
    Skirtumas is PirmoIlgis - AntroIlgis,
    islyginti_akum(AntrasSarasas, Skirtumas, [], Rezultatas).

islyginti_akum(AntrasSarasas, 0, Kaupiamas, Rezultatas) :-
    sujungti_sarasus(Kaupiamas, AntrasSarasas, Rezultatas).

islyginti_akum(AntrasSarasas, Skirtumas, Kaupiamas, Rezultatas) :-
    Skirtumas > 0,
    NaujasSkirtumas is Skirtumas - 1,
    islyginti_akum(AntrasSarasas, NaujasSkirtumas, [0|Kaupiamas], Rezultatas).


% ?
sujungti_sarasus([], Sarasas, Sarasas).
sujungti_sarasus([Pirmas|LikePirmi], Sarasas, [Pirmas|LikePirmiSujungtas]) :-
    sujungti_sarasus(LikePirmi, Sarasas, LikePirmiSujungtas).


% ?
atimti_skaitmeni(Pirmas, Skaitmuo, Rezultatas) :-
    atimti_skaitmeni_akum(Pirmas, Skaitmuo, [], Rezultatas).

atimti_skaitmeni_akum([Pirmas|LikePirmi], Skaitmuo, Kaupiamas, Rezultatas) :-
    Pirmas >= Skaitmuo,
    Atimtis is Pirmas - Skaitmuo,
    apsukti([Atimtis|Kaupiamas], KaupiamasApsuktas),
    sujungti_sarasus(KaupiamasApsuktas, LikePirmi, Rezultatas).
                                          
atimti_skaitmeni_akum([Pirmas|LikePirmi], Skaitmuo, Kaupiamas, Rezultatas) :-
    Pirmas < Skaitmuo,
    PirmasPaskolintas is Pirmas + 10,
    Atimtis is PirmasPaskolintas - Skaitmuo,
    atimti_skaitmeni_akum(LikePirmi, 1, [Atimtis|Kaupiamas], Rezultatas).

% ?
panaikinti_nulius_priekyje([], []) :- !.
panaikinti_nulius_priekyje([0], [0]) :- !.
panaikinti_nulius_priekyje([0|Like], Rezultatas) :-
    !,
    panaikinti_nulius_priekyje(Like, Rezultatas).
panaikinti_nulius_priekyje([Pirmas|Like], [Pirmas|Like]).


% ?- skirt([9,4,6,1,2,8],[3,4],Skirt).
% Skirt = [9, 4, 6, 0, 9, 4].

% ?- skirt([9,4,6,1,2,8],[3,4],Skirt).
% Skirt = [9, 4, 6, 0, 9, 4].

% ?- skirt([9,4,6,1,2,8],[9,9,0,0,0,0],Skirt).
% false.

%  ?- skirt([9,4,6,1,2,8],[3,4,0,0,0,0,0],Skirt).
% false.

% ?- skirt([5,0,2],X,[5, 0, 0]).
% EXCEPTION (neinicializuotas kintamasis X)

% ?- skirt(X,[3,4],[9, 4, 6, 0, 9, 4]).
% EXCEPTION (neinicializuotas kintamasis X)

% ?- skirt([5, 0], [5, 0], X).
% X = [0].

