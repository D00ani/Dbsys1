-- LAND
INSERT INTO Land (Isocode, Name) VALUES ('CH', 'Schweiz');
INSERT INTO Land (Isocode, Name) VALUES ('DE', 'Deutschland');
INSERT INTO Land (Isocode, Name) VALUES ('ES', 'Spanien');
INSERT INTO Land (Isocode, Name) VALUES ('FR', 'Frankreich');
INSERT INTO Land (Isocode, Name) VALUES ('GL', 'Grönland');
INSERT INTO Land (Isocode, Name) VALUES ('TR', 'Türkei');
INSERT INTO Land (Isocode, Name) VALUES ('US', 'USA');

-- ZUSATZAUSSTATTUNG
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Aufzug');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Autoabstellplatz');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Dachterrasse');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Garage');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Kinderbetreuung');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Reinigung');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Sat-TV');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Sauna');
INSERT INTO Zusatzausstattung (Bezeichnung) VALUES ('Schwimmbad');

-- BANKVERBINDUNG
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('DE85692717230007823212', 'KARSDE66XXX', 69271723, '0007823212');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('DE83692717230008929368', 'BARSDE77XXX', 32793968, '0008929368');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('DE85692717230001347291', 'KARSDE66XXX', 69271723, '0001347291');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('CH85692717230008792978', 'MEMECH88XXX', 29788431, '0008792978');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('CH85692717230009082780', 'KONSCH12XXX', 87890271, '0009082780');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('DE85692717230007322890', 'KARSDE66XXX', 69271723, '0007322890');
INSERT INTO Bankverbindung (IBAN, BIC, BLZ, Kontonummer) VALUES ('DE8569271723001234567', 'KARSDE66XXX', NULL, '0012345678');

