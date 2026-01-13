
-- 1. Tabelle erweitern
-- Erweitert die Tabelle um die Spalte "Noten".
-- Diese ist zweidimensional und kann durch den Datentyp 'NUMERIC[][]' verschiedene Arten von Zahlen halten.
ALTER TABLE studenten ADD noten NUMERIC[][];


-- 2. Testdatensätze anlegen
-- Füllt die soeben angelegte Spalte teilweise mit Datensätzen
-- Es ist wichtig nicht alle zu füllen, um zu testen, ob auch mit leeren Datensätzen korrekt gearbeitet wird.
UPDATE studenten SET noten = '{{1.2,5041},{3.1,4052},{4.0,5216},{2.6,4630}}' WHERE matrnr = 24002;
UPDATE studenten SET noten = '{{1.6,4052},{3.4,5216},{2.0,5259},{2.2,5022}}' WHERE matrnr = 29555;

-- 3. Funktion "durchschnitt" anlegen
-- Hier wird die Funktion durchschnitt angelegt.
-- Sie nimmt ein zweidimensionales numerisches Array auf, und liefert eine numerische Zahl zurück.
CREATE OR REPLACE FUNCTION durchschnitt(noten NUMERIC[][]) RETURNS NUMERIC AS --"CREATE OR REPLACE" erspart beim erstellen der Funktion das löschen der alten Funktion.
$$
DECLARE --In diesem Block werden Variablen deklariert (und auch initialisiert), welche in der Funktion benötigt werden.

	summeAllerNoten FLOAT := 0; --Die Summe aller in 'noten' beinhalteten Noten
	counter int := 0; --Die Anzahl der aufsummierten Noten
	innerArray NUMERIC[]; --Die Variable in welche die eindimensionalen Arrays gespeichert werden

BEGIN --Beginn der Funktion

    --Falls noten NULL ist, gebe direkt NULL zurück, da eine FOR-Schleife auf NULL nicht ausführbar ist, und wir aus NULL auch keine geeigneten Daten errechnen können.
	IF noten IS NULL THEN 
		RETURN NULL;
	END IF;

	FOREACH innerArray SLICE 1 IN ARRAY noten --Für jedes Teilarray des Arrays 'noten', mit dem jeweiligen Teilarray in der Variable 'innerArray'
	LOOP
		summeAllerNoten = summeAllerNoten+innerArray[1]; --Die erste Stelle des Arrays wird auf die Summe aller noten addiert
		counter = counter+1; --Der Notencounter wird um eins erhöht
	END LOOP;
	RETURN summeAllerNoten/counter; --Teile die Summe aller noten durch die Anzahl der durchlaufenen Noten, und gebe diese zurück.
END --Ende der Funktion
$$
LANGUAGE plpgsql; --Sprachdefinition mit welcher Sprache gearbeitet wurde


-- 4. Hier wird ein View "Notenübersicht" erstellt, welcher die ursprünglichen Studentendaten, aber anstatt der einzelnen Noten den jeweiligen durchschnitt angibt. 
CREATE VIEW NotenUebersicht AS 
    SELECT 
        matrnr,
        name,
        semester,
        durchschnitt(noten) as Notendurchschnitt --Hier findet die eben angelegte Funktion auch verwendung
    FROM studenten 
    ORDER BY Notendurchschnitt;

