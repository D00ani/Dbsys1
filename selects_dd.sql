--1
SELECT table_name 
FROM user_tables
ORDER BY table_name;
--2
SELECT object_type AS Typ, object_name AS Name
FROM user_objects
WHERE object_type IN ('TABLE', 'VIEW')
ORDER BY object_type, object_name;
--3

SELECT table_name, comments AS kommentar
FROM user_tab_comments
WHERE table_type = 'TABLE' 
  AND comments IS NOT NULL
ORDER BY table_name;
--4
SELECT 
    c.column_name AS attribut_name,
    c.data_type || 
        CASE 
            WHEN c.data_type IN ('VARCHAR2', 'CHAR') THEN '(' || c.data_length || ')'
            WHEN c.data_type = 'NUMBER' AND c.data_precision IS NOT NULL THEN '(' || c.data_precision || ',' || c.data_scale || ')'
            ELSE '' 
        END AS datentyp,
    CASE c.nullable WHEN 'Y' THEN 'JA' ELSE 'NEIN' END AS darf_null_sein,
    cc.comments AS spaltenkommentar
FROM user_tab_columns c
LEFT JOIN user_col_comments cc 
    ON c.table_name = cc.table_name AND c.column_name = cc.column_name
WHERE c.table_name = UPPER('&eingabe_objektname')
ORDER BY c.column_id;
--Familienwohnungen
--Status kommentar hinzufügen
--5
SELECT 
    v.view_name,
    v.text AS definierendes_sql_statement,
    c.comments AS sichten_kommentar
FROM user_views v
LEFT JOIN user_tab_comments c ON v.view_name = c.table_name
WHERE v.view_name = UPPER('&eingabe_sichtname');
--Familienwohnungen
--6
SELECT 
    c.constraint_name,
    CASE c.constraint_type 
        WHEN 'P' THEN 'Primary Key'
        WHEN 'U' THEN 'Unique Key'
        WHEN 'C' THEN 'Check Constraint'
    END AS constraint_typ,
    cc.column_name AS beteiligte_spalte,
    cc.position AS spalten_position,
    c.search_condition AS check_bedingung,
    c.deferrable AS verzoegerbar,
    c.deferred AS pruefzeitpunkt
FROM user_constraints c
LEFT JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
WHERE c.table_name = UPPER('&tabelle_fuer_constraints')
  AND c.constraint_type IN ('P', 'U', 'C')
ORDER BY c.constraint_type, c.constraint_name, cc.position;
--ort
--7
SELECT 
    c.constraint_name AS fremdschluessel_name,
    (SELECT LISTAGG(column_name || ' (Pos ' || position || ')', ', ') WITHIN GROUP (ORDER BY position) 
     FROM user_cons_columns WHERE constraint_name = c.constraint_name) AS child_spalten,
    rc.table_name AS referenzierte_tabelle,
    (SELECT LISTAGG(column_name || ' (Pos ' || position || ')', ', ') WITHIN GROUP (ORDER BY position) 
     FROM user_cons_columns WHERE constraint_name = c.r_constraint_name) AS parent_spalten,
    c.delete_rule AS on_delete_regel,
    c.deferrable AS verzoegerbar,
    c.deferred AS pruefzeitpunkt
FROM user_constraints c
JOIN user_constraints rc ON c.r_constraint_name = rc.constraint_name
WHERE c.table_name = UPPER('&tabelle_fuer_fremdschluessel')
  AND c.constraint_type = 'R'
ORDER BY c.constraint_name;
--Kunde
--testen für zusammengesetzten fremdschlüssel
--8
SELECT 
    table_name AS view_name,
    CASE constraint_type 
        WHEN 'V' THEN 'WITH CHECK OPTION'
        WHEN 'O' THEN 'READ ONLY'
    END AS restriktions_typ
FROM user_constraints
WHERE constraint_type IN ('V', 'O')
ORDER BY table_name;