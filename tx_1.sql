SET TRANSACTION READ WRITE NAME 'TX1_FeWo_Einfuegen';

INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ)
VALUES (
    (SELECT (MAX(AdressID) + 1) FROM Adresse),
    'Highway',
    '6',
    (SELECT o.Ort_ID FROM Ort o JOIN Land l ON o.Land = l.Isocode WHERE o.Name = 'Öludeniz' AND l.Name = 'Türkei'),
    '2349'
);

INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse)
VALUES (
    999,
    100.00,
    100,
    'SeaView',
    4,
    (SELECT MAX(AdressID) FROM Adresse)
);

INSERT INTO Zusatzausstattung (Bezeichnung) 
SELECT 'Whirlpool' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM Zusatzausstattung WHERE Bezeichnung = 'Whirlpool');

INSERT INTO Zusatzausstattung (Bezeichnung) 
SELECT 'Garten' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM Zusatzausstattung WHERE Bezeichnung = 'Garten');

INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (999, 'Whirlpool');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (999, 'Garten');

COMMIT;