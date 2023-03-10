-- Aufgabe 1
    --Inner join:
        Select Titel as Buchtitel, AnschDat as angeschafftAm,
        count(*)as Anzahl
        From Buch inner join Exemplar on Buch.Buch_OID = exemplar.Buch_OID
        Group by Buch_OID, AnschDat;

--Aufgabe 2
    --Auto join:
        Select L2.Nachname
        From Ausleihe A1, Leser L1, Ausleihe A2, Leser L2
         Where L1.Nachname = 'Schmitz'
        And L1.Leser_OID = A1.Leser_OID
        And A1.Buch_OID = A2.Buch_OID
        And A1.Exid = A2.ExID
        And A2.Leser_OID = L2.Leser_OID;

--Aufgabe 3
    --Right outer join:
        Select Titel as Buchtitel, M.Datum
        From Mahnung M right outer join Buch B on M.Buch_OID = B.Buch_OID;

--Aufgabe 4
    --Left outer join:
        Select Leser_OID,
        iif(sum(Betrag) is null, 'kein Betrag offen',
        sum(Betrag) is null)
        From Leser left outer join Mahnung
        on Leser.Leser_OID = Mahnung.Leser_OID
        group by Leser.Leser_OID;

--Aufgabe 5
    --Inner join:
        Select Titel as Buchtitel, Ausleihe.RDat
        From Buch, Ausleihe
        where Buch.Titel = 'Grundlagen von Datenbanksystemen'
        And Buch.Verfasser = 'Elmasri'
        And Buch.Buch_OID = Ausleihe.Buch_OID
        And Rdat > current_date
        Order by RDat desc;

--Aufgabe 6
    --Inner join
        Select Titel as Buchtitel, count(*)
        From Mahnung, Buch
        Where Buch.Buch_OID = Mahnung.Buch_OID
        Group by Buch_OID
        Order by 2 desc;

--Aufgabe 7
    --left outer join:
        select L.Nachname, V.VormDat
        from Leser L left outer join Vormerkt V
        on L.Leser_OID = V.Lerser_OID;