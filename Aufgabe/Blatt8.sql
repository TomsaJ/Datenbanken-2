--Aufgabe 1
SELECT
    count(*) as "Anzahl Mahnungen",
    (
        SELECT count(Ausleihe.Buch_OID) 
        FROM Ausleihe 
    ) as "Anzahl Ausleihen",
    count(*) * 100.00 / (
                            SELECT count(Ausleihe.Buch_OID) 
                            FROM Ausleihe
                        ) as "Mahnungen in Prozent"
FROM Mahnung
WHERE Mahnung.Mahnung_OID = Mahnung.Vorgaenger;

--Aufgabe 2
ALTER TABLE EXEMPLAR
ADD ANSCHBETRAG NUMERIC(6,2);

SELECT 
(
    SELECT Buch.titel
    FROM Buch
    WHERE Buch.Buch_OID = Mahnung.Buch_OID
    ),
     Mahnung.Ex_ID
FROM Mahnung
where Mahnung.Datum < '01.01.2012'
AND Mahnung.Datum > '31.12.2010'
GROUP BY Mahnung.Buch_OID, Mahnung.Ex_Id
having sum(Mahnung.Betrag)  >   (
                                SELECT Exemplar.AnschBetrag
                                FROM Exemplar
                                WHERE Exemplar.Buch_OID = Mahnung.buch_oid
                                AND Exemplar.ExID = Mahnung.Ex_ID
                                );

--Aufgabe 3
SELECT *
FROM 
(    
SELECT l.Leser_OID, l.Nachname
FROM Leser l
WHERE l.Leser_OID IN    (
                        SELECT v.Lerser_OID
                        FROM Vormerkt v
                        WHERE extract(year FROM v.VormDat) = '2011' 
                        AND v.Buch_OID IN   (
                                            SELECT m.Buch_OID
                                            FROM Mahnung m
                                            WHERE extract(year FROM m.Datum) = '2011' 
                                            AND m.Datum > v.VormDat 
                                            AND l.Leser_OID = m.Leser_OID
                                            )
                        )
);


--Aufgabe 4
SELECT *
FROM (
    SELECT l.Leser_OID, l.Nachname
    FROM Leser l
    WHERE l.Leser_OID IN (
        SELECT v.Lerser_OID
        FROM Vormerkt v
        WHERE extract(year FROM v.VormDat) = '2011' 
        AND v.Buch_OID IN(
            SELECT m.Buch_OID
            FROM Mahnung m
            WHERE extract(year FROM m.Datum) = '2011' 
            AND m.Datum > v.VormDat 
            AND l.Leser_OID = m.Leser_OID
        )
    )

) AS TM;

--Aufgabe 5
SELECT
(
    SELECT Buch.Titel
    FROM Buch
    WHERE Buch.Buch_OID = Exemplar.Buch_OID
) as Buchtitel,
Exemplar.ExID,
iif (
current_date < (
                SELECT Ausleihe.rdat
                FROM Ausleihe WHERE Ausleihe.EXID = Exemplar.ExId
                ),
'ausgeliehen' ,
'nicht ausgeliehen'
) as Status
FROM Exemplar
WHERE Exemplar.Buch_OID =   (
                            SELECT Buch.buch_oid
                            FROM Buch
                            WHERE Buch.Titel = 'Java ist eine Insel'
                            );

--Aufgabe 6
select Titel, EXID,
    case
    when Rdat > current_date then 'ausgeliehen'
    else 'nicht ausgeliehen'
    end as Status
    from    (
            select E.Buch_OID, 
            E.EXID,(
                    select A.Rdat 
                    from Ausleihe A
                    where A.exid = E.EXID 
                    and A.buch_oid = E.Buch_OID 
                    and Rdat = (
                                select max (A2.Rdat) 
                                from ausleihe A2
                                where A2.buch_oid = E.Buch_OID
                                and A2.exid = E.EXID
                                )
                    )
            from Exemplar E
            )
natural join buch
where Buch_OID =    (
                    select B.Buch_OID 
                    from Buch B
                    where B.titel = 'Java ist eine Insel' 
                    group by B.Buch_OID
                    );