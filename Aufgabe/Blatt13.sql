--Aufgabe 1:
CREATE TABLE Firma (FaName varchar(10));

INSERT INTO Firma (FaName)
SELECT substring(Vname from 1 for 2) || substring(nname from 1 for 2) || '-' || substring(ort from 1 for 4)
FROM Person
LIMIT 200;

--Aufgabe 3:
SELECT *
FROM Firma
WHERE FaName IN (SELECT FaName FROM Firma GROUP BY FaName HAVING COUNT(*) > 1);

--Aufgabe 4:
DELETE FROM Firma
WHERE FaName IN (SELECT FaName FROM Firma GROUP BY FaName HAVING COUNT(*) > 1);

--Aufgabe 5:
ALTER TABLE Firma ADD Zahl INTEGER;

--Aufgabe 6:
/*Trigger für das Einfuegen eines Wertes in Firma*/
create or alter trigger EinfuegenFirma for Firma
active before insert position 0
as
begin
    execute procedure EinfuegenFirma(new.FaName);
end


/* Prozedur für das Einfuegen eines Namens in Firma*/
create or alter procedure EinfuegenFirma (Name varchar(10))
as
declare variable tmp integer;
declare variable maximum integer;
declare variable zaehler integer;

begin
  select min(Key_Value) from Keywert into :tmp;
  select max(Key_Value) from Keywert into :maximum;

  if (:tmp = :maximum)
  then begin
      zaehler=0;
      while (zaehler < 10)
      do
      begin
        maximum = maximum+1;
        insert into Keywert (Key_Value) values (:maximum);
        zaehler = zaehler+1;
      end
  end

  delete from Keywert where Key_Value = (:tmp);
  update Firma set Zahl = :tmp where FaName = :Name;
end


/* Einmalige aktualisieren der 200 Firmennamen */
create or alter procedure UpdateFirma
as
declare variable Firmenname varchar(10);
declare variable zaehler integer;
begin

for select FaName from Firma into :Firmenname
    do
    begin
        execute procedure EinfuegenFirma(:Firmenname);
    end
end


/*Trigger für das Löschen eines Wertes in Firma*/
create or alter trigger LoeschenFirma for Firma
active before delete position 0
as
begin
    insert into Keywert values (old.Zahl);
end



/* Trigger für das Einfuegen in Person */
create or alter trigger EinfuegenPerson for Person
active after insert position 0
as
begin
    execute procedure EinfuegenPerson(new.Ort,new.Strasse);
end



/* Prozedur für das Einfuegen einer Person in Person */
create or alter procedure EinfuegenPerson (Ort varchar(30),strasse1 varchar(30))
as
declare variable tmp integer;
declare variable maximum integer;
declare variable zaehler integer;

begin
  select min(Key_Value) from Keywert into :tmp;
  select max(Key_Value) from Keywert into :maximum;

  if (:tmp = :maximum)
  then begin
      zaehler=0;
      while (zaehler < 10)
      do
      begin
        maximum = maximum+1;
        insert into Keywert (Key_Value) values (:maximum);
        zaehler = zaehler+1;
      end
  end

  delete from Keywert where Key_Value = (:tmp);
  update Person set Person_OID = :tmp where Ort = :Ort and Strasse = :strasse1;
end



/*Trigger für das Löschen einer Person aus Person*/
create or alter trigger LoeschenPerson for Person
active before delete position 0
as
begin
    insert into Keywert values (old.Person_OID);
end


select * from Firma where FANAME = 'HEGE-LOHN';