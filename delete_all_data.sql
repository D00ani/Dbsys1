UPDATE Ort SET bester_flughafen = NULL;

DELETE FROM Rechnung;
DELETE FROM Ferienwohnung_hat_Zusatzausstattung;
DELETE FROM Bild;
DELETE FROM verbindet;
DELETE FROM Entfernung;
DELETE FROM Touristenattraktion;

DELETE FROM Belegung;
DELETE FROM StornierteBuchung;
DELETE FROM Kunde;
DELETE FROM Ferienwohnung;

DELETE FROM Flughafen;
DELETE FROM Fluggesellschaft;
DELETE FROM Adresse;
DELETE FROM Ort;

DELETE FROM Bankverbindung;
DELETE FROM Zusatzausstattung;
DELETE FROM Land;

DELETE FROM AdditionalDocumentation;

COMMIT;
