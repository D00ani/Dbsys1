import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.ResolverStyle;
import java.util.HashSet;
import java.util.NoSuchElementException;
import java.util.Scanner;
import java.util.Set;

/**
 * Aufgabe 6 - Einbettung von SQL-Statements mittels JDBC in Java.
 *
 * Einfache Kommandozeilenanwendung mit vier Use Cases:
 *   1) Kund:in interaktiv einfuegen (Adresse + Bankverbindung + Kunde, eine Transaktion)
 *   2) Kund:innen suchen (Teilstring in Vorname ODER Name, case-insensitiv)
 *   3) Ferienwohnung reservieren oder buchen (Verfuegbarkeitspruefung im Zeitraum)
 *   4) Belegung loeschen (inkl. abhaengiger Daten ueber ON DELETE CASCADE / Trigger)
 *
 * Transaktionssteuerung:
 *   - conn.setAutoCommit(false): die Anwendung steuert Transaktionen selbst.
 *   - Jeder Use Case beginnt mit "SET TRANSACTION ... NAME ..." (wie in den .sql-Skripten)
 *     und endet auf JEDEM Programmpfad ueber commit() ODER rollback() - auch die rein
 *     lesende Suche wird mit commit() sauber beendet.
 *   - Bei SQLException wird zurueckgerollt (rollback) und der Fehler gemeldet, ohne dass
 *     sich das Programm beendet.
 *
 * Hinweis zur Schluesselvergabe:
 *   Das Schema besitzt fuer AdressID, KundenNr und BelegNummer keine Sequenzen; die
 *   Beispieldaten und tx_1.sql vergeben IDs ueber (SELECT MAX(..)+1 ..). Dieses Programm
 *   nutzt dieselbe Konvention. Soll stattdessen eine Sequenz verwendet werden, ist nur die
 *   Methode nextId(..) anzupassen.
 */
public class FerienwohnungVerwaltung {


    private static final String DEFAULT_URL  = "jdbc:oracle:thin:@oracle19c.in.htwg-konstanz.de:1521:ora19c";
    private static final String DEFAULT_USER = "dbs26";
    private static final String DEFAULT_PASS = "dbs26";

    private static final DateTimeFormatter DATE_FMT =
            DateTimeFormatter.ofPattern("dd.MM.uuuu").withResolverStyle(ResolverStyle.STRICT);

    private final Connection conn;
    private final Scanner in;

    public FerienwohnungVerwaltung(Connection conn, Scanner in) {
        this.conn = conn;
        this.in = in;
    }

