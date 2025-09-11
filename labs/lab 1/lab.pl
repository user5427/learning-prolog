% Tadas Riksas, Programu sistemos 3 kuras, variantai: 7; 27; 34; 39

% Duomenų bazėje saugomi duomenys apie asmenis ir jų giminystės ryšius

% 1 karta
asmuo(antanas, vyras, 1950, skaityti).
asmuo(ona, moteris, 1952, gaminti).

asmuo(juozas, vyras, 1951, sportuoti).
asmuo(marija, moteris, 1953, dainuoti).

% 2 karta
asmuo(petras, vyras, 1975, programuoti).
asmuo(audrone, moteris, 1977, fotografuoti).

asmuo(jonas, vyras, 1980, keliauti).
asmuo(rasa, moteris, 1982, rašyti).


asmuo(mindaugas, vyras, 1978, žaisti).
asmuo(giedre, moteris, 1979, šokti).

% 3 karta
asmuo(tomas, vyras, 2000, piešti).
asmuo(ieva, moteris, 2002, skaityti).


asmuo(mantas, vyras, 2004, sportuoti).
asmuo(simona, moteris, 2005, dainuoti).


asmuo(andrius, vyras, 2006, vaikscioti).
asmuo(laura, moteris, 2007, gaminti).


% Motinos ryšiai 
mama(ona, petras).
mama(ona, jonas).
mama(marija, mindaugas).
mama(audrone, tomas).
mama(audrone, ieva).
mama(rasa, mantas).
mama(rasa, simona).
mama(giedre, andrius).
mama(giedre, laura).


% Santuokos ryšiai
pora(antanas, ona).
pora(juozas, marija).
pora(petras, audrone).
pora(jonas, rasa).
pora(mindaugas, giedre).


% 7 var - seserys(Sesuo1, Sesuo2) - Asmenys Sesuo1 ir Sesuo2 yra seserys;

seserys(Sesuo1, Sesuo2) :- asmuo(Sesuo1, moteris, _, _), asmuo(Sesuo2, moteris, _, _), Sesuo1 =\= Sesuo2, mama(Mama, Sesuo1), mama(Mama, Sesuo2).

% 27 var - vedes(Vedes) - Asmuo Vedes yra vedęs (vyras);

vedes(Vedes) :- asmuo(Vedes, vyras, _, _), pora(Vedes, _).

% 34 var - paveldejo(Asmuo, Pomegis) - Asmuo Asmuo turi tokį patį pomėgį Pomegis kaip ir vienas iš tėvų;