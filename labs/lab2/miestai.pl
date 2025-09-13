
kelias(vilnius, kaunas, 105).
kelias(vilnius, trakai, 30).
kelias(trakai, alytus, 70).
kelias(alytus, marijampolė, 55).
kelias(alytus, druskininkai, 35).
kelias(vilnius, ukmergė, 80).
kelias(kaunas, kėdainiai, 50).
kelias(kaunas, ukmergė, 60).
kelias(ukmergė, utena, 75).
kelias(utena, visaginas, 40).
kelias(kėdainiai, panevežys, 65).
kelias(ukmergė, panevežys, 90).
kelias(utena, rokiškis, 85).
kelias(panevežys, šiauliai, 80).
kelias(šiauliai, telšiai, 55).
kelias(telšiai, plungė, 45).
kelias(plungė, klaipėda, 60).
kelias(telšiai, mažeikiai, 50).
kelias(kaunas, kryžkalnis, 150).
kelias(kaunas, marijampolė, 80).
kelias(palanga, klaipėda, 30).
kelias(kryžkalnis, klaipėda, 120).
kelias(kryžkalnis, šiauliai, 100).
kelias(kryžkalnis, tauragė, 90).
kelias(klaipėda, palanga, 30).
kelias(panevežys, biržai, 70).

% duotas miestus jungiančių kelių tinklas. keliai vienakrypčiai, nesudarantys ciklų. kiekvienas kelias turi savo ilgį. ši informacija išreiškiama faktais kelias(miestas1, miestas2, atstumas). apibrėžkite predikatą „galima nuvažiuoti iš miesto X į miestą Y“:
% 1.5 pravažiavus lygiai N tarpinių miestų.
nuvaziuoti(X, Y, 0) :- kelias(X, Y, _).
nuvaziuoti(X, Y, N) :-
    N > 0,
    kelias(X, Z, _),
    N1 is N - 1,
    nuvaziuoti(Z, Y, N1).