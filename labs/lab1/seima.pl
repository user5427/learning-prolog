% Tadas Riksas, Programu sistemos 3 kursas, variantai: 7; 27; 34; 39

% Duomenų bazėje saugomi duomenys apie asmenis ir jų giminystės ryšius

% 1 karta
asmuo(arnoldas, vyras, 85, skaityti).
asmuo(ingrida, moteris, 83, gaminti).

% 2 karta
asmuo(antanas, vyras, 75, skaityti).
asmuo(ona, moteris, 73, gaminti).

asmuo(juozas, vyras, 74, sportuoti).
asmuo(marija, moteris, 72, dainuoti).

asmuo(kotryna, moteris, 70, siuvineti).
asmuo(dainius, vyras, 68, dainuoti).

% 3 karta
asmuo(petras, vyras, 50, programuoti).
asmuo(audrone, moteris, 48, fotografuoti).

asmuo(jonas, vyras, 45, keliauti).
asmuo(rasa, moteris, 43, rasyti).

asmuo(mindaugas, vyras, 47, zaisti).
asmuo(giedre, moteris, 46, sokti).

asmuo(darius, vyras, 44, piesti).
asmuo(saule, moteris, 43, sportuoti).

asmuo(vaida, moteris, 42, skaityti).
asmuo(vytautas, vyras, 41, gaminti).

asmuo(egle, moteris, 41, dainuoti).
asmuo(gustas, vyras, 40, siuvineti).

% 4 karta
asmuo(tomas, vyras, 25, piesti).
asmuo(ieva, moteris, 23, skaityti).
asmuo(viktorija, moteris, 20, dainuoti).

asmuo(mantas, vyras, 21, sportuoti).
asmuo(simona, moteris, 20, dainuoti).

asmuo(andrius, vyras, 19, vaikscioti).
asmuo(laura, moteris, 18, gaminti).

asmuo(julius, vyras, 17, piesti).
asmuo(audrius, vyras, 16, zaisti).

asmuo(simas, vyras, 16, skaityti).

asmuo(karolina, moteris, 17, dainuoti).
asmuo(deimante, moteris, 14, siuvineti).


% Motinos-vaiko ryšiai 
mama(ingrida, antanas).
mama(ingrida, marija).
mama(ingrida, kotryna).
mama(ona, petras).
mama(ona, jonas).
mama(marija, mindaugas).
mama(kotryna, darius).
mama(kotryna, vaida).
mama(kotryna, egle).
mama(audrone, tomas).
mama(audrone, ieva).
mama(audrone, viktorija).
mama(rasa, mantas).
mama(rasa, simona).
mama(giedre, andrius).
mama(giedre, laura).
mama(saule, julius).
mama(saule, audrius).
mama(vaida, simas).
mama(egle, karolina).
mama(egle, deimante).


% Santuokos ryšiai
pora(arnoldas, ingrida).
pora(antanas, ona).
pora(juozas, marija).
pora(dainius, kotryna).
pora(petras, audrone).
pora(jonas, rasa).
pora(mindaugas, giedre).
pora(darius, saule).
pora(vytautas, vaida).
pora(gustas, egle).


% 7 var - seserys(Sesuo1, Sesuo2) - Asmenys Sesuo1 ir Sesuo2 yra seserys;

seserys(Sesuo1, Sesuo2) :- 
    asmuo(Sesuo1, moteris, _, _),
    asmuo(Sesuo2, moteris, _, _),
    Sesuo1 \= Sesuo2,  
    mama(Mama, Sesuo1), 
    mama(Mama, Sesuo2).

% ?- seserys(ieva, X).
% X = viktorija ;
% false.

% ?- seserys(egle, vaida).
% true.

% 27 var - vedes(Vedes) - Asmuo Vedes yra vedęs (vyras);

vedes(Vedes) :- 
    asmuo(Vedes, vyras, _, _), 
    pora(Vedes, _).

% ?- vedes(petras).
% true.

% ?- vedes(X).
% X = arnoldas ;
% X = antanas ;
% X = juozas ;
% X = dainius ;
% X = petras ;
% X = jonas ;
% X = mindaugas ;
% X = darius ;
% X = vytautas ;
% X = gustas ;
% false.

% ?- vedes(tomas).
% false.

% 34 var - paveldejo(Asmuo, Pomegis) - Asmuo Asmuo turi tokį patį pomėgį Pomegis kaip ir vienas iš tėvų;

paveldejo(Asmuo, Pomegis) :- 
    asmuo(Asmuo, _, _, Pomegis),
    mama(Mama, Asmuo), 
    asmuo(Mama, _, _, Pomegis).

paveldejo(Asmuo, Pomegis) :- 
    asmuo(Asmuo, _, _, Pomegis),
    mama(Mama, Asmuo), 
    pora(Tetis, Mama), 
    asmuo(Tetis, _, _, Pomegis).

% ?- paveldejo(egle, dainuoti).
% true.

% ?- paveldejo(egle, X).
% X = dainuoti.

% ?- paveldejo(X, dainuoti).
% X = karolina ;
% X = egle ;
% false.

% 39 var - trys_draugai(Draugas1, Draugas2, Draugas3) - Asmenys Draugas1, Draugas2 ir Draugas3 yra panašaus amžiaus ir turi tą patį pomėgį;
trys_draugai(Draugas1, Draugas2, Draugas3) :- 
    asmuo(Draugas1, _, Amzius1, Pomėgis), 
    asmuo(Draugas2, _, Amzius2, Pomėgis), 
    asmuo(Draugas3, _, Amzius3, Pomėgis), 
    Draugas1 \= Draugas2, 
    Draugas1 \= Draugas3, 
    Draugas2 \= Draugas3,
    abs(Amzius1 - Amzius2) =< 4, 
    abs(Amzius1 - Amzius3) =< 4,
    abs(Amzius2 - Amzius3) =< 4.

% ?- trys_draugai(X, Y, Z).
% X = karolina,
% Y = simona,
% Z = viktorija ;
% false.