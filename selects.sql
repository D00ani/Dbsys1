--1)
Select Ferienwohnung
From Belegung 
WHERE ferienwohnung = &fewo
    
-- 2)
SELECT DISTINCT 
    Kunde.Name, 
    Kunde.Vorname, 
    Kunde.Geburtsdatum 
FROM 
    Kunde, 
    Belegung
WHERE 
    Kunde.KundenNr = Belegung.Kunde
    AND Belegung.Ferienwohnung = &fewo
    AND Belegung.Status = 'Reservierung'
ORDER BY 
    Kunde.Name ASC, 
    Kunde.Geburtsdatum DESC;
    
--3)kunden 
SELECT COUNT(*) AS Anzahl_Buchungen
FROM Kunde, Belegung 
WHERE Kunde.KundenNr = Belegung.Kunde
    AND Belegung.Status = 'Buchung' 
    AND Kunde.KundenNr = &kundennummer;

--4)
SELECT
    k.KundenNr,
    k.Name,
    k.Vorname,
    COUNT (*) AS Anzahl_Buchungen
FROM Kunde k, Belegung b
WHERE k.KundenNr = b.Kunde
    AND k.Name = '&nachname'
    AND b.Status = 'Buchung'
GROUP BY k.KundenNr, k.Name, k.Vorname;

--5)
SELECT 
    MIN(PREIS_IN_EURO) AS Min_Preis, 
    MAX(PREIS_IN_EURO) AS Max_Preis, 
    AVG(PREIS_IN_EURO) AS Average_PREIS,
    MIN(PREIS_IN_EURO / GRÖßE_IN_QM) AS Min_Preis_pro_qm,
    MAX(PREIS_IN_EURO / GRÖßE_IN_QM) AS Max_Preis_pro_qm,
    AVG(PREIS_IN_EURO / GRÖßE_IN_QM) AS Average_Preis_pro_qm
FROM FERIENWOHNUNG;

--6)
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z
WHERE 
    f.FERIENWOHNUNGSNR = z.FEWO_NR
    AND z.BEZEICHNUNG = 'Sauna';
    
--7)
SELECT DISTINCT
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z
WHERE 
    f.FERIENWOHNUNGSNR = z.FEWO_NR
    AND (z.BEZEICHNUNG = 'Schwimmbad' OR z.BEZEICHNUNG = 'Sauna');
    
--8)
SELECT f.FERIENWOHNUNGSNR, f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z1, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z2
WHERE 
    f.FERIENWOHNUNGSNR = z1.FEWO_NR
    AND f.FERIENWOHNUNGSNR = z2.FEWO_NR
    AND z1.BEZEICHNUNG = 'Schwimmbad'
    AND z2.BEZEICHNUNG = 'Sauna';
    
--9)
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z
WHERE 
    f.FERIENWOHNUNGSNR = z.FEWO_NR
    AND z.BEZEICHNUNG IN ('Schwimmbad', 'Sauna', 'Kinderbetreuung')
GROUP BY 
    f.FERIENWOHNUNGSNR, f.BESCHREIBUNG
HAVING 
    COUNT(*) >= 2;
    
--10)
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.PREIS_IN_EURO, 
    f.GRÖßE_IN_QM, 
    f.BESCHREIBUNG, 
    f.ANZAHL_ZIMMER,
    a.STRAßE, 
    a.HAUSNUMMER, 
    a.PLZ, 
    o.NAME AS ORTSNAME, 
    l.NAME AS LANDNAME
FROM 
    FERIENWOHNUNG f, 
    ADRESSE a, 
    ORT o, 
    LAND l
WHERE 
    f.ADRESSE = a.ADRESSID      
    AND a.ORT = o.ORT_ID        
    AND o.LAND = l.ISOCODE      
    AND l.NAME = 'Frankreich'   
ORDER BY 
    a.PLZ ASC, 
    o.NAME ASC, 
    f.FERIENWOHNUNGSNR ASC;
    
    
