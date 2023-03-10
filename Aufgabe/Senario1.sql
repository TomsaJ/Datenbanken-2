CREATE TABLE Literatur(
	Literatur_OID int NOT NULL,
	Literaturname varchar(256),
	Schalgwort_OID int
);

CREATE TABLE Notizen(
	Quellen_OID int,
	Notizen_OID int NOT NULL,
	Schalgwort_OID int,
	Bemerkung varchar(256)
);

CREATE TABLE Quelle(
	Quell_OID int NOT NULL,
	Quellenname varchar(100),
	Webseiten_OID int,
	Literatur_OID int
);

CREATE TABLE Webseite(
	Webseiten_OID int NOT NULL,
	Webseitenname varchar(256),
	Schalgwort_OID int
);

CREATE TABLE Schlagwort(
	Schlagwort_OID int NOT NULL,
	Schlagwortbemerkung varchar(256)
);

ALTER TABLE Literatur ADD CONSTRAINT PK_Literatur PRIMARY KEY(Literatur_OID);
ALTER TABLE Notizen ADD CONSTRAINT PK_Notizen PRIMARY KEY(Notizen_OID);
ALTER TABLE Quelle ADD CONSTRAINT PK_Quelle PRIMARY KEY(Quell_OID);
ALTER TABLE Webseite ADD CONSTRAINT PK_Webseite PRIMARY KEY(Webseiten_OID);
ALTER TABLE Schlagwort ADD CONSTRAINT PK_Schlagwort PRIMARY KEY(Schlagwort_OID);

ALTER TABLE Literatur ADD CONSTRAINT FK_Literatur_0 FOREIGN KEY(Schalgwort_OID) REFERENCES Schlagwort(Schlagwort_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Notizen ADD CONSTRAINT FK_Notizen_0 FOREIGN KEY(Quellen_OID) REFERENCES Quelle(Quell_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Notizen ADD CONSTRAINT FK_Notizen_1 FOREIGN KEY(Schalgwort_OID) REFERENCES Schlagwort(Schlagwort_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Quelle ADD CONSTRAINT FK_Quelle_1 FOREIGN KEY(Literatur_OID) REFERENCES Literatur(Literatur_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Quelle ADD CONSTRAINT FK_Quelle_0 FOREIGN KEY(Webseiten_OID) REFERENCES Webseite(Webseiten_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Webseite ADD CONSTRAINT FK_Webseite_0 FOREIGN KEY(Schalgwort_OID) REFERENCES Schlagwort(Schlagwort_OID) ON DELETE NO ACTION ON UPDATE NO ACTION;
