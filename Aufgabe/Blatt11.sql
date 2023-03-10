CREATE TABLE Geburtsdatum(
    GebDat_OID int NOT NULL,
    Tag int,
    Monat int,
    Jahr int,
    GebDat date
);

ALTER TABLE Geburtsdatum ADD CONSTRAINT PK_Geburtsdatum PRIMARY KEY(GebDat_OID);

delete from Geburtsdatum;


CREATE SEQUENCE GEN_GebDatOID_1;
ALTER SEQUENCE GEN_GebDatOID_1 RESTART WITH 0;

CREATE TRIGGER TR_GEBDATOID
FOR geburtsdatum
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    IF (new.GebDat_OID is NULL)
    THEN
    new.GebDat_OID = NEXT VALUE FOR GEN_GEBDATOID_1;
END

--1.2
--Procedure
CREATE PROCEDURE PR_GEBURTSTAG_CHANGE_DATE (
new_day INT NOT NULL,
new_month INT NOT NULL,
new_year INT NOT NULL)
RETURNS (new_date DATE)
AS
BEGIN
    new_date = CAST((new_day ||'.'|| new_month||'.' || new_year) AS DATE);
END

--Trigger
CREATE TRIGGER TR_GEBURTSTAG_BI_CHANGE_DATE_1 FOR GEBURTSDATUM
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
    EXECUTE PROCEDURE PR_GEBURTSTAG_CHANGE_DATE (NEW.tag,NEW.monat,NEW.jahr)
     RETURNING_VALUES NEW.GebDat;
END


--2
CREATE PROCEDURE PR_NACHNAMEN_OID
AS
    DECLARE VARIABLE counter INTEGER;
    DECLARE VARIABLE maxcount INTEGER;
BEGIN
    SELECT COUNT(Nachnamen_OID) FROM Nachnamen INTO :counter;
    SELECT MAX(Nachnamen_OID) FROM Nachnamen INTO :maxcount;
    IF (:maxcount < 1000 AND :counter < 1000) THEN
        UPDATE NACHNAMEN SET Nachnamen_OID = Nachnamen_OID + 10000;
END

EXECUTE PROCEDURE PR_NACHNAMEN_OID;


--3
-- Table Keywert erstellen
CREATE Table Keywert(
Keywert int not null,

constraint PK1_Keywert1 Primary Key(Keywert)

);

-- Procedure um den Keywert aus dem Table Vornamen zu holen
CREATE Procedure PR_KWausVorname
as
begin
    insert into keywert select vornamen_OID from Vornamen;
end

execute procedure PR_KWausVORNAME;

-- Trigger um Daten in Table Keywert einzufügen
Create Trigger TR_VornamenAI
For Vornamen
active after insert Position 0
as
begin
    insert into keywert (Keywert)
    values (New.Vornamen_OID);
end

--Trigger um alten Keywert zu löschen und neuen einzufügen
Create trigger TR_VoranmenAU
for Vornamen
active After update Position 0
as
begin
     if (old.Vornamen <> new.Vornamen)
     then
     begin
        delete from Keywert where old.Vornamen_OID = Keywert.keywert;
        insert into keywert values (new.Vornamen_OID);
     end
end

--Trigger zum löschen des Datensatzes in Vornamen
Create Trigger TR_DELETE
for vornamen
active after Delete Position 0
as
begin
  delete from keywert where old.Vornamen_OID = keywert.keywert;
end

--4
-- Table Person wird erstellt
CREATE TABLE Person(
    Person_OID INTEGER NOT NULL,
    Vornamen VARCHAR(63),
    Nachnamen VARCHAR(63),
    Ort VARCHAR(63),
    Strassehausnummer VARCHAR(63),
    Geburtsdatum DATE
);

ALTER TABLE Person ADD CONSTRAINT PK1_Person_personOID PRIMARY KEY(person_OID);

delete from person;

--Procedure
CREATE OR ALTER PROCEDURE PR_MAKE_RANDOM_TABLE_OUT_OF_4
AS
    DECLARE variable NEW_VORNAMEN VARCHAR(63);
    DECLARE variable NEW_NACHNAMEN VARCHAR(63);
    DECLARE variable NEW_ORT VARCHAR(63);
    DECLARE variable NEW_STRASSEHAUSNUMMER VARCHAR(63);
    DECLARE variable NEW_GEBURTSDATUM DATE;
    DECLARE variable COUNTER INTEGER = 0;
    DECLARE variable RANDOM INTEGER;
BEGIN
while (:COUNTER < 10000) do
  BEGIN

    RANDOM = MOD(CAST(rand() * 1000 AS INTEGER), 210);
    SELECT DISTINCT(VORNAMEN) FROM VORNAMEN WHERE VORNAMEN_OID = :RANDOM INTO :NEW_VORNAMEN;

    RANDOM = MOD(CAST(rand() * 1000 AS INTEGER), 210)+10000;
    SELECT DISTINCT(NACHNAMEN) FROM NACHNAMEN WHERE NACHNAMEN_OID = :RANDOM INTO :NEW_NACHNAMEN;

    RANDOM = MOD(CAST(rand() * 1000 AS INTEGER), 210);
    SELECT DISTINCT(ORT) FROM ORT WHERE ORT_OID= :RANDOM INTO :NEW_ORT;

    RANDOM = MOD(CAST(rand() * 1000 AS INTEGER), 210);
    SELECT DISTINCT(STRASSEHAUSNUMMER) FROM STRASSEHAUSNUMMER WHERE STRASSEHAUSNUMMER_OID = :RANDOM INTO :NEW_STRASSEHAUSNUMMER;

    RANDOM = MOD(CAST(rand() * 1000 AS INTEGER), 210);
    SELECT DISTINCT(GebDat) FROM GEBURTSDATUM WHERE GebDat_OID = :RANDOM INTO :NEW_GEBURTSDATUM;

    INSERT INTO PERSON VALUES (:COUNTER, :NEW_VORNAMEN, :NEW_NACHNAMEN, :NEW_ORT, :NEW_STRASSEHAUSNUMMER, :NEW_GEBURTSDATUM);
    Counter = counter + 1;
  END
END;

EXECUTE PROCEDURE PR_MAKE_RANDOM_TABLE_OUT_OF_4;