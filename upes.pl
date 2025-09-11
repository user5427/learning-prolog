intakas(neris, nemunas).
intakas(merkys, nemunas).
intakas(nevezis, nemunas).
intakas(sesupe, nemunas).
intakas(zeimena, neris).
intakas(sventoji, neris).
intakas(vilnele, neris).
intakas(jara, sventoji).

kaimynes(Upe1, Upe2) :- intakas(Upe1, DUpe), intakas(Upe2, DUpe).
