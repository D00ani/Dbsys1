SET SERVEROUTPUT ON;
SPOOL view_tests_log.txt;

SELECT '--- TEST 1: Familienwohnungen ---' FROM dual;

INSERT INTO Familienwohnungen (FerienWohnungsNr, Preis_in_Euro, Größe_in_qm, Beschreibung, Anzahl_Zimmer, Adresse)
VALUES (999, 150, 120, 'Große Testwohnung', 4, 1);

SELECT * FROM Familienwohnungen WHERE FerienWohnungsNr = 999;

INSERT INTO Familienwohnungen (FerienWohnungsNr, Preis_in_Euro, Größe_in_qm, Beschreibung, Anzahl_Zimmer, Adresse)
VALUES (998, 80, 85, 'Kleine Testwohnung', 2, 1);

UPDATE Familienwohnungen 
SET Größe_in_qm = 90 
WHERE FerienWohnungsNr = 999;

ROLLBACK;


SELECT '--- TEST 2: MidAgeKunden ---' FROM dual;

INSERT INTO Kunde (KundenNr, Name, Vorname, Geburtsdatum, Adresse, Bankverbindung, Telefonnummer)
VALUES (888, 'Testmann', 'Thomas', TO_DATE('1991-05-15', 'YYYY-MM-DD'), 1, 'DE123456789', '01511234567');

SELECT KundenNr, Name, KundenAlter FROM MidAgeKunden WHERE KundenNr = 888;

UPDATE MidAgeKunden 
SET KundenAlter = 38 
WHERE KundenNr = 888;

ROLLBACK;


SELECT '--- TEST 3: MidAgeKundenOhneGebDatum ---' FROM dual;

INSERT INTO MidAgeKundenOhneGebDatum (KundenNr, Name, Vorname, Adresse, Bankverbindung)
VALUES (887, 'Ohne', 'Geburtstag', 1, 'DE12345');

ROLLBACK;


SELECT '--- TEST 4: GuteFluggesellschaften ---' FROM dual;

DELETE FROM GuteFluggesellschaften WHERE IATACode = 'DLH';

ROLLBACK;

SPOOL OFF;
SELECT '--- TEST 5: Reservierung (Positiv-Tests INSERT, UPDATE, DELETE) ---' FROM dual;

INSERT INTO Reservierung (BelegNummer, Belegdatum, Von, Bis, Ferienwohnung, Kunde) 
VALUES (9001, SYSDATE, SYSDATE, SYSDATE+7, 1, 1);

UPDATE Reservierung 
SET Von = SYSDATE+1 
WHERE BelegNummer = 9001;

DELETE FROM Reservierung 
WHERE BelegNummer = 9001;

UPDATE Reservierung 
SET Status = 'Buchung' 
WHERE BelegNummer = 9001;

ROLLBACK;


SELECT '--- TEST 6: Buchung (Eingeschränkte DML-Operationen) ---' FROM dual;

UPDATE Buchung 
SET Bis = SYSDATE+14 
WHERE BelegNummer = 1;

DELETE FROM Buchung 
WHERE BelegNummer = 1;

ROLLBACK;


SELECT '--- TEST 7: Familienwohnungen (Positiv-Tests UPDATE, DELETE) ---' FROM dual;

INSERT INTO Familienwohnungen (FerienWohnungsNr, Preis_in_Euro, Größe_in_qm, Beschreibung, Anzahl_Zimmer, Adresse)
VALUES (997, 150, 150, 'Gültige Update-Testwohnung', 5, 1);

UPDATE Familienwohnungen 
SET Preis_in_Euro = 180 
WHERE FerienWohnungsNr = 997;

DELETE FROM Familienwohnungen 
WHERE FerienWohnungsNr = 997;

ROLLBACK;


SELECT '--- TEST 8: MidAgeKunden (Positiv-Tests reguläre Spalten) ---' FROM dual;

INSERT INTO Kunde (KundenNr, Name, Vorname, Geburtsdatum, Adresse, Bankverbindung, Telefonnummer)
VALUES (886, 'Muster', 'Max', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 1, 'DE000000', '012340000');

UPDATE MidAgeKunden 
SET Vorname = 'Maximilian' 
WHERE KundenNr = 886;

DELETE FROM MidAgeKunden 
WHERE KundenNr = 886;

ROLLBACK;


SELECT '--- TEST 9: UebersichtKunden (Negativ-Tests komplexe Sicht) ---' FROM dual;

UPDATE UebersichtKunden 
SET Vorname = 'Test' 
WHERE KundenNr = 1;

DELETE FROM UebersichtKunden 
WHERE KundenNr = 1;

ROLLBACK;


SELECT '--- TEST 10: Zahlungsstatus (Negativ-Tests komplexe Sicht) ---' FROM dual;

UPDATE Zahlungsstatus 
SET Rechnungsbetrag = 99 
WHERE Rechnungsnummer = 1;

DELETE FROM Zahlungsstatus 
WHERE Rechnungsnummer = 1;

ROLLBACK;