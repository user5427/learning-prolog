% TODO 4.8 skirt(S1,S2,Skirt) - S1 ir S2 yra skaičiai, vaizduojami skaitmenų sąrašais. Skirt - tų skaičių skirtumas, vaizduojamas skaitmenų sąrašu. Laikykite, kad S1 yra ne mažesnis už S2. Pavyzdžiui:
% ?- skirt([9,4,6,1,2,8],[3,4],Skirt).

% Skirt = [9,4,6,0,9,4].

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


% ?
skirt(PirmasSarasas, AntrasSarasas, Skirt) :-
    apsukti(PirmasSarasas, PirmasApsuktas),
    islyginti(PirmasApsuktas, AntrasSarasas, AntrasIslygintas),
    apsukti(AntrasIslygintas, AntrasIslygintasApsuktas),
    skirtumas_akum(PirmasApsuktas, AntrasIslygintasApsuktas, [], Skirtumas),
    panaikinti_nulius_priekyje(Skirtumas, Skirt).

skirtumas_akum([], [], Rezultatas, Rezultatas).
skirtumas_akum(PirmasSarasas, [AntrasSkaitmuo|LikeAntri], Akumuliatorius, Rezultatas) :-
    atimti_skaitmeni(PirmasSarasas, AntrasSkaitmuo, [Rez|LikePirmiApdoroti]),
    skirtumas_akum(LikePirmiApdoroti, LikeAntri, [Rez|Akumuliatorius], Rezultatas).

