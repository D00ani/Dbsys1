CREATE TABLE Land (
    Isocode CHAR(2) NOT NULL,
    Name VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Land PRIMARY KEY (Isocode),
    CONSTRAINT ak_Land_Name UNIQUE (Name)
);

CREATE TABLE Zusatzausstattung (
    Bezeichnung VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Zusatzaustattung PRIMARY KEY (Bezeichnung)
);

CREATE TABLE Bankverbindung (
    IBAN VARCHAR(34) NOT NULL,
    BLZ CHAR(8), 
    BIC VARCHAR(14) NOT NULL, 
    Kontonummer CHAR(16) NOT NULL,
    CONSTRAINT pk_Bankverbindung PRIMARY KEY (IBAN),
    CONSTRAINT ak_Bankverbindung UNIQUE (Kontonummer, BIC)
);
COMMENT ON TABLE Bankverbindung IS 'IBAN, BLZ, BIC, Kontonummer müssen gültige Formate haben. KontoNR, Blz nur eindeutig aber + AK weil BLZ optional';

--BEGINN ZYKLUS (Ort -> Flughafen -> Adresse -> Ort)

CREATE TABLE Ort (
    Ort_ID INTEGER NOT NULL CHECK (Ort_ID > 0), 
    Name VARCHAR(256) NOT NULL,
    Land CHAR(2) NOT NULL,
    bester_flughafen CHAR(3), 
    CONSTRAINT pk_Ort PRIMARY KEY (Ort_ID),
    CONSTRAINT fk_Ort_Land FOREIGN KEY (Land) REFERENCES Land(Isocode)
);

CREATE TABLE Adresse (
    AdressID INTEGER NOT NULL CHECK (AdressID > 0), 
    Straße VARCHAR(256) NOT NULL,
    Ort INTEGER NOT NULL, 
    PLZ VARCHAR(8) NOT NULL,
    Hausnummer VARCHAR(16) NOT NULL,
    CONSTRAINT pk_Adresse PRIMARY KEY (AdressID),
    CONSTRAINT fk_Adresse_Ort FOREIGN KEY (Ort) REFERENCES Ort(Ort_ID)
);

CREATE TABLE Flughafen (
    IATACode CHAR(3) NOT NULL,
    Name VARCHAR(256) NOT NULL,
    Adresse INTEGER NOT NULL, 
    CONSTRAINT pk_Flughafen PRIMARY KEY (IATACode),
    CONSTRAINT ak_Flughafen_Name UNIQUE (Name),
    -- AUFGABE 2: Verzögerter Constraint zur Lösung des Zyklus
    CONSTRAINT fk_Flughafen_Adresse FOREIGN KEY (Adresse) REFERENCES Adresse(AdressID) DEFERRABLE INITIALLY DEFERRED
);

-- AUFGABE 2: Schließen des Zyklus mit verzögertem Constraint
ALTER TABLE Ort ADD CONSTRAINT fk_Ort_Flughafen 
FOREIGN KEY (bester_flughafen) REFERENCES Flughafen(IATACode) 
DEFERRABLE INITIALLY DEFERRED;

COMMENT ON TABLE Ort IS 'Teil einer zyklischen Abhängigkeit: Ort -> Flughafen -> Adresse -> Ort.';
COMMENT ON COLUMN Ort.bester_flughafen IS 'DEFERRABLE INITIALLY DEFERRED: Constraint-Prüfung wird ans Transaktionsende verschoben, um die zyklische Abhängigkeit Ort->Flughafen->Adresse->Ort beim Einfügen/Löschen zu umgehen.';
COMMENT ON COLUMN Flughafen.Adresse IS 'DEFERRABLE INITIALLY DEFERRED: Flankiert die verzögerte Prüfung im Zyklus Ort->Flughafen->Adresse.';
COMMENT ON TABLE Adresse IS 'Inter-relationale Bedingung: Jede Adresse muss zwingend einer Ferienwohnung, einem Kunden, einer Touristenattraktion oder einem Flughafen zugeordnet sein.';

