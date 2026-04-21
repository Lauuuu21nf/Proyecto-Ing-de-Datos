-- ==============================================================================
-- PROYECTO: Sistema de Capacitaciones SST - TGI
-- DDL BASADO ESTRICTAMENTE EN EL MODELO LÓGICO (JPG)
-- ==============================================================================


CREATE DATABASE IF NOT EXISTS sst_tgi;
USE sst_tgi;

-- -----------------------------------------------------
-- CREACIÓN DE TABLAS BASE (Sin dependencias)
-- -----------------------------------------------------

CREATE TABLE Programa (
    ID_Programa INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Estado_PHVA VARCHAR(255) NOT NULL
);

CREATE TABLE Cargo (
    ID_Cargo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Cargo VARCHAR(255) NOT NULL
);

CREATE TABLE Responsable (
    ID_Responsable INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Responsable VARCHAR(255) NOT NULL
);

CREATE TABLE Centro_Trabajo (
    ID_Centro INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Centro VARCHAR(255) NOT NULL,
    Ubicacion VARCHAR(255) NOT NULL
);

CREATE TABLE Usuario (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Usuario VARCHAR(255) NOT NULL,
    Contrasena VARCHAR(255) NOT NULL
);

-- -----------------------------------------------------
-- CREACIÓN DE TABLAS DEPENDIENTES
-- -----------------------------------------------------

CREATE TABLE Trabajador (
    Documento_ID VARCHAR(20) PRIMARY KEY,
    Nombre_Completo VARCHAR(255) NOT NULL,
    Es_TGI BOOLEAN NOT NULL,
    ID_Cargo INT NOT NULL,
    ID_Centro INT NOT NULL,
    FOREIGN KEY (ID_Cargo) REFERENCES Cargo(ID_Cargo),
    FOREIGN KEY (ID_Centro) REFERENCES Centro_Trabajo(ID_Centro)
);

CREATE TABLE Capacitacion (
    ID_Capacitacion INT AUTO_INCREMENT PRIMARY KEY,
    Tema VARCHAR(255) NOT NULL,
    Actividad TEXT,
    ID_Programa INT NOT NULL,
    ID_Usuario INT NOT NULL,
    FOREIGN KEY (ID_Programa) REFERENCES Programa(ID_Programa),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);


-- Tabla Puente M:N
CREATE TABLE Capacitacion_Responsable (
    ID_Capacitacion INT NOT NULL,
    ID_Responsable INT NOT NULL,
    PRIMARY KEY (ID_Capacitacion, ID_Responsable),
    FOREIGN KEY (ID_Capacitacion) REFERENCES Capacitacion(ID_Capacitacion),
    FOREIGN KEY (ID_Responsable) REFERENCES Responsable(ID_Responsable)
);

CREATE TABLE Programacion (
    ID_Programacion INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Modalidad VARCHAR(50) NOT NULL,
    Lugar_Enlace VARCHAR(255) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    ID_Capacitacion INT NOT NULL,
    FOREIGN KEY (ID_Capacitacion) REFERENCES Capacitacion(ID_Capacitacion)
);

CREATE TABLE Asistencia (
    ID_Asistencia INT AUTO_INCREMENT PRIMARY KEY,
    Asistio BOOLEAN NOT NULL,
    Evaluacion INT,
    Comentarios TEXT,
    ID_Programacion INT NOT NULL,
    Documento_Trabajador VARCHAR(20) NOT NULL,
    FOREIGN KEY (ID_Programacion) REFERENCES Programacion(ID_Programacion),
    FOREIGN KEY (Documento_Trabajador) REFERENCES Trabajador(Documento_ID)
);