-- ORT
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (1, 'Frankfurt', 'DE', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (2, 'Istanbul', 'TR', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (3, 'Zürich', 'CH', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (4, 'Paris', 'FR', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (5, 'Barcelona', 'ES', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (6, 'Stuttgart', 'DE', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (7, 'Disneyland', 'US', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (8, 'Konstanz', 'DE', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (9, 'Heidelberg', 'DE', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (10, 'Rust', 'DE', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (11, 'Bern', 'CH', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (12, 'Chur', 'CH', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (13, 'Flims-Laax', 'CH', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (14, 'Öludeniz', 'TR', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (15, 'Antalya', 'TR', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (16, 'Bordeaux', 'FR', NULL);
INSERT INTO Ort (Ort_ID, Name, Land, bester_flughafen) VALUES (17, 'Disneyland', 'FR', NULL);

-- ADRESSE (Ort_ID -> Ort)
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (1, 'Am Flughafen', '2', 1, '60541');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (2, 'Sabiha Gökcen', '1', 2, '1452');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (3, 'Flughafen-Allee', '100', 3, '5098');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (4, 'Charles de Gaulle', '1A', 4, '8792');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (5, 'Aeropuerto de Barcelona', '10', 5, '08820');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (6, 'Flughafenstrasse', '32-0', 6, '70629');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (7, 'Airport Street', '1', 7, 'DL-AP');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (8, 'Reutestr. ', '104B ', 8, '78467');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (9, 'Hauptstr.', '12', 9, '69115');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (10, 'Schlossstr.', '54', 6, '70173');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (11, 'Alpenstr', '11A ', 11, '3001');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (12, 'Seeweg', '23', 3, '8001');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (13, 'Reutestr. ', '104 B', 8, '78462');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (14, 'Highway', '5', 14, '2349');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (15, 'Markgrafenstr.', '33', 8, '78461');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (16, 'Zur Piste', '189', 12, '2234');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (17, 'rue Monsieur', '980', 16, '8234');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (18, 'rue de gaulle', '22', 17, '8787');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (19, 'rue de la Maison Blanche', '32', 4, '8792');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (20, 'rue liberte', '78', 4, '8792');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (21, 'Strandweg', '90', 15, '2321');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (22, 'Strandweg', '91', 15, '2321');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (23, 'Calle del torro', '821', 5, '5221');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (24, 'Strandweg', '45', 15, '2321');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (25, 'Europapark', '1', 10, '78231');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (26, 'Seestr.', '12', 8, '78463');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (27, 'Bergweg', '78', 13, '2371');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (28, 'GreenOne', '29', 3, '1352');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (29, 'rue de gaulle', '10', 17, '8787');
INSERT INTO Adresse (AdressID, Straße, Hausnummer, Ort, PLZ) VALUES (30, 'Castlestreet', '11', 7, 'DL439');

-- FLUGHAFEN (Adresse_ID -> Adresse)
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('FRA', 'Frankfurt', 1);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('IST', 'Istanbul', 2);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('ZRH', 'Zürich', 3);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('CDG', 'Paris', 4);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('BCN', 'Barcelona', 5);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('STR', 'Stuttgart', 6);
INSERT INTO Flughafen (IATACode, Name, Adresse) VALUES ('DLN', 'Disneyland', 7);

-- UPDATE ORT
UPDATE Ort SET bester_flughafen = 'ZRH' WHERE Ort_ID = 8;
UPDATE Ort SET bester_flughafen = 'STR' WHERE Ort_ID = 6;
UPDATE Ort SET bester_flughafen = 'FRA' WHERE Ort_ID = 9;
UPDATE Ort SET bester_flughafen = 'FRA' WHERE Ort_ID = 10;
UPDATE Ort SET bester_flughafen = 'ZRH' WHERE Ort_ID = 11;
UPDATE Ort SET bester_flughafen = 'ZRH' WHERE Ort_ID = 3;
UPDATE Ort SET bester_flughafen = 'ZRH' WHERE Ort_ID = 12;
UPDATE Ort SET bester_flughafen = 'ZRH' WHERE Ort_ID = 13;
UPDATE Ort SET bester_flughafen = 'IST' WHERE Ort_ID = 14;
UPDATE Ort SET bester_flughafen = 'IST' WHERE Ort_ID = 15;
UPDATE Ort SET bester_flughafen = 'CDG' WHERE Ort_ID = 16;
UPDATE Ort SET bester_flughafen = 'CDG' WHERE Ort_ID = 4;
UPDATE Ort SET bester_flughafen = 'CDG' WHERE Ort_ID = 17;
UPDATE Ort SET bester_flughafen = 'BCN' WHERE Ort_ID = 5;
UPDATE Ort SET bester_flughafen = 'DLN' WHERE Ort_ID = 7;

-- FLUGGESELLSCHAFT
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('DLH', 1, 'Lufthansa');
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('GWI', 4, 'German Wings');
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('TCX', 8, 'Thomas Cook');
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('HLF', 9, 'Hapag Lloyd');
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('PWF', 1, 'Private Wings');
INSERT INTO Fluggesellschaft (IATACode, Service_Qualität, Name) VALUES ('SWR', 2, 'Swiss');

-- FERIENWOHNUNG (Adresse_ID -> Adresse)
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (1, 349.00, 200, 'Finka', 6, 14);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (2, 120.00, 45, 'Ferienwohnung mit Seeblick', 2, 15);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (3, 249.00, 150, 'im Schnee', 3, 16);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (4, 249.00, 100, 'direkt am Meer', 4, 17);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (5, 289.00, 110, 'direkt am Park', 3, 18);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (6, 549.00, 70, 'mit Blick auf Eiffelturm', 2, 19);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (7, 159.00, 110, 'Dachterrassewohnung zentral', 6, 20);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (8, 240.00, 200, 'zweigeschoessiges Haus', 12, 21);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (9, 159.00, 111, 'Topvilla am Strand', 5, 22);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (10, 299.00, 100, 'Ferienhaus am Strand', 4, 23);
INSERT INTO Ferienwohnung (FerienWohnungsNr, Preis_in_Euro, größe_in_qm, beschreibung, Anzahl_Zimmer, Adresse) VALUES (11, 150.00, 100, 'Strandbungalow', 4, 24);

-- BILD (Ferienwohnung_Nr -> Ferienwohnung)
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (1, 'pics/1_1.jpg', 'Aussenansicht', 1);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (2, 'pics/1_2.jpg', 'Innenansicht', 1);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (3, 'pics/2_1.jpg', 'Aussenansicht', 2);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (4, 'pics/2_2.jpg', 'Innenansicht', 2);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (5, 'pics/2_3.jpg', 'Draufsicht', 2);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (6, 'pics/2_4.jpg', 'Innenansicht', 2);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (7, 'pics/5_1.gif', 'Garage', 5);
INSERT INTO Bild (Bild_ID, Dateipfad, Beschreibung, Ferienwohnung) VALUES (8, 'pics/8.jpg', 'Dachterrasse', 8);

-- KUNDE (E_Mail -> "E-Mail", Adresse_ID -> Adresse, IBAN -> Bankverbindung)
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (1, '1960-01-01', '07531-123456', 'Napf', 'Karl', 'knapf@gmx.de', 8, 'DE85692717230007823212');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (2, '1975-01-02', '06221-999888', 'Meier', 'Hans', 'meiers.hans@t-online.de', 9, 'DE83692717230008929368');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (3, '1980-01-03', '0711-554673', 'Huber', 'Franz', 'huber@t-online.de', 10, 'DE85692717230001347291');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (4, '1985-01-04', '+41-171-9864785', 'Eber', 'Klaus', 'eber@bluewin.ch', 11, 'CH85692717230008792978');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (5, '1990-01-05', '+41-171-9864786', 'Meier', 'Egon', 'meier@gmail. com', 12, 'CH85692717230009082780');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (6, '1995-01-06', '0171-9876543', 'Knopf', 'Jim', 'jim.knopf@gmx.net', 13, 'DE85692717230007322890');
INSERT INTO Kunde (KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, "E-Mail", Adresse, Bankverbindung) VALUES (7, '2000-01-01', '0171-9876544', 'Knopf', 'Lukas', 'lukas.knopf@gmx.net', 13, 'DE8569271723001234567');

-- BELEGUNG (Ferienwohnung_Nr -> Ferienwohnung, KundenNr -> Kunde)
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (1, '2026-02-12', '2026-03-11', '2026-03-13', 'Buchung', 4, 2);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (2, '2026-03-13', '2026-05-11', '2026-05-17', 'Reservierung', 5, 2);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (3, '2026-02-10', '2026-04-03', '2026-04-23', 'Reservierung', 5, 3);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (4, '2026-02-09', '2026-07-04', '2026-07-05', 'Buchung', 6, 4);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (5, '2026-02-14', '2026-04-28', '2026-05-02', 'Reservierung', 10, 2);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (6, '2026-02-18', '2026-05-04', '2026-05-22', 'Buchung', 8, 3);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (7, '2026-02-01', '2026-05-07', '2026-05-08', 'Buchung', 2, 1);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (8, '2026-02-11', '2026-05-22', '2026-05-28', 'Buchung', 9, 5);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (9, '2026-02-07', '2026-07-03', '2026-07-08', 'Buchung', 10, 5);
INSERT INTO Belegung (BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) VALUES (10, '2026-02-10', '2026-05-01', '2026-05-24', 'Reservierung', 1, 4);

-- RECHNUNG (Rechnungsdatum -> Datum, BelegNummer -> Buchung, + Zahlungsstatus)
INSERT INTO Rechnung (Rechnungsnummer, Zahlungseingangsdatum, Betrag, Datum, Buchung, Zahlungsstatus) VALUES (1, '2026-03-18', 498.00, '2026-03-15', 1, 'bezahlt');
INSERT INTO Rechnung (Rechnungsnummer, Zahlungseingangsdatum, Betrag, Datum, Buchung, Zahlungsstatus) VALUES (2, NULL, 549.00, '2026-02-26', 4, 'offen');

-- VERBINDET (Fluggesellschaft_IATA -> Flugesselschaft_IATA wegen PDF-Tippfehler in Schema)
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('BCN', 'CDG', 'PWF');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('CDG', 'BCN', 'HLF');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('CDG', 'BCN', 'PWF');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('CDG', 'ZRH', 'GWI');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'BCN', 'DLH');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'CDG', 'DLH');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'CDG', 'GWI');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'CDG', 'PWF');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'CDG', 'TCX');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('FRA', 'IST', 'GWI');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('IST', 'BCN', 'TCX');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('STR', 'CDG', 'DLH');
INSERT INTO verbindet (Start_IATA, Ziel_IATA, Flugesselschaft_IATA) VALUES ('STR', 'CDG', 'TCX');

-- TOURISTENATTRAKTION (Adresse_ID -> Adresse)
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('Europapark', 25, 'Freizeitpark: Deutschlands Nr. 1');
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('Hoernle', 26, 'Badestrand: Bodensee-Strandbad');
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('Flims-Laax Arena', 27, 'Skigebiet');
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('GreenOne', 28, 'Golfplatz');
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('Disneyland Paris', 29, 'Freizeitpark');
INSERT INTO Touristenattraktion (Name, Adresse, Beschreibung) VALUES ('Disneyland USA', 30, 'Freizeitpark: Nachbau von Disnelyland Paris');

-- FEWO_HAT_ZUSATZAUSSTATTUNG (Tabellenname korrigiert: Doppel-s)
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (1, 'Schwimmbad');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (1, 'Sauna');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (2, 'Autoabstellplatz');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (2, 'Aufzug');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (3, 'Sauna');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (5, 'Kinderbetreuung');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (5, 'Schwimmbad');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (6, 'Schwimmbad');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (7, 'Schwimmbad');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (8, 'Sat-TV');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (8, 'Reinigung');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (8, 'Dachterrasse');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (9, 'Garage');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (9, 'Schwimmbad');
INSERT INTO Ferienwohnung_hat_Zusatzausstattung (Fewo_Nr, Bezeichnung) VALUES (11, 'Schwimmbad');

-- ENTFERNUNG
INSERT INTO Entfernung (Ort1_ID, Ort2_ID, KM) VALUES (4, 17, 30);
INSERT INTO Entfernung (Ort1_ID, Ort2_ID, KM) VALUES (8, 10, 180);
INSERT INTO Entfernung (Ort1_ID, Ort2_ID, KM) VALUES (12, 3, 120);
INSERT INTO Entfernung (Ort1_ID, Ort2_ID, KM) VALUES (12, 13, 40);
INSERT INTO Entfernung (Ort1_ID, Ort2_ID, KM) VALUES (16, 17, 420);

-- INTER-RELATIONALE INTEGRITÄTSBEDINGUNGEN
INSERT INTO AdditionalDocumentation (Kuerzel, Beschreibung, Typ) 
VALUES (
    'IB_RECHNUNG_STATUS', 
    'Nur eine Buchung (Belegung mit Status=Buchung) kann eine Rechnung zugeordnet haben.', 
    'Integritaetsbedingung'
);

INSERT INTO AdditionalDocumentation (Kuerzel, Beschreibung, Typ) 
VALUES (
    'IB_ADRESSE_EXKLUSIV', 
    'Ein Eintrag in Adresse muss entweder genau einer FeWo, einem Kunden, einer Touristenattraktion oder einem Flughafen zugeordnet sein.', 
    'Integritaetsbedingung'
);

INSERT INTO AdditionalDocumentation (Kuerzel, Beschreibung, Typ) 
VALUES (
    'IB_RECHNUNGSDATUM', 
    'Das Rechnungsdatum muss groesser oder gleich dem Datum der zugeordneten Belegung (Buchungsdatum) sein.', 
    'Integritaetsbedingung'
);

INSERT INTO AdditionalDocumentation (Kuerzel, Beschreibung, Typ) 
VALUES (
    'ERL_ZYKLUS_ORT', 
    'Zyklische Abhaengigkeit ueber Fremdschluessel: Ort -> Flughafen -> Adresse -> Ort.', 
    'Erlaeuterung'
);

INSERT INTO AdditionalDocumentation (Kuerzel, Beschreibung, Typ) 
VALUES (
    'ERL_ENTFERNUNG', 
    'Entfernung eines Ortes von sich selbst betraegt 0 km. Gibt es keinen Eintrag fuer zwei Orte, ist die Distanz unbekannt.', 
    'Erlaeuterung'
);
COMMIT;