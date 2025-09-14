% Natūralieji skaičiai yra modeliuojami termais nul, s(nul), s(s(nul)),… (žr. paskaitos medžiagą). Apibrėžkite predikatą:
% dviejų skaičių suma lygi trečiajam skaičiui. Pavyzdžiui:
% ?- suma(s(s(s(nul))),s(s(nul)),Sum).

% Sum = s(s(s(s(s(nul))))).


% 
suma(nul, AntrasNarys, AntrasNarys).
suma(s(PirmasNarys), AntrasNarys, s(Suma)) :- suma(PirmasNarys, AntrasNarys, Suma).


% tail recursive
suma_akumuliatyvi(nul, AntrasNarys, AntrasNarys).
suma_akumuliatyvi(s(PirmasNarys), AntrasNarys, Grazinimas) :-
    PadidinasAntrasis = s(AntrasNarys),
    suma_akumuliatyvi(PirmasNarys, PadidinasAntrasis, Grazinimas).