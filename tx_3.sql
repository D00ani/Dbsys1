SET TRANSACTION READ WRITE NAME 'TX3_FeWo_Loeschen';

UNDEFINE fewoNr;

-- 1. FeWo löschen → CASCADE löscht Bild, Ferienwohnung_hat_Zusatzausstattung,
--    Belegung (Trigger archiviert Buchungen in StornierteBuchung), Rechnung
DELETE FROM Ferienwohnung
WHERE FerienWohnungsNr = &&fewoNr;

-- 2. Adresse löschen – erst jetzt, da keine FeWo mehr darauf zeigt
DELETE FROM Adresse
WHERE AdressID NOT IN (SELECT Adresse FROM Ferienwohnung)
  AND AdressID NOT IN (SELECT Adresse FROM Kunde)
  AND AdressID NOT IN (SELECT Adresse FROM Touristenattraktion)
  AND AdressID NOT IN (SELECT Adresse FROM Flughafen);

UNDEFINE fewoNr;


COMMIT;