--Ende des Zyklus

CREATE TABLE Fluggesellschaft (
    IATACode CHAR(3) NOT NULL,
    Service_Qualität INTEGER NOT NULL,
    Name VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Fluggesellschaft PRIMARY KEY (IATACode),
    CONSTRAINT ak_Fluggesellschaft_Name UNIQUE (Name),
    CONSTRAINT check_Service_Qualität CHECK (Service_Qualität > 0 AND Service_Qualität <= 10)
);
COMMENT ON TABLE Fluggesellschaft IS '10 ist besser als 0';

CREATE TABLE Ferienwohnung (
    FerienWohnungsNr INTEGER NOT NULL, 
    Preis_in_Euro DECIMAL(8,2) NOT NULL,
    größe_in_qm FLOAT CHECK (größe_in_qm > 0), 
    beschreibung VARCHAR(256) NOT NULL,
    Anzahl_Zimmer INTEGER CHECK (Anzahl_Zimmer > 0), 
    Adresse INTEGER NOT NULL,
    CONSTRAINT pk_Ferienwohnung PRIMARY KEY (FerienWohnungsNr),
    CONSTRAINT check_Preis CHECK (Preis_in_Euro > 0), 
    CONSTRAINT fk_Ferienwohnung_Adresse FOREIGN KEY (Adresse) REFERENCES Adresse(AdressID) DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE Bild (
    Bild_ID INTEGER NOT NULL, 
    Dateipfad VARCHAR(256) NOT NULL,
    Beschreibung VARCHAR(256) NOT NULL,
    Ferienwohnung INTEGER NOT NULL CHECK (Ferienwohnung > 0), 
    CONSTRAINT pk_Bild PRIMARY KEY (Bild_ID),
    -- AUFGABE 2: ON DELETE CASCADE (1/4)
    CONSTRAINT fk_Bild_Fewo FOREIGN KEY (Ferienwohnung) REFERENCES Ferienwohnung(FerienWohnungsNr) ON DELETE CASCADE
);
COMMENT ON TABLE Bild IS 'Zyklische Abhängigkeit über Fremdschlüssel: Ort --[ZugeordneterFlughafen]-> Flughafen --[Adresse]-> Adresse --[Ort]--> Ort';
COMMENT ON COLUMN Bild.Ferienwohnung IS 'ON DELETE CASCADE: Wird eine FeWo gelöscht, werden auch ihre Bilder aus der DB gelöscht.';

CREATE TABLE Kunde (
    KundenNr INTEGER NOT NULL, 
    Geburtsdatum DATE NOT NULL,
    TelefonNummer VARCHAR(256) NOT NULL,
    Name VARCHAR(256) NOT NULL,
    Vorname VARCHAR(256) NOT NULL,
    Adresse INTEGER NOT NULL CHECK (Adresse > 0), 
    Bankverbindung VARCHAR(34) NOT NULL,
    "E-Mail" VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Kunde PRIMARY KEY (KundenNr),
    CONSTRAINT fk_Kunde_Adresse FOREIGN KEY (Adresse) REFERENCES Adresse(AdressID),
    CONSTRAINT fk_Kunde_Bank FOREIGN KEY (Bankverbindung) REFERENCES Bankverbindung(IBAN)
);
COMMENT ON COLUMN Kunde.Geburtsdatum IS 'Intra-relationale Bedingung: Geburtsdatum muss in der Vergangenheit liegen (< SYSDATE).';

CREATE TABLE Belegung (
    BelegNummer INTEGER NOT NULL CHECK (BelegNummer > 0), 
    Belegdatum DATE NOT NULL,
    Von DATE NOT NULL,
    Bis DATE NOT NULL,
    Status VARCHAR(16) NOT NULL,
    Ferienwohnung INTEGER NOT NULL CHECK (Ferienwohnung > 0), 
    Kunde INTEGER NOT NULL CHECK (Kunde > 0), 
    CONSTRAINT pk_Belegung PRIMARY KEY (BelegNummer),
    CONSTRAINT check_Zeitraum CHECK (Von < Bis),
    CONSTRAINT check_Status CHECK (Status IN ('Reservierung', 'Buchung')),
    -- AUFGABE 2: ON DELETE CASCADE (2/4)
    CONSTRAINT fk_Belegung_Fewo FOREIGN KEY (Ferienwohnung) REFERENCES Ferienwohnung(FerienWohnungsNr) ON DELETE CASCADE,
    CONSTRAINT fk_Belegung_Kunde FOREIGN KEY (Kunde) REFERENCES Kunde(KundenNr)
);
COMMENT ON COLUMN Belegung.Ferienwohnung IS 'ON DELETE CASCADE: Löschen einer FeWo storniert/löscht automatisch die zugehörigen Belegungen.';
COMMENT ON COLUMN Belegung.Status IS 'kann von reservierung in Buchung aber nicht von Buchung in reservierung übergehen';

CREATE TABLE Rechnung (
    Rechnungsnummer INTEGER NOT NULL CHECK (Rechnungsnummer > 0), 
    Zahlungseingangsdatum DATE, 
    Betrag DECIMAL(16,2) NOT NULL, 
    Buchung INTEGER NOT NULL CHECK (Buchung > 0), 
    Datum DATE NOT NULL, 
    Zahlungsstatus VARCHAR(8) NOT NULL, 
    CONSTRAINT pk_Rechnung PRIMARY KEY (Rechnungsnummer),
    CONSTRAINT check_Datum CHECK (Datum <= Zahlungseingangsdatum), 
    CONSTRAINT check_Betrag CHECK (Betrag > 0), 
    CONSTRAINT ak_Rechnung_Buchung UNIQUE (Buchung),
    -- AUFGABE 2: ON DELETE CASCADE (3/4)
    CONSTRAINT fk_Rechnung_Belegung FOREIGN KEY (Buchung) REFERENCES Belegung(BelegNummer) ON DELETE CASCADE 
);
COMMENT ON TABLE Rechnung IS 'Inter-relationale Bedingungen: 1. Nur Buchungen (Status=Buchung) dürfen eine Rechnung haben. 2. Rechnungsdatum >= Datum der Belegung.';
COMMENT ON COLUMN Rechnung.Buchung IS 'ON DELETE CASCADE: Wird eine Buchung gelöscht, wird auch die dazugehörige Rechnung entfernt.';
COMMENT ON COLUMN Rechnung.Datum IS 'Muss >= Belegdatum der zugeordneten Buchung sein.';

CREATE TABLE Entfernung (
    Ort1_ID INTEGER NOT NULL CHECK (Ort1_ID > 0), 
    Ort2_ID INTEGER NOT NULL CHECK (Ort2_ID > 0), 
    KM INTEGER NOT NULL CHECK (KM > 0), 
    CONSTRAINT pk_Entfernung PRIMARY KEY (Ort1_ID, Ort2_ID),
    CONSTRAINT check_ungleich CHECK (Ort1_ID <> Ort2_ID), 
    CONSTRAINT fk_Ort1 FOREIGN KEY (Ort1_ID) REFERENCES Ort(Ort_ID),
    CONSTRAINT fk_Ort2 FOREIGN KEY (Ort2_ID) REFERENCES Ort(Ort_ID)
);
COMMENT ON TABLE Entfernung IS 'Die Entfernung eines Ortes von sich selbst ist mit Distanz 0 km anzunehmen. Gibt es keinen Eintrag für zwei verschiedene Orte in Entfernung, so ist die Distanz als unbekannt anzunehmen.';

CREATE TABLE verbindet (
    Start_IATA CHAR(3) NOT NULL,
    Ziel_IATA CHAR(3) NOT NULL,
    Flugesselschaft_IATA CHAR(3) NOT NULL, 
    CONSTRAINT pk_verbindet PRIMARY KEY (Start_IATA, Ziel_IATA, Flugesselschaft_IATA),
    CONSTRAINT fk_Start FOREIGN KEY (Start_IATA) REFERENCES Flughafen(IATACode),
    CONSTRAINT fk_Ziel FOREIGN KEY (Ziel_IATA) REFERENCES Flughafen(IATACode),
    CONSTRAINT fk_Airline FOREIGN KEY (Flugesselschaft_IATA) REFERENCES Fluggesellschaft(IATACode)
);

CREATE TABLE Touristenattraktion (
    Name VARCHAR(256) NOT NULL,
    Adresse INTEGER NOT NULL CHECK (Adresse > 0), 
    Beschreibung VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Touristenattraktion PRIMARY KEY (Name),
    CONSTRAINT fk_Attraktion_Adresse FOREIGN KEY (Adresse) REFERENCES Adresse(AdressID)
);

CREATE TABLE Ferienwohnung_hat_Zusatzausstattung (
    Fewo_Nr INTEGER NOT NULL,
    Bezeichnung VARCHAR(256) NOT NULL,
    CONSTRAINT pk_Fewo_Ausstattung PRIMARY KEY (Fewo_Nr, Bezeichnung),
    -- AUFGABE 2: ON DELETE CASCADE (4/4)
    CONSTRAINT fk_Fewo_Ausst_Nr FOREIGN KEY (Fewo_Nr) REFERENCES Ferienwohnung(FerienWohnungsNr) ON DELETE CASCADE,
    CONSTRAINT fk_Fewo_Ausst_Bez FOREIGN KEY (Bezeichnung) REFERENCES Zusatzausstattung(Bezeichnung)
);
COMMENT ON COLUMN Ferienwohnung_hat_Zusatzausstattung.Fewo_Nr IS 'ON DELETE CASCADE: Wird eine FeWo gelöscht, werden auch ihre Ausstattungszuordnungen entfernt.';

CREATE TABLE AdditionalDocumentation (
    Kuerzel VARCHAR(256),
    Beschreibung VARCHAR(256) NOT NULL,
    Typ VARCHAR(256) NOT NULL,
    CONSTRAINT PK_AdditionalDocumentation PRIMARY KEY (Kuerzel),
    CONSTRAINT C1_AdditionalDocumentation CHECK (Typ IN ('Integritaetsbedingung', 'Erlaeuterung'))
);
--Aufgabe 5 Tabelle für stornierte Buchungen
CREATE TABLE StornierteBuchung (
    Stornierungsnr     INTEGER       NOT NULL,
    Stornierungsdatum  DATE          NOT NULL,
    BuchungsNr         INTEGER       NOT NULL,
    Buchungsdatum      DATE          NOT NULL,
    Von                DATE          NOT NULL,
    Bis                DATE          NOT NULL,
    Buchungswert       DECIMAL(16,2) NOT NULL,
    Status             VARCHAR(8)    NOT NULL,
    KundenNr           INTEGER       NOT NULL,
    Kundenname         VARCHAR(256),
    FewoNr             INTEGER       NOT NULL,
    FeWoBeschreibung   VARCHAR(512),
    CONSTRAINT pk_StornierteBuchung  PRIMARY KEY (Stornierungsnr),
    CONSTRAINT ak_StornierteBuchung  UNIQUE (BuchungsNr),
    CONSTRAINT check_status_storno   CHECK (Status IN ('bezahlt','offen')),
    CONSTRAINT check_zeitraum_storno CHECK (Von < Bis)
);


--1
CREATE OR REPLACE VIEW Buchung AS
SELECT 
    BelegNummer, 
    Belegdatum, 
    Von, 
    Bis, 
    Ferienwohnung, 
    Kunde
FROM Belegung
WHERE Status = 'Buchung';

CREATE OR REPLACE VIEW Reservierung AS
SELECT 
    BelegNummer, 
    Belegdatum, 
    Von, 
    Bis, 
    Ferienwohnung, 
    Kunde
FROM Belegung
WHERE Status = 'Reservierung'
WITH CHECK OPTION CONSTRAINT chk_reservierung_view;

COMMENT ON TABLE Buchung IS 'Aktualisierbar für UPDATE und DELETE. INSERT nicht empfohlen, da der Default-Status Reservierung die Daten aus dieser Sicht ausblenden würde.';
COMMENT ON TABLE Reservierung IS 'Voll aktualisierbar (INSERT, UPDATE, DELETE). WITH CHECK OPTION erzwingt, dass neue/geänderte Datensätze immer den Status Reservierung besitzen.';

--2
CREATE OR REPLACE VIEW Familienwohnungen AS
SELECT FerienwohnungsNR, preis_in_euro, größe_in_qm, beschreibung, anzahl_zimmer, adresse 
FROM Ferienwohnung f
WHERE größe_in_qm > 100
WITH CHECK OPTION CONSTRAINT chk_familienwohnung;

COMMENT ON TABLE Familienwohnungen IS 'Teilweise aktualisierbar. Die WITH CHECK OPTION verhindert, dass Wohnungen mit weniger als oder genau 100 qm eingefügt oder dorthin geändert werden.';

--3
CREATE OR REPLACE VIEW UebersichtKunden AS
SELECT 
    k.KundenNr, 
    k.Name, 
    k.Vorname, 
    k.Adresse, 
    k.Bankverbindung,
    CASE 
        WHEN b.BelegNummer IS NULL THEN 'keine Belegung vorhanden'
        ELSE TO_CHAR(b.BelegNummer)
    END AS Belegungsnummer,
    b.Status, 
    b.Von, 
    b.Bis, 
    b.Belegdatum,
    f.FerienWohnungsNr, 
    f.Beschreibung,
    CASE 
        WHEN b.Status = 'Buchung' AND r.Rechnungsnummer IS NOT NULL 
            THEN 'Rechnung mit Rechnungsnummer ' || r.Rechnungsnummer || ' erstellt am ' || TO_CHAR(r.Datum, 'DD.MM.YYYY')
        WHEN b.Status = 'Buchung' AND r.Rechnungsnummer IS NULL 
            THEN 'noch keine Rechnung erstellt'
        ELSE NULL
    END AS Rechnungs_Info
FROM Kunde k
LEFT OUTER JOIN Belegung b 
    ON k.KundenNr = b.Kunde
LEFT OUTER JOIN Ferienwohnung f 
    ON b.Ferienwohnung = f.FerienWohnungsNr
LEFT OUTER JOIN Rechnung r 
    ON b.BelegNummer = r.Buchung;

COMMENT ON TABLE UebersichtKunden IS 'Nicht aktualisierbar. Komplexe Join-Sicht über mehrere Tabellen mit CASE-Ausdrücken.';

--4
CREATE OR REPLACE VIEW Zahlungsstatus AS
SELECT 
    r.Rechnungsnummer, 
    r.Datum AS Rechnungsdatum, 
    r.Betrag AS Rechnungsbetrag,
    CASE 
        WHEN r.Zahlungseingangsdatum IS NOT NULL THEN 'bezahlt'
        ELSE 'offen'
    END AS Zahlungsstatus,
    b.BelegNummer AS Buchungs_Nr, 
    b.Belegdatum AS Buchungsdatum, 
    b.Von, 
    b.Bis,
    f.FerienWohnungsNr, 
    f.Beschreibung,
    k.KundenNr, 
    k.Name AS Kunden_Name
FROM 
    Rechnung r, 
    Belegung b, 
    Ferienwohnung f, 
    Kunde k
WHERE 
    r.Buchung = b.BelegNummer
    AND b.Ferienwohnung = f.FerienWohnungsNr
    AND b.Kunde = k.KundenNr;

COMMENT ON TABLE Zahlungsstatus IS 'Nicht aktualisierbar. Komplexe Join-Sicht zur reinen Datenabfrage.';
    
--5
CREATE OR REPLACE VIEW MidAgeKunden AS
SELECT 
    KundenNr, 
    Name, 
    Vorname, 
    Geburtsdatum, 
    Adresse, 
    Bankverbindung,
    TRUNC(MONTHS_BETWEEN(SYSDATE, Geburtsdatum) / 12) AS KundenAlter
FROM 
    Kunde
WHERE 
    TRUNC(MONTHS_BETWEEN(SYSDATE, Geburtsdatum) / 12) BETWEEN 30 AND 40;

COMMENT ON TABLE MidAgeKunden IS 'Eingeschränkt aktualisierbar. Datensätze können geändert/gelöscht werden. Die berechnete Spalte KundenAlter erlaubt kein UPDATE oder INSERT.';    

--6
CREATE OR REPLACE VIEW MidAgeKundenOhneGebDatum AS
SELECT 
    KundenNr, 
    Name, 
    Vorname, 
    Adresse, 
    Bankverbindung,
    TRUNC(MONTHS_BETWEEN(SYSDATE, Geburtsdatum) / 12) AS KundenAlter
FROM 
    Kunde
WHERE 
    TRUNC(MONTHS_BETWEEN(SYSDATE, Geburtsdatum) / 12) BETWEEN 30 AND 40;

COMMENT ON TABLE MidAgeKundenOhneGebDatum IS 'Eingeschränkt aktualisierbar. DELETE und UPDATE auf sichtbare Spalten möglich. INSERT schlägt fehl, da das erforderliche Feld Geburtsdatum in der Sicht fehlt.';    

--7
CREATE OR REPLACE VIEW GuteFluggesellschaften AS
SELECT 
    IATACode, 
    Name, 
    Service_Qualität
FROM 
    Fluggesellschaft
WHERE 
    Service_Qualität < 5
WITH READ ONLY;

COMMENT ON TABLE GuteFluggesellschaften IS 'Nicht aktualisierbar. Die Sicht wurde explizit mit WITH READ ONLY erstellt, jegliche Änderungen an den Daten sind blockiert.';

--Trigger, Sequencen etc.

CREATE SEQUENCE seq_StornierteBuchungen
    START WITH 100
    INCREMENT BY 2;
    
    
-- Funktion aufstellen 

CREATE OR REPLACE FUNCTION preis(von DATE, bis DATE, FeWoNr INTEGER)
    RETURN DECIMAL
IS
    tagespreis DECIMAL(16,2);
BEGIN
    SELECT Preis_in_Euro INTO tagespreis
    FROM Ferienwohnung
    WHERE FerienWohnungsNr = FeWoNr;

    RETURN (bis - von) * tagespreis;
END;
/

--buchung stornieren
    
CREATE OR REPLACE TRIGGER trigger_buchung_stonieren
    BEFORE DELETE ON Belegung
    FOR EACH ROW
    WHEN (OLD.Status = 'Buchung')
DECLARE
    v_name   Kunde.Name%TYPE;
    v_beschr Ferienwohnung.Beschreibung%TYPE;
    v_status VARCHAR2(8) := 'offen';
BEGIN
    SELECT Name INTO v_name
    FROM Kunde
    WHERE KundenNr = :OLD.Kunde;

    SELECT Beschreibung INTO v_beschr
    FROM Ferienwohnung
    WHERE FerienWohnungsNr = :OLD.Ferienwohnung;

    BEGIN
        SELECT CASE WHEN Zahlungseingangsdatum IS NOT NULL
                    THEN 'bezahlt' ELSE 'offen' END
        INTO v_status
        FROM Rechnung
        WHERE Buchung = :OLD.BelegNummer;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_status := 'offen';
    END;

    INSERT INTO StornierteBuchung
        (Stornierungsnr, Stornierungsdatum, BuchungsNr, Buchungsdatum,
         Von, Bis, Buchungswert, Status, KundenNr, Kundenname, FewoNr, FeWoBeschreibung)
    VALUES
        (seq_StornierteBuchungen.NEXTVAL, SYSDATE, :OLD.BelegNummer, :OLD.Belegdatum,
         :OLD.Von, :OLD.Bis, preis(:OLD.Von, :OLD.Bis, :OLD.Ferienwohnung),
         v_status, :OLD.Kunde, v_name, :OLD.Ferienwohnung, v_beschr);
END;
/