--Aufgabe 1
Select Buch.Buch_OID, Titel, ExID, AnschDat from Buch, Exemplar
where Buch.Buch_OID = Exemplar.Buch_OID;

--Aufgabe 2
Select *
from Leser, Vormerkt
where Leser.Leser_OID = Vormerkt.Lerser_OID;

--Aufgabe 3
Select *
from Mahnung, Leser, Vormerkt
where Mahnung.Leser_OID = Leser.Leser_OID
and Leser.Leser_OID = Vormerkt.Lerser_OID
and Mahnung.Buch_OID = Vormerkt.Buch_OID;

--Aufgabe 4
Select count(Mahnung.Betrag)
from Buch, Mahnung
where Buch.Buch_OID = Mahnung.Buch_OID
and Buch.Titel = 'Java ist eine Insel';

--Aufgabe 5
Select Titel, Nachname
from Leser, Mahnung, Buch
where Buch.Titel = 'Grundlagen von Datenbanksystemen'
And Buch.Buch_OID = Mahnung.Buch_OID
And Mahnung.Leser_OID = Leser.Leser_OID;

--Aufgabe 6
Select *
From Exemplar E, Mahnung M
Where E.AnschDat > M.Datum
And E.Buch_OID = M.Buch_OID
And E.ExID = M.Ex_ID;