    //Main/Setup
    public static void main(String[] args) {
        String url  = args.length > 0 ? args[0] : DEFAULT_URL;
        String user = args.length > 1 ? args[1] : DEFAULT_USER;
        String pass = args.length > 2 ? args[2] : DEFAULT_PASS;


        try {
            Class.forName("oracle.jdbc.OracleDriver");//JDBC
        } catch (ClassNotFoundException ignore) {

        }

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Scanner in = new Scanner(System.in)) {

            conn.setAutoCommit(false);

            new FerienwohnungVerwaltung(conn, in).menuLoop();

        } catch (SQLException e) {
            System.err.println("Verbindung zur Datenbank fehlgeschlagen: " + e.getMessage());
            System.err.println("Bitte JDBC-URL, Benutzer und Passwort pruefen "
                    + "(Aufruf: java FerienwohnungVerwaltung <url> <user> <pass>).");
        }
    }


    private void menuLoop() {
        boolean running = true;
        while (running) {
            System.out.println();
            System.out.println("==================== Ferienwohnungsverwaltung ====================");
            System.out.println("  1) Kund:in einfuegen");
            System.out.println("  2) Kund:innen suchen");
            System.out.println("  3) Ferienwohnung reservieren/buchen");
            System.out.println("  4) Belegung loeschen");
            System.out.println("  0) Beenden");
            int choice;
            try {
                choice = readInt("Auswahl: ", 0, 4);
            } catch (NoSuchElementException eof) {
                System.out.println();
                break;
            }
            switch (choice) {
                case 1: useCaseInsertKunde();      break;
                case 2: useCaseSucheKunde();       break;
                case 3: useCaseBelegungAnlegen();  break;
                case 4: useCaseBelegungLoeschen(); break;
                case 0: running = false;           break;
                default:                           break;
            }
        }
        System.out.println("Programm beendet.");
    }


    private void useCaseInsertKunde() {
        System.out.println("\n--- Neue Kund:in einfuegen ---");
        try {
            beginTx("TX_Kunde_Einfuegen", false);

            String vorname  = readNonEmpty("Vorname: ");
            String nachname = readNonEmpty("Nachname (Name): ");
            LocalDate gebDat = readPastDate("Geburtsdatum (TT.MM.JJJJ): ");
            String telefon  = readNonEmpty("Telefonnummer: ");
            String email    = readEmail("E-Mail: ");

            String strasse = readNonEmpty("Strasse: ");
            String hausnr  = readNonEmpty("Hausnummer: ");
            String plz     = readNonEmpty("PLZ: ");
            int ortId = selectOrt();
            if (ortId < 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }

            String iban        = readNonEmpty("IBAN: ");
            String bic         = readNonEmpty("BIC: ");
            String kontonummer = readNonEmpty("Kontonummer: ");
            String blz         = readLine("BLZ (optional, Enter = keine): ");

            if (bankverbindungExistiert(iban)) {
                System.out.println("Hinweis: IBAN existiert bereits - bestehende Bankverbindung wird verwendet.");
            } else {
                insertBankverbindung(iban, bic, kontonummer, blz);
            }
            //Adresse einfügen
            int adressId = nextId("Adresse", "AdressID");
            String insAdr = "INSERT INTO Adresse (AdressID, Straße, Ort, PLZ, Hausnummer) "
                          + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insAdr)) {
                ps.setInt(1, adressId);
                ps.setString(2, strasse);
                ps.setInt(3, ortId);
                ps.setString(4, plz);
                ps.setString(5, hausnr);
                ps.executeUpdate();
            }
            //Kunde einfügen
            int kundenNr = nextId("Kunde", "KundenNr");
            String insK = "INSERT INTO Kunde "
                        + "(KundenNr, Geburtsdatum, TelefonNummer, Name, Vorname, Adresse, Bankverbindung, \"E-Mail\") "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insK)) {
                ps.setInt(1, kundenNr);
                ps.setDate(2, Date.valueOf(gebDat));
                ps.setString(3, telefon);
                ps.setString(4, nachname);
                ps.setString(5, vorname);
                ps.setInt(6, adressId);
                ps.setString(7, iban);
                ps.setString(8, email);
                ps.executeUpdate();
            }

            conn.commit();
            System.out.printf("OK: Kund:in angelegt (KundenNr = %d, AdressID = %d).%n", kundenNr, adressId);

        } catch (SQLException e) {
            rollbackQuietly();
            System.out.println("Fehler beim Einfuegen: " + e.getMessage());
        }
    }

    private boolean bankverbindungExistiert(String iban) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT 1 FROM Bankverbindung WHERE IBAN = ?")) {
            ps.setString(1, iban);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    //Bankverbindung einfügen
    private void insertBankverbindung(String iban, String bic, String kontonummer, String blz)
            throws SQLException {
        String sql = "INSERT INTO Bankverbindung (IBAN, BLZ, BIC, Kontonummer) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, iban);
            if (blz == null || blz.isEmpty()) ps.setNull(2, Types.CHAR);
            else ps.setString(2, blz);
            ps.setString(3, bic);
            ps.setString(4, kontonummer);
            ps.executeUpdate();
        }
    }

    //2 Kunde suchen
    private void useCaseSucheKunde() {
        System.out.println("\n--- Kund:innen suchen ---");
        try {
            beginTx("TX_Kunde_Suchen", true);

            String suche = readNonEmpty("Suchbegriff (Teil von Vorname oder Name): ");
            String sql =
                "SELECT k.KundenNr, k.Vorname, k.Name, k.Geburtsdatum, k.TelefonNummer, "
              + "       k.\"E-Mail\" AS Email, "
              + "       a.Straße AS Strasse, a.Hausnummer, a.PLZ, "
              + "       o.Name AS Ort, l.Name AS Land, "
              + "       b.IBAN, b.BIC "
              + "FROM Kunde k "
              + "JOIN Adresse a        ON k.Adresse = a.AdressID "
              + "JOIN Ort o            ON a.Ort = o.Ort_ID "
              + "JOIN Land l           ON o.Land = l.Isocode "
              + "JOIN Bankverbindung b ON k.Bankverbindung = b.IBAN "
              + "WHERE LOWER(k.Vorname) LIKE ? OR LOWER(k.Name) LIKE ? "
              + "ORDER BY k.Name, k.Vorname";

            int count = 0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                String pattern = "%" + suche.toLowerCase() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        count++;
                        System.out.println("------------------------------------------------------------");
                        System.out.printf("KundenNr : %d%n", rs.getInt("KundenNr"));
                        System.out.printf("Name     : %s, %s%n", rs.getString("Name"), rs.getString("Vorname"));
                        System.out.printf("Geboren  : %s%n", fmt(rs.getDate("Geburtsdatum")));
                        System.out.printf("Telefon  : %s%n", rs.getString("TelefonNummer"));
                        System.out.printf("E-Mail   : %s%n", rs.getString("Email"));
                        System.out.printf("Adresse  : %s %s, %s %s (%s)%n",
                                rs.getString("Strasse"), rs.getString("Hausnummer"),
                                rs.getString("PLZ"), rs.getString("Ort"), rs.getString("Land"));
                        System.out.printf("Bank     : IBAN %s, BIC %s%n",
                                rs.getString("IBAN"), rs.getString("BIC"));
                    }
                }
            }
            if (count > 0) System.out.println("------------------------------------------------------------");
            System.out.println(count == 0 ? "Keine Treffer." : ("Treffer: " + count));

            conn.commit();
        } catch (SQLException e) {
            rollbackQuietly();
            System.out.println("Fehler bei der Suche: " + e.getMessage());
        }
    }

    //3 Neue belegung

    private void useCaseBelegungAnlegen() {
        System.out.println("\n--- Ferienwohnung reservieren/buchen ---");
        try {
            beginTx("TX_Belegung_Anlegen", false);

            int kundenNr = selectKunde();
            if (kundenNr < 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }

            int fewoNr = selectFerienwohnung();
            if (fewoNr < 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }

            // Ferienwohnung-Zeile sperren, damit zwei parallele Buchungen denselben
            // Zeitraum nicht gleichzeitig als "frei" sehen koennen (Serialisierung pro FeWo).
            try (PreparedStatement lock = conn.prepareStatement(
                    "SELECT FerienWohnungsNr FROM Ferienwohnung WHERE FerienWohnungsNr = ? FOR UPDATE")) {
                lock.setInt(1, fewoNr);
                try (ResultSet rs = lock.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        System.out.println("Ferienwohnung nicht gefunden.");
                        return;
                    }
                }
            }

            while (true) {
                LocalDate von = readDate("Von-Datum (TT.MM.JJJJ): ");
                LocalDate bis = readDate("Bis-Datum (TT.MM.JJJJ): ");
                if (!von.isBefore(bis)) {
                    System.out.println("Ungueltig: Das Von-Datum muss vor dem Bis-Datum liegen.");
                    continue;
                }

                if (istFrei(fewoNr, von, bis)) {
                    System.out.println("Die Ferienwohnung ist im Zeitraum frei.");
                    int sel = readInt("  1) Reservieren   2) Buchen   0) Abbruch : ", 0, 2);
                    if (sel == 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }
                    String status = (sel == 1) ? "Reservierung" : "Buchung";
                    int belegNr = insertBelegung(kundenNr, fewoNr, von, bis, status);
                    conn.commit();
                    System.out.printf("OK: %s angelegt (BelegNummer = %d).%n", status, belegNr);
                    return;
                } else {
                    System.out.println("Die Ferienwohnung ist im angegebenen Zeitraum bereits belegt.");
                    int sel = readInt("  1) Anderen Zeitraum eingeben   0) Abbruch : ", 0, 1);
                    if (sel == 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }
                    // sonst: Schleife wiederholt die Zeitraum-Eingabe
                }
            }
        } catch (SQLException e) {
            rollbackQuietly();
            System.out.println("Fehler beim Anlegen der Belegung: " + e.getMessage());
        }
    }
    //Check ob fewo frei ist 
    private boolean istFrei(int fewoNr, LocalDate von, LocalDate bis) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Belegung "
                   + "WHERE Ferienwohnung = ? AND Von < ? AND Bis > ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fewoNr);
            ps.setDate(2, Date.valueOf(bis)); // vorhandene.Von < neue.Bis
            ps.setDate(3, Date.valueOf(von)); // vorhandene.Bis > neue.Von
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) == 0;
            }
        }
    }
    //belegung einfügen
    private int insertBelegung(int kundenNr, int fewoNr, LocalDate von, LocalDate bis, String status)
            throws SQLException {
        int belegNr = nextId("Belegung", "BelegNummer");
        String sql = "INSERT INTO Belegung "
                   + "(BelegNummer, Belegdatum, Von, Bis, Status, Ferienwohnung, Kunde) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, belegNr);
            ps.setDate(2, Date.valueOf(LocalDate.now())); // Belegdatum = heute
            ps.setDate(3, Date.valueOf(von));
            ps.setDate(4, Date.valueOf(bis));
            ps.setString(5, status);
            ps.setInt(6, fewoNr);
            ps.setInt(7, kundenNr);
            ps.executeUpdate();
        }
        return belegNr;
    }

    //4 Belegung löschen 

    private void useCaseBelegungLoeschen() {
        System.out.println("\n--- Belegung loeschen ---");
        try {
            beginTx("TX_Belegung_Loeschen", false);

            int belegNr = selectBelegung();
            if (belegNr < 0) { conn.rollback(); System.out.println("Abgebrochen."); return; }

            String c = readLine("Belegung " + belegNr
                    + " inkl. aller abhaengigen Daten wirklich loeschen? (j/n): ");
            if (!c.equalsIgnoreCase("j")) {
                conn.rollback();
                System.out.println("Abgebrochen.");
                return;
            }

            
            int rows;
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM Belegung WHERE BelegNummer = ?")) {
                ps.setInt(1, belegNr);
                rows = ps.executeUpdate();
            }

            if (rows == 0) {
                conn.rollback();
                System.out.println("Belegung nicht gefunden (nichts geloescht).");
                return;
            }

            conn.commit();
            System.out.printf("OK: Belegung %d geloescht (abhaengige Rechnung via Cascade, "
                    + "Buchungen werden vom Trigger archiviert).%n", belegNr);

        } catch (SQLException e) {
            rollbackQuietly();
            System.out.println("Fehler beim Loeschen: " + e.getMessage());
        }
    }

   // ensprechende liste auswählen

    private int selectOrt() throws SQLException {
        System.out.println("Verfuegbare Orte:");
        Set<Integer> valid = new HashSet<>();
        String sql = "SELECT o.Ort_ID, o.Name, l.Name AS Land "
                   + "FROM Ort o JOIN Land l ON o.Land = l.Isocode "
                   + "ORDER BY o.Ort_ID";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                int id = rs.getInt("Ort_ID");
                valid.add(id);
                System.out.printf("  [%d] %s (%s)%n", id, rs.getString("Name"), rs.getString("Land"));
            }
        }
        return chooseFromSet(valid, "Ort-ID waehlen");
    }

    private int selectKunde() throws SQLException {
        System.out.println("Kund:innen:");
        Set<Integer> valid = new HashSet<>();
        String sql = "SELECT KundenNr, Vorname, Name FROM Kunde ORDER BY Name, Vorname";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                int id = rs.getInt("KundenNr");
                valid.add(id);
                System.out.printf("  [%d] %s, %s%n", id, rs.getString("Name"), rs.getString("Vorname"));
            }
        }
        return chooseFromSet(valid, "KundenNr waehlen");
    }

    private int selectFerienwohnung() throws SQLException {
        System.out.println("Ferienwohnungen:");
        Set<Integer> valid = new HashSet<>();
        String sql = "SELECT f.FerienWohnungsNr, f.beschreibung, f.Preis_in_Euro, "
                   + "       f.Anzahl_Zimmer, o.Name AS Ort "
                   + "FROM Ferienwohnung f "
                   + "JOIN Adresse a ON f.Adresse = a.AdressID "
                   + "JOIN Ort o     ON a.Ort = o.Ort_ID "
                   + "ORDER BY f.FerienWohnungsNr";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                int id = rs.getInt("FerienWohnungsNr");
                valid.add(id);
                System.out.printf("  [%d] %s in %s, %d Zimmer, %.2f EUR/Nacht%n",
                        id, rs.getString("beschreibung"), rs.getString("Ort"),
                        rs.getInt("Anzahl_Zimmer"), rs.getBigDecimal("Preis_in_Euro"));
            }
        }
        return chooseFromSet(valid, "FerienWohnungsNr waehlen");
    }

    private int selectBelegung() throws SQLException {
        System.out.println("Vorhandene Belegungen:");
        Set<Integer> valid = new HashSet<>();
        String sql = "SELECT b.BelegNummer, b.Status, b.Von, b.Bis, "
                   + "       k.Vorname, k.Name, f.beschreibung AS FeWo "
                   + "FROM Belegung b "
                   + "JOIN Kunde k         ON b.Kunde = k.KundenNr "
                   + "JOIN Ferienwohnung f ON b.Ferienwohnung = f.FerienWohnungsNr "
                   + "ORDER BY b.BelegNummer";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                int id = rs.getInt("BelegNummer");
                valid.add(id);
                System.out.printf("  [%d] %-12s %s, %s | FeWo '%s' | %s - %s%n",
                        id, rs.getString("Status"),
                        rs.getString("Name"), rs.getString("Vorname"),
                        rs.getString("FeWo"),
                        fmt(rs.getDate("Von")), fmt(rs.getDate("Bis")));
            }
        }
        return chooseFromSet(valid, "BelegNummer waehlen");
    }

    // =========================== DB-Hilfsmethoden =============================

    /** Naechste freie ID per MAX+1 (Schema hat fuer diese PKs keine Sequenz). */
    private int nextId(String table, String idColumn) throws SQLException {
        // table/idColumn sind ausschliesslich Code-Literale -> keine SQL-Injection moeglich.
        String sql = "SELECT NVL(MAX(" + idColumn + "), 0) + 1 FROM " + table;
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            rs.next();
            return rs.getInt(1);
        }
    }

    /** Startet eine benannte Transaktion (wie in tx_1/2/3.sql). Muss erstes Statement sein. */
    private void beginTx(String name, boolean readOnly) throws SQLException {
        String mode = readOnly ? "READ ONLY" : "READ WRITE";
        try (Statement st = conn.createStatement()) {
            st.execute("SET TRANSACTION " + mode + " NAME '" + name + "'");
        }
    }

    private void rollbackQuietly() {
        try {
            conn.rollback();
        } catch (SQLException ex) {
            System.err.println("Warnung: Rollback fehlgeschlagen: " + ex.getMessage());
        }
    }

    //Eingabe hilfe (Leere/Ungültige E-Mail/Ungültige zahl/ungültiges Datum format/ Geburtstag ist in der vergangenheit)

    private String readLine(String prompt) {
        System.out.print(prompt);
        return in.nextLine().trim();
    }

    private String readNonEmpty(String prompt) {
        while (true) {
            String s = readLine(prompt);
            if (!s.isEmpty()) return s;
            System.out.println("Eingabe darf nicht leer sein.");
        }
    }

    private String readEmail(String prompt) {
        while (true) {
            String s = readNonEmpty(prompt);
            int at = s.indexOf('@');
            if (at > 0 && s.indexOf('.', at) > at + 1 && !s.endsWith(".")) return s;
            System.out.println("Bitte eine gueltige E-Mail-Adresse eingeben (z.B. name@host.de).");
        }
    }

    private int readInt(String prompt, int min, int max) {
        while (true) {
            String s = readLine(prompt);
            try {
                int v = Integer.parseInt(s);
                if (v < min || v > max) {
                    System.out.printf("Bitte eine Zahl zwischen %d und %d eingeben.%n", min, max);
                    continue;
                }
                return v;
            } catch (NumberFormatException e) {
                System.out.println("Ungueltige Eingabe. Bitte eine ganze Zahl eingeben.");
            }
        }
    }

    private LocalDate readDate(String prompt) {
        while (true) {
            String s = readLine(prompt);
            try {
                return LocalDate.parse(s, DATE_FMT);
            } catch (DateTimeParseException e) {
                System.out.println("Ungueltiges Datum. Format: TT.MM.JJJJ (z.B. 24.12.2026).");
            }
        }
    }

    private LocalDate readPastDate(String prompt) {
        while (true) {
            LocalDate d = readDate(prompt);
            if (d.isBefore(LocalDate.now())) return d;
            System.out.println("Das Geburtsdatum muss in der Vergangenheit liegen.");
        }
    }

    //bricht ab mit -1 wenn alles durchgegangen und nicht vorhanden ist
    private int chooseFromSet(Set<Integer> valid, String prompt) {
        if (valid.isEmpty()) {
            System.out.println("Keine Eintraege vorhanden.");
            return -1;
        }
        while (true) {
            String s = readLine(prompt + " (oder 'x' fuer Abbruch): ");
            if (s.equalsIgnoreCase("x")) return -1;
            try {
                int id = Integer.parseInt(s);
                if (valid.contains(id)) return id;
                System.out.println("Ungueltige Auswahl - bitte eine ID aus der Liste waehlen.");
            } catch (NumberFormatException e) {
                System.out.println("Bitte eine gueltige Zahl eingeben.");
            }
        }
    }

    private String fmt(Date d) {
        return d == null ? "-" : d.toLocalDate().format(DATE_FMT);
    }
}
