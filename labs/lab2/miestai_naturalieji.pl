% Tadas Riksas, Programu sistemos 3 kursas, variantai: 1.5; 6.1


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
kelias(kryžkalnis, klaipėda, 120).
kelias(kryžkalnis, šiauliai, 100).
kelias(kryžkalnis, tauragė, 90).
kelias(klaipėda, palanga, 30).
kelias(panevežys, biržai, 70).


% duotas miestus jungiančių kelių tinklas. keliai vienakrypčiai, nesudarantys ciklų. kiekvienas kelias turi savo ilgį. ši informacija išreiškiama faktais kelias(miestas1, miestas2, atstumas). apibrėžkite predikatą „galima nuvažiuoti iš miesto X į miestą Y“:
% 1.5 pravažiavus lygiai N tarpinių miestų.
nuvaziuoti(PradinisMiestas, GalutinisMiestas, 0) :- kelias(PradinisMiestas, GalutinisMiestas, _).
nuvaziuoti(PradinisMiestas, GalutinisMiestas, SkaiciusTarpininku) :-
    SkaiciusTarpininku > 0,
    kelias(PradinisMiestas, TarpinisMiestas, _),
    SumazintasSkaicius is SkaiciusTarpininku - 1,
    nuvaziuoti(TarpinisMiestas, GalutinisMiestas, SumazintasSkaicius).


% ?- nuvaziuoti(vilnius, X, 4).
% X = telšiai ;
% X = telšiai ;
% X = klaipėda ;
% X = plungė ;
% X = mažeikiai ;
% X = plungė ;
% X = mažeikiai ;
% false.


% ?- nuvaziuoti(vilnius, telšiai, 4).
% true ;
% true ;
% false.


% ?- nuvaziuoti(palanga, klaipėda, 4).
% false.


% ?- nuvaziuoti(X, klaipėda, 4).
% X = kėdainiai ;
% X = ukmergė ;
% X = kaunas ;
% false.


% ?- nuvaziuoti(X, Y, 6).
% X = vilnius,
% Y = klaipėda ;
% X = vilnius,
% Y = klaipėda ;
% X = vilnius,
% Y = palanga ;
% X = vilnius,
% Y = palanga ;
% X = kaunas,
% Y = palanga ;
% X = kaunas,
% Y = palanga ;
% false.


% Natūralieji skaičiai yra modeliuojami termais nul, s(nul), s(s(nul)),… (žr. paskaitos medžiagą). Apibrėžkite predikatą:
% 6.1 dviejų skaičių suma lygi trečiajam skaičiui. Pavyzdžiui:
% ?- suma(s(s(s(nul))),s(s(nul)),Sum).

% Sum = s(s(s(s(s(nul))))).

% 
suma(nul, AntrasNarys, AntrasNarys).
suma(s(PirmasNarys), AntrasNarys, s(Suma)) :- suma(PirmasNarys, AntrasNarys, Suma).


% ?- suma(nul, s(s(s(nul))), X).
% X = s(s(s(nul))).


% ?- suma(s(nul), s(s(s(nul))), X).
% X = s(s(s(s(nul)))).


% ?- suma(X, s(s(s(nul))), s(s(nul))).
% false.


% ?- suma(X, s(s(s(nul))), s(s(s(s(nul))))).
% X = s(nul) ;
% false.


% ?- suma(X, Y, s(s(s(s(s(s(nul))))))).
% X = nul,
% Y = s(s(s(s(s(s(nul)))))) ;
% X = s(nul),
% Y = s(s(s(s(s(nul))))) ;
% X = s(s(nul)),
% Y = s(s(s(s(nul)))) ;
% X = Y, Y = s(s(s(nul))) ;
% X = s(s(s(s(nul)))),
% Y = s(s(nul)) ;
% X = s(s(s(s(s(nul))))),
% Y = s(nul) ;
% X = s(s(s(s(s(s(nul)))))),
% Y = nul ;
% false.


% another version, a little bit complicated, has some backtracing problems.
% suma_akumuliatyvi(nul, AntrasNarys, AntrasNarys).
% suma_akumuliatyvi(s(PirmasNarys), AntrasNarys, Grazinimas) :-
%     suma_akumuliatyvi(PirmasNarys, s(AntrasNarys), Grazinimas).