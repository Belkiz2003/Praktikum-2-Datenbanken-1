-- *** AUFGABE 1: IMPLEMENTIERUNG DES FAHRRADLADEN-SCHEMAS ***

-- 1. Tabelle Kunde erstellen
-- Speichert die atomaren Kundendaten ohne Redundanz.
CREATE TABLE Kunde (
    KNr INTEGER PRIMARY KEY,
    Name VARCHAR(100),
    Str VARCHAR(100),
    Ort VARCHAR(100)
);

-- 2. Tabelle Versicherung erstellen
-- Speichert Versicherungsgesellschaften und deren Standorte.
CREATE TABLE Versicherung (
    Name VARCHAR(100) PRIMARY KEY,
    VOrt VARCHAR(100)
);

-- 3. Tabelle Fahrrad erstellen
-- Verknüpft Fahrräder mit Kunden und Versicherungen via Fremdschlüssel.
CREATE TABLE Fahrrad (
    RahmenNr INTEGER PRIMARY KEY,
    Marke VARCHAR(100),
    KNr INTEGER,
    VersicherungName VARCHAR(100),
    
    CONSTRAINT fk_kunde FOREIGN KEY (KNr) REFERENCES Kunde (KNr),
    CONSTRAINT fk_versicherung FOREIGN KEY (VersicherungName) REFERENCES Versicherung (Name)
);

-- 4. Tabelle Reparatur erstellen
-- Realisiert die m:n Beziehung bzw. Historie der Reparaturen.
-- Primärschlüssel ist zusammengesetzt aus Fahrrad und Datum.
CREATE TABLE Reparatur (
    RahmenNr INTEGER,
    ReparaturDatum DATE,
    Diagnose VARCHAR(255),
    
    PRIMARY KEY (RahmenNr, ReparaturDatum),
    CONSTRAINT fk_fahrrad_rep FOREIGN KEY (RahmenNr) REFERENCES Fahrrad (RahmenNr)
);

-- *** DATEN EINFÜGEN (ZUR DEMONSTRATION DER FUNKTIONALITÄT) ***

-- Kunden einfügen
INSERT INTO Kunde (KNr, Name, Str, Ort) VALUES 
(100, 'Meyer', 'Hof 6', 'Köln'),
(101, 'Müller', 'Weg 3', 'Köln');

-- Versicherungen einfügen
INSERT INTO Versicherung (Name, VOrt) VALUES 
('Allianz', 'Köln'),
('Signal', 'Mainz');

-- Fahrräder einfügen
INSERT INTO Fahrrad (RahmenNr, Marke, KNr, VersicherungName) VALUES 
(123, 'Diamant', 100, 'Allianz'),
(690, 'Kettler', 101, 'Allianz'),
(432, 'Winora', 100, 'Signal');

-- Reparaturen einfügen
INSERT INTO Reparatur (RahmenNr, ReparaturDatum, Diagnose) VALUES 
(123, '2019-09-12', 'Reifen'),
(690, '2019-09-12', 'Schleifer'),
(432, '2018-01-10', 'Bremse'),
(123, '2019-01-12', 'Speiche');