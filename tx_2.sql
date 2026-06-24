SET TRANSACTION READ WRITE NAME 'TX2_Kunde_Umziehen';

UPDATE Adresse 
SET Straße = 'Schloßstraße', 
    Hausnummer = '1', 
    PLZ = '69115', 
    Ort = (SELECT o.Ort_ID FROM Ort o JOIN Land l ON o.Land = l.Isocode WHERE o.Name = 'Heidelberg' AND l.Name = 'Deutschland')
WHERE AdressID = (SELECT Adresse FROM Kunde WHERE KundenNr = 1);

UPDATE Kunde 
SET TelefonNummer = '06221-546372' 
WHERE KundenNr = 1;

COMMIT;