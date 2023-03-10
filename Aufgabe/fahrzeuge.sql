--1.3
Kein Unterschied

--Aufgabe 1.5
CREATE TABLE Kunde(
    KID int NOT NULL,
    Nachname varchar(20) NOT NULL,
    ErstbestellungID int NOT NULL
);

CREATE TABLE Bestellungen(
    BestellungsID int NOT NULL,
    KID int NOT NULL,
    AID int NOT NULL,
    Menge decimal(9,2),
    Preis decimal(9,2)
);

CREATE TABLE Artikel(
    AID int NOT NULL,
    Bezeichnung varchar(20) NOT NULL,
    Nettoeinzelprei decimal(9,2)
);

CREATE TABLE Kontoverbindung(
    KID int NOT NULL,
    Bankleitzahl varchar(20),
    Kontonummer varchar(20)
);

ALTER TABLE Kunde ADD CONSTRAINT PK_Kunde PRIMARY KEY(KID);
ALTER TABLE Bestellungen ADD CONSTRAINT PK_Bestellungen PRIMARY KEY(BestellungsID);
ALTER TABLE Artikel ADD CONSTRAINT PK_Artikel PRIMARY KEY(AID);
ALTER TABLE Kontoverbindung ADD CONSTRAINT PK_Kontoverbindung PRIMARY KEY(KID);

ALTER TABLE Kunde ADD CONSTRAINT FK_Kunde_0 FOREIGN KEY(ErstbestellungID) REFERENCES Bestellungen(BestellungsID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Bestellungen ADD CONSTRAINT FK_Bestellungen_0 FOREIGN KEY(KID) REFERENCES Kunde(KID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Bestellungen ADD CONSTRAINT FK_Bestellungen_1 FOREIGN KEY(AID) REFERENCES Artikel(AID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Kontoverbindung ADD CONSTRAINT FK_Kontoverbindung_0 FOREIGN KEY(KID) REFERENCES Kunde(KID) ON DELETE CASCADE ON UPDATE CASCADE;

--1.7
select (select Nachname from kunde where Kunde.kid = KV.KID ), count (KID) as Anzahl from Kontoverbindung KV group by KID;

--1.8

select Kunde.nachname,  Kontoverbindung.kid, Kontoverbindung.Bankleitzahl, kontoverbindung.Kontonummer from Kunde natural join Kontoverbindung;

--1.9
Funktioniert





--Aufgabe 2.1
CREATE TABLE Anhaenger(
    PKWID int NOT NULL,
    Art varchar (20),
    Laenge decimal (7,2)
);

CREATE TABLE LKW(
    KID int NOT NULL,
    zulGesGew varchar(10)
);

CREATE TABLE Krad(
    KID int NOT NULL,
    FuehKlasse varchar(10),
    Marke varchar(20)
);

CREATE TABLE Fahrzeuge(
    KID int NOT NULL,
    Kennzeichen varchar(8)
);

CREATE TABLE PKW(
    PKWID int NOT NULL,
    KID int,
    Marke varchar(20) ,
    AnzPlaetze int
);

ALTER TABLE Anhaenger ADD CONSTRAINT PK_Anhaenger PRIMARY KEY(PKWID);
ALTER TABLE LKW ADD CONSTRAINT PK_LKW PRIMARY KEY(KID);
ALTER TABLE Krad ADD CONSTRAINT PK_Krad PRIMARY KEY(KID);
ALTER TABLE Fahrzeuge ADD CONSTRAINT PK_Fahrzeuge PRIMARY KEY(KID);
ALTER TABLE PKW ADD CONSTRAINT PK_PKW PRIMARY KEY(PKWID);

ALTER TABLE Anhaenger ADD CONSTRAINT FK_Anhaenger_0 FOREIGN KEY(PKWID) REFERENCES PKW(PKWID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE LKW ADD CONSTRAINT FK_LKW_0 FOREIGN KEY(KID) REFERENCES Fahrzeuge(KID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Krad ADD CONSTRAINT FK_Krad_0 FOREIGN KEY(KID) REFERENCES Fahrzeuge(KID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE PKW ADD CONSTRAINT FK_PKW_0 FOREIGN KEY(KID) REFERENCES Fahrzeuge(KID) ON DELETE CASCADE ON UPDATE CASCADE;

--2.3
select Kennzeichen from fahrzeuge where Fahrzeuge.kid = (select KID from Krad where Marke = 'BMW' );

--2.4
select Kennzeichen from fahrzeuge where Fahrzeuge.kid = (select KID from anhaenger where Art = 'Boot' );