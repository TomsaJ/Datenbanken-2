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
