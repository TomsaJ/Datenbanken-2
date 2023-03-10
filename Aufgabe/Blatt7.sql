--Aufgabe 1
SELECT  Titel
FROM    Buch
WHERE   Buch_oid NOT IN
        (
        SELECT  Buch_OID
        FROM    ausleihe
        );

--Aufgabe 2
SELECT  Titel
FROM    Buch
WHERE   Buch_oid IN
        (
        SELECT  Buch_OID
        FROM    Ausleihe
        where   (current_date - Rdat) > 14
        AND Ausleihe.buch_oid = Buch.Buch_OID
        );

 --Aufgabe 3
 select Titel 
 FROM Buch 
 WHERE Buch_OID IN (
        SELECT Buch_OID 
        FROM Exemplar 
        ORDER BY anschdat ASC
        );

--Aufgabe 4
SELECT  Titel
FROM    Buch
WHERE   Buch_OID IN
        (
        SELECT  Buch_OID
        FROM     Mahnung
        where   Mahnung.datum > '15.10.2012'
        AND    Mahnung.Buch_OID = Buch.Buch_OID
        );

--Aufgabe 5
select Buch.Titel, Exemplar.Anschdat, Vormerkt.Vormdat from Exemplar, Vormerkt, Buch 
where  Buch.buch_oid = vormerkt.Buch_OID and Exemplar.anschdat > Vormerkt.Vormdat;

SELECT  Titel
FROM    Buch
WHERE   Buch_OID IN
        (
        SELECT  Vormerkt.Buch_OID
        FROM    Vormerkt, Exemplar
        where   Buch.buch_oid = vormerkt.Buch_OID
        AND    Exemplar.anschdat > Vormerkt.Vormdat
        );

SELECT  Titel
FROM    Buch,Exemplar
WHERE   Exemplar.Buch_oid IN
        (
        SELECT  Buch_OID
        FROM    vormerkt
        where   VormDat > Exemplar.anschdat
        );

--Aufgabe 6
SELECT Nachname,
       (SELECT COUNT(Leser_OID)
        FROM Ausleihe
        WHERE Leser_OID = Leser.Leser_OID) AS Haufigkeit
FROM Leser;

--Aufgabe 7
SELECT  Titel, ExID
FROM    Buch,Exemplar
WHERE   Exemplar.ExID NOT IN
        (
        SELECT  ExID
        FROM    Ausleihe
        );
