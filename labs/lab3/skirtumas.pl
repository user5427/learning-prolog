% 4.8 skirt(S1,S2,Skirt) - S1 ir S2 yra skaičiai, vaizduojami skaitmenų sąrašais. Skirt - tų skaičių skirtumas, vaizduojamas skaitmenų sąrašu. Laikykite, kad S1 yra ne mažesnis už S2. Pavyzdžiui:
% ?- skirt([9,4,6,1,2,8],[3,4],Skirt).

% Skirt = [9,4,6,0,9,4].

apsukti(Sarasas, Rezultatas) :-
    apsukti_akum(Sarasas, [], Rezultatas).

apsukti_akum([], Rezultatas, Rezultatas).
apsukti_akum([Elementas|Like], Kaupiamas, Rezultatas) :-
    apsukti_akum(Like, [Elementas|Kaupiamas], Rezultatas).


islyginti_ir_apsukti(Pirmas, Antras, Rezultatas) :- islyginti_ir_apsukti_akum(Pirmas, Antras, [], Rezultatas).

islyginti_ir_apsukti_akum([], [], Kaupiamas, Kaupiamas).

islyginti_ir_apsukti_akum([Pirmas|LikePirmi], [], Kaupiamas, Rezultatas) :-
    islyginti_ir_apsukti_akum(LikePirmi, [], [0|Kaupiamas], Rezultatas).

islyginti_ir_apsukti_akum([Pirmas|LikePirmi], [Antras|LikeAntri], Kaupiamas, Rezultatas) :-
    islyginti_ir_apsukti_akum(LikePirmi, LikeAntri, [Antras|Kaupiamas], Rezultatas).


sujungti_sarasus([], Sarasas, Sarasas).
sujungti_sarasus([Pirmas|LikePirmi], Sarasas, [Pirmas|LikePirmiSujungtas]) :-
    sujungti_sarasus(LikePirmi, Sarasas, LikePirmiSujungtas).


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


panaikinti_nulius_priekyje([], []).
panaikinti_nulius_priekyje([0], [0]).
panaikinti_nulius_priekyje([0|Like], Rezultatas) :-
    panaikinti_nulius_priekyje(Like, Rezultatas).
panaikinti_nulius_priekyje([Pirmas|Like], [Pirmas|Like]).


skirtumas([], [], []).
skirtumas([Pirmas|LikePirmi], [AntrasSkaitmuo|LikeAntri], [Rez|LikeRez]) :-
    atimti_skaitmeni([Pirmas|LikePirmi], AntrasSkaitmuo, [Rez|LikeApdoroti]),
    skirtumas(LikePirmi, LikeAntri, LikeApdoroti).


skirt(Pirmas, Antras, Skirt) :-
    apsukti(Pirmas, PirmasApsuktas),
    islyginti_ir_apsukti(PirmasApsuktas, Antras, AntrasIslygintasApsuktas),
    skirtumas(PirmasApsuktas, AntrasIslygintasApsuktas, Skirtumas),
    apsukti(Skirtumas, SkirtumasApsuktas),
    panaikinti_nulius_priekyje(SkirtumasApsuktas, Skirt).
