-- Creazione del database e delle tabelle
CREATE DATABASE SistemaRecensioni;
USE SistemaRecensioni;

-- Tabella Utente_Registrato
CREATE TABLE Utente_Registrato (
    email VARCHAR(255) NOT NULL PRIMARY KEY,
    Icona BLOB,
    username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Tipo_Utente VARCHAR(50),
    N_Warning INT
);

-- Tabella Film
CREATE TABLE Film (
    ID_Film INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Locandina BLOB,
    Nome VARCHAR(255) NOT NULL,
    Anno YEAR NOT NULL,
    Durata INT NOT NULL,
    Generi VARCHAR(255),
    Regista VARCHAR(255),
    Trama VARCHAR(255),
    Valutazione INT DEFAULT 1 CHECK (Valutazione BETWEEN 1 AND 5),
    Attori TEXT
);

-- Tabella Recensione
CREATE TABLE Recensione (
    Titolo VARCHAR(255) NOT NULL,
    Contenuto TEXT,
    Valutazione INT NOT NULL CHECK (Valutazione BETWEEN 1 AND 5),
    N_Like INT DEFAULT 0,
    N_DisLike INT DEFAULT 0,
    N_Reports INT DEFAULT 0,
    email VARCHAR(255) NOT NULL,
    ID_Film VARCHAR(255) NOT NULL,
    PRIMARY KEY (email, ID_Film),
    FOREIGN KEY (email) REFERENCES Utente_Registrato(email),
    FOREIGN KEY (ID_Film) REFERENCES Film(ID_Film)
);

-- Tabella Valuta
CREATE TABLE Valuta (
    Like_Dislike BOOLEAN NOT NULL,
    email VARCHAR(255) NOT NULL,
    email_Recensore VARCHAR(255) NOT NULL,
    ID_Film INT NOT NULL,
    PRIMARY KEY (email, email_Recensore, ID_Film),
    FOREIGN KEY (email) REFERENCES Utente_Registrato(email),
    FOREIGN KEY (email_Recensore, ID_Film) REFERENCES Recensione(email, ID_Film)
);

-- Tabella Report
CREATE TABLE Report (
    email VARCHAR(255) NOT NULL,
    email_Recensore VARCHAR(255) NOT NULL,
    ID_Film INT NOT NULL,
    PRIMARY KEY (email, email_Recensore, ID_Film),
    FOREIGN KEY (email) REFERENCES Utente_Registrato(email),
    FOREIGN KEY (email_Recensore, ID_Film) REFERENCES Recensione(email, ID_Film)
);

-- Inserimento utenti speciali
INSERT INTO Utente_Registrato (email, Icona, username, Password, Tipo_Utente, N_Warning) VALUES
('gestore@catalogo.it', NULL, 'GestoreCatalogo', 'password123', 'GESTORE', 0),
('moderatore@forum.it', NULL, 'Moderatore', 'password123', 'MODERATORE', 0);