--11
SELECT f.FerienWohnungsNr, (f.Preis_in_Euro / f.größe_in_qm) AS Preis_pro_qm
FROM Ferienwohnung f, Adresse a, Ort o, Land l
WHERE f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND l.Name = 'Frankreich'
  AND (
      o.Name = 'Disneyland' 
      OR 
      o.Ort_ID IN (
          SELECT e.Ort1_ID FROM Entfernung e WHERE e.KM <= 50 AND e.Ort2_ID IN (
              SELECT Ort_ID FROM Ort WHERE Name = 'Disneyland' AND Land = 'FR'
          )
          UNION
          SELECT e.Ort2_ID FROM Entfernung e WHERE e.KM <= 50 AND e.Ort1_ID IN (
              SELECT Ort_ID FROM Ort WHERE Name = 'Disneyland' AND Land = 'FR'
          )
      )
  )
ORDER BY Preis_pro_qm DESC, f.FerienWohnungsNr ASC;
--12)
SELECT 
    f.Beschreibung, 
    f.FerienWohnungsNr
FROM 
    Ferienwohnung f, 
    Adresse a_fewo, 
    Ort o_fewo,
    Touristenattraktion t, 
    Adresse a_attrakt, 
    Ort o_attrakt,
    Entfernung e
WHERE 
    f.Adresse = a_fewo.AdressID
    AND a_fewo.Ort = o_fewo.Ort_ID
    
    AND t.Adresse = a_attrakt.AdressID
    AND a_attrakt.Ort = o_attrakt.Ort_ID
    AND t.Name = 'Disneyland Paris'
    
    AND (
        (e.Ort1_ID = o_fewo.Ort_ID AND e.Ort2_ID = o_attrakt.Ort_ID)
        OR 
        (e.Ort2_ID = o_fewo.Ort_ID AND e.Ort1_ID = o_attrakt.Ort_ID)
    )
    
    AND e.KM >= 100;
--13.1)    
SELECT DISTINCT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, 
     Ferienwohnung_hat_Zusatzausstattung z, Belegung b
WHERE f.FerienWohnungsNr = b.Ferienwohnung
  AND f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich';
  --13.2)
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND f.FerienWohnungsNr IN (SELECT Belegung.Ferienwohnung FROM Belegung);
  --13.3)
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND EXISTS (
      SELECT 1 
      FROM Belegung b 
      WHERE b.Ferienwohnung = f.FerienWohnungsNr
  );
  --13.4)
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND (SELECT COUNT(*) FROM Belegung b WHERE b.Ferienwohnung = f.FerienWohnungsNr) >= 1;
  --13.5)
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
INTERSECT                            --schnittmenge
SELECT f2.Beschreibung, f2.FerienWohnungsNr
FROM Ferienwohnung f2, Belegung b
WHERE f2.FerienWohnungsNr = b.Ferienwohnung;
--14.1
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND f.FerienWohnungsNr NOT IN (
      SELECT Belegung.Ferienwohnung 
      FROM Belegung 
      WHERE Belegung.Ferienwohnung IS NOT NULL --??
  );
--14.2
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND NOT EXISTS (
      SELECT 1 
      FROM Belegung b 
      WHERE b.Ferienwohnung = f.FerienWohnungsNr
  );
--14.3
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND (SELECT COUNT(*) FROM Belegung b WHERE b.Ferienwohnung = f.FerienWohnungsNr) = 0;
--14.4
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
MINUS
SELECT f2.Beschreibung, f2.FerienWohnungsNr
FROM Ferienwohnung f2, Belegung b
WHERE f2.FerienWohnungsNr = b.Ferienwohnung;
--14.5
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f
JOIN Adresse a ON f.Adresse = a.AdressID
JOIN Ort o ON a.Ort = o.Ort_ID
JOIN Land l ON o.Land = l.Isocode
JOIN Ferienwohnung_hat_Zusatzausstattung z ON f.FerienWohnungsNr = z.Fewo_Nr
LEFT OUTER JOIN Belegung b ON f.FerienWohnungsNr = b.Ferienwohnung
WHERE z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND b.BelegNummer IS NULL;
--15.1
SELECT DISTINCT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, 
     Ferienwohnung_hat_Zusatzausstattung z, Belegung b
WHERE f.FerienWohnungsNr = b.Ferienwohnung
  AND f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND b.Status = 'Reservierung';
--15.2
SELECT DISTINCT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, 
     Ferienwohnung_hat_Zusatzausstattung z, Belegung b
WHERE f.FerienWohnungsNr = b.Ferienwohnung
  AND f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND b.Status = 'Buchung';
--16.1
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND NOT EXISTS (
      SELECT 1 
      FROM Belegung b 
      WHERE b.Ferienwohnung = f.FerienWohnungsNr 
        AND b.Status = 'Reservierung'
  );
--16.2
SELECT f.Beschreibung, f.FerienWohnungsNr
FROM Ferienwohnung f, Adresse a, Ort o, Land l, Ferienwohnung_hat_Zusatzausstattung z
WHERE f.FerienWohnungsNr = z.Fewo_Nr
  AND f.Adresse = a.AdressID
  AND a.Ort = o.Ort_ID
  AND o.Land = l.Isocode
  AND z.Bezeichnung = 'Schwimmbad'
  AND l.Name = 'Frankreich'
  AND NOT EXISTS (
      SELECT 1 
      FROM Belegung b 
      WHERE b.Ferienwohnung = f.FerienWohnungsNr 
        AND b.Status = 'Buchung'
        );
        
        
--17
SELECT f.BESCHREIBUNG, f.FERIENWOHNUNGSNR
FROM FERIENWOHNUNG f, ADRESSE a, ORT o, LAND l, FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z
WHERE f.FERIENWOHNUNGSNR = z.FEWO_NR
  AND f.ADRESSE = a.ADRESSID
  AND a.ORT = o.ORT_ID
  AND o.LAND = l.ISOCODE
  AND z.BEZEICHNUNG = 'Schwimmbad'
  AND l.NAME = 'Türkei'
  AND EXISTS (
      SELECT 1
      FROM BELEGUNG b 
      WHERE b.FERIENWOHNUNG = f.FERIENWOHNUNGSNR 
        AND b.VON <= TO_DATE('21.05.2026', 'DD.MM.YYYY')
        AND b.BIS >= TO_DATE('01.05.2026', 'DD.MM.YYYY')
  );
        
--18
SELECT DISTINCT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    ADRESSE a, 
    ORT o, 
    LAND l, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z
WHERE 
    f.ADRESSE = a.ADRESSID
    AND a.ORT = o.ORT_ID
    AND o.LAND = l.ISOCODE
    AND f.FERIENWOHNUNGSNR = z.FEWO_NR
    AND l.NAME = 'Türkei'
    AND z.BEZEICHNUNG = 'Schwimmbad'
    AND NOT EXISTS (
        SELECT 1 
        FROM BELEGUNG b 
        WHERE b.FERIENWOHNUNG = f.FERIENWOHNUNGSNR 
          AND b.VON <= TO_DATE('21.05.2026', 'DD.MM.YYYY')
          AND b.BIS >= TO_DATE('01.05.2026', 'DD.MM.YYYY')
    );
    
--19)
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG, 
    COUNT(*) AS ANZAHL_BUCHUNGEN
FROM 
    FERIENWOHNUNG f, 
    ADRESSE a, 
    ORT o, 
    LAND l, 
    FERIENWOHNUNG_HAT_ZUSATZAUSSTATTUNG z, 
    BELEGUNG b
WHERE 
    f.ADRESSE = a.ADRESSID
    AND a.ORT = o.ORT_ID
    AND o.LAND = l.ISOCODE
    AND f.FERIENWOHNUNGSNR = z.FEWO_NR
    AND f.FERIENWOHNUNGSNR = b.FERIENWOHNUNG
    AND l.NAME = 'Türkei'
    AND z.BEZEICHNUNG = 'Schwimmbad'
    AND b.VON <= TO_DATE('21.05.2026', 'DD.MM.YYYY')
    AND b.BIS >= TO_DATE('01.05.2026', 'DD.MM.YYYY')
GROUP BY 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
HAVING 
    COUNT(*) >= 1 
    AND COUNT(*) <= 2;

--20
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f
WHERE f.FERIENWOHNUNGSNR IN (
        SELECT b.FERIENWOHNUNG
        FROM BILD b
        GROUP BY b.FERIENWOHNUNG
        HAVING COUNT(*) = 2 OR COUNT(*) = 4
    );
    
SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, BILD b
WHERE f.FERIENWOHNUNGSNR = b.Ferienwohnung
GROUP BY f.FERIENWOHNUNGSNR, f.BESCHREIBUNG
        HAVING COUNT(*) IN(2,4)
    ;


--21

SELECT 
    f.FERIENWOHNUNGSNR, 
    f.BESCHREIBUNG
FROM 
    FERIENWOHNUNG f, 
    ADRESSE a, 
    ORT o, 
    LAND l, 
    BELEGUNG b
WHERE 
    f.ADRESSE = a.ADRESSID
    AND a.ORT = o.ORT_ID
    AND o.LAND = l.ISOCODE
    AND l.NAME = 'Frankreich'
    AND f.FERIENWOHNUNGSNR = b.FERIENWOHNUNG
GROUP BY 
    f.FERIENWOHNUNGSNR, f.BESCHREIBUNG
HAVING 
    COUNT(*) > (
        SELECT COUNT(*)
        FROM FERIENWOHNUNG f2, ADRESSE a2, ORT o2, LAND l2
        WHERE f2.ADRESSE = a2.ADRESSID
          AND a2.ORT = o2.ORT_ID
          AND o2.LAND = l2.ISOCODE
          AND l2.NAME = 'Deutschland'
    );
   
--22

SELECT 
    l.NAME AS LANDNAME, 
    MIN(f.PREIS_IN_EURO) AS MIN_PREIS, 
    MAX(f.PREIS_IN_EURO) AS MAX_PREIS, 
    AVG(f.PREIS_IN_EURO) AS DURCHSCHNITT_PREIS
FROM 
    FERIENWOHNUNG f, 
    ADRESSE a, 
    ORT o, 
    LAND l
WHERE 
    f.ADRESSE = a.ADRESSID      
    AND a.ORT = o.ORT_ID        
    AND o.LAND = l.ISOCODE      
GROUP BY 
    l.NAME;


--23

SELECT 
    l.NAME AS LANDNAME, 
    COUNT(b.FERIENWOHNUNG) AS ANZAHL_BELEGUNGEN
FROM 
    LAND l
    LEFT OUTER JOIN ORT o ON l.ISOCODE = o.LAND
    LEFT OUTER JOIN ADRESSE a ON o.ORT_ID = a.ORT
    LEFT OUTER JOIN FERIENWOHNUNG f ON a.ADRESSID = f.ADRESSE
    LEFT OUTER JOIN BELEGUNG b ON f.FERIENWOHNUNGSNR = b.FERIENWOHNUNG
GROUP BY 
    l.NAME
ORDER BY 
    l.NAME ASC;
    

SELECT * 
FROM 
    LAND l
    LEFT OUTER JOIN ORT o ON l.ISOCODE = o.LAND
    LEFT OUTER JOIN ADRESSE a ON o.ORT_ID = a.ORT
    LEFT OUTER JOIN FERIENWOHNUNG f ON a.ADRESSID = f.ADRESSE
    LEFT OUTER JOIN BELEGUNG b ON f.FERIENWOHNUNGSNR = b.FERIENWOHNUNG
ORDER BY 
    l.NAME ASC;
    


SELECT 
    l.Name AS Landname, 
    COUNT(b.BelegNummer) AS Anzahl_Belegungen
FROM Land l
LEFT OUTER JOIN Ort o 
    ON l.Isocode = o.Land
LEFT OUTER JOIN Adresse a 
    ON o.Ort_ID = a.Ort
LEFT OUTER JOIN Ferienwohnung f 
    ON a.AdressID = f.Adresse
LEFT OUTER JOIN Belegung b 
    ON f.FerienWohnungsNr = b.Ferienwohnung
GROUP BY l.Name
ORDER BY Anzahl_Belegungen DESC, l.Name ASC;

--24)
SELECT 
    f.FerienWohnungsNr AS "Nummer FeWo",
    COUNT(CASE WHEN b.Status = 'Reservierung' THEN 1 ELSE NULL END) AS Anz_Reservierungen,
    SUM(CASE WHEN b.Status = 'Buchung' THEN 1 END) AS Anz_Buchungen,
    COUNT(b.BelegNummer) AS Anz_Belegungen
FROM Ferienwohnung f
LEFT OUTER JOIN Belegung b 
    ON f.FerienWohnungsNr = b.Ferienwohnung
GROUP BY f.FerienWohnungsNr, f.beschreibung
ORDER BY 
    Anz_Belegungen DESC, 
    Anz_Buchungen DESC, 
    Anz_Reservierungen DESC, 
    f.FerienWohnungsNr ASC;

--25)
SELECT DISTINCT 
    fg.Name AS Fluggesellschaft
FROM 
    Fluggesellschaft fg,
    verbindet v,
    Flughafen f_start,
    Adresse a_start,
    Ort o_start,
    Land l_start,
    Flughafen f_ziel,
    Adresse a_ziel,
    Ort o_ziel,
    Land l_ziel
WHERE 
    fg.IATACode = v.Flugesselschaft_IATA
    
    AND v.Start_IATA = f_start.IATACode
    AND f_start.Adresse = a_start.AdressID
    AND a_start.Ort = o_start.Ort_ID
    AND o_start.Land = l_start.Isocode
    
    AND v.Ziel_IATA = f_ziel.IATACode
    AND f_ziel.Adresse = a_ziel.AdressID
    AND a_ziel.Ort = o_ziel.Ort_ID
    AND o_ziel.Land = l_ziel.Isocode
    
    AND l_start.Name = 'Deutschland'
    AND l_ziel.Name = 'Frankreich';
    
--26.1) 
SELECT DISTINCT fg.Name, fg.Service_Qualität
FROM Fluggesellschaft fg, verbindet v, 
     Flughafen f1, Adresse a1, Ort o1, Land l1,
     Flughafen f2, Adresse a2, Ort o2, Land l2
WHERE fg.IATACode = v.Flugesselschaft_IATA
  AND v.Start_IATA = f1.IATACode AND f1.Adresse = a1.AdressID AND a1.Ort = o1.Ort_ID AND o1.Land = l1.Isocode
  AND v.Ziel_IATA = f2.IATACode AND f2.Adresse = a2.AdressID AND a2.Ort = o2.Ort_ID AND o2.Land = l2.Isocode
  AND l1.Name = 'Deutschland' AND l2.Name = 'Frankreich'
  AND fg.Service_Qualität = (
      SELECT MAX(fg2.Service_Qualität)
      FROM Fluggesellschaft fg2, verbindet v2, 
           Flughafen f1_sub, Adresse a1_sub, Ort o1_sub, Land l1_sub,
           Flughafen f2_sub, Adresse a2_sub, Ort o2_sub, Land l2_sub
      WHERE fg2.IATACode = v2.Flugesselschaft_IATA
        AND v2.Start_IATA = f1_sub.IATACode AND f1_sub.Adresse = a1_sub.AdressID AND a1_sub.Ort = o1_sub.Ort_ID AND o1_sub.Land = l1_sub.Isocode
        AND v2.Ziel_IATA = f2_sub.IATACode AND f2_sub.Adresse = a2_sub.AdressID AND a2_sub.Ort = o2_sub.Ort_ID AND o2_sub.Land = l2_sub.Isocode
        AND l1_sub.Name = 'Deutschland' AND l2_sub.Name = 'Frankreich'
  );
  
  --26.2)
  WITH DE_FR_Airlines AS (
    SELECT DISTINCT fg.Name, fg.Service_Qualität
    FROM Fluggesellschaft fg, verbindet v, 
         Flughafen f1, Adresse a1, Ort o1, Land l1,
         Flughafen f2, Adresse a2, Ort o2, Land l2
    WHERE fg.IATACode = v.Flugesselschaft_IATA
      AND v.Start_IATA = f1.IATACode AND f1.Adresse = a1.AdressID AND a1.Ort = o1.Ort_ID AND o1.Land = l1.Isocode
      AND v.Ziel_IATA = f2.IATACode AND f2.Adresse = a2.AdressID AND a2.Ort = o2.Ort_ID AND o2.Land = l2.Isocode
      AND l1.Name = 'Deutschland' AND l2.Name = 'Frankreich'
)
SELECT Name, Service_Qualität
FROM DE_FR_Airlines
WHERE Service_Qualität = (SELECT MAX(Service_Qualität) FROM DE_FR_Airlines);