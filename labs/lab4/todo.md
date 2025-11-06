4 užduotis - Paieška.

Užduoties esmė: rekursyvi paieška uždavinio sprendinio paieškos medyje su grįžimu. Užduoties sprendimą turi sudaryti bent du predikatai. Žinoma, jų gali būti ir žymiai daugiau.

Pirmasis predikatas turi būti skirtas išspręsti pasirinktą uždavinį. Jame vienas ar daugiau argumentų turi būti įėjimo argumentai, nusakantys pradinius užduoties parametrus ir vienas argumentas turi atitikti sprendinį. Atkreipkite dėmesį, kad užduoties parametrai programos testavimo (atsiskaitymo) metu gali būti keičiami, o tam neturėtų reikėti perkompiliuoti programos. Sprendinys - Prologo struktūra (sąrašas ar pan.) - turi būti apibrėžtas konstruktyviai. Predikatas turi turėti galimybę ieškoti alternatyvių sprendinių. Ieškodamas sprendinių šis predikatas neturėtų nieko spausdinti į ekraną (predikatai print/1, format/2 ir t.t...). Didžiausias dėmesys turi būti skiriamas ne sprendimo efektyvumui, o deklaratyviam (Prologo prasme) apibrėžimui. Jokiu būdu nereikia ieškoti deterministinių uždavinio sprendimo algoritmų, nors tokie ir būtų.

Antrojo predikato tikslas - išvesti sprendinį į ekraną skaitomu pavidalu. Atkreipkite dėmesį, kad sprendinys nebūtinai yra tik galutinė uždavinio būsena. Kartais, kad būtų aišku, kokiu keliu rezultatas buvo pasiektas, reikia parodyti atliktus ėjimus ir/ar tarpines būsenas. Šis predikatas turi turėti bent vieną įėjimo argumentą - uždavinio sprendinį iš pirmojo predikato.

Užduočiai atlikti (tiek rasti uždavinio sprendimą, tiek jį pavaizduoti) neturėtų būti naudojami jokie išoriniai įrankiai. Viskas turi būti atliekama Prolog aplinkoje.

Atkreipkite dėmesį, kad užduotyse su variantais užtenka įgyvendinti vieną iš variantų. Tai yra, nereikia įgyvendinti ir 1.1, ir 1.2, ir 1.3. Užtenka pasirinkti vieną iš jų.

# [SS] Plokščio grafo braižymas.
Duotas plokščiasis grafas (viršūnės ir briaunos tarp viršūnių). Nustatykite, kaip galima grafą pavaizduoti plokštumoje taip, kad jo briaunos nesikirstų. Šiai užduočiai (kaip ir kitoms) grafų braižymui, viršūnių dėliojimui ar kitais tikslais negali būti naudojami jokie išoriniai įrankiai (pvz., Graphviz).