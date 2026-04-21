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
    idPrograma INT AUTO_INCREMENT PRIMARY KEY,
    nombrePrograma VARCHAR(50) NOT NULL,
    fasePHVA ENUM('planear', 'hacer', 'verificar', 'actuar') NOT NULL
);

CREATE TABLE Cargo (
    idCargo INT AUTO_INCREMENT PRIMARY KEY,
    nombreCargo VARCHAR(50) NOT NULL
);

CREATE TABLE Responsable (
    idResponsable INT AUTO_INCREMENT PRIMARY KEY,
    nombreResponsable VARCHAR(50) NOT NULL
);

CREATE TABLE Centro_Trabajo (
    idCentroTrabajo INT AUTO_INCREMENT PRIMARY KEY,
    nombreCentroTrabajo VARCHAR(50) NULL,
    ciudad VARCHAR(30) NOT NULL
);

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
	nombreUsuario VARCHAR(50) NOT NULL,
    rolUsuario ENUM('admin', 'ayudante') NOT NULL,
    correoUsuario VARCHAR(60),
    contrasenaUsuario VARCHAR(20),
    estadoUsuario ENUM('activo', 'inactivo')
);

-- -----------------------------------------------------
-- CREACIÓN DE TABLAS DEPENDIENTES
-- -----------------------------------------------------

CREATE TABLE Trabajador (
    idTrabajador INT AUTO_INCREMENT PRIMARY KEY,
    nombreTrabajador VARCHAR(100) NOT NULL,
    empresaDondeTrabaja VARCHAR(60) NOT NULL,
    documentoTrabajador VARCHAR(20) NOT NULL,
    idCentroTrabajoFK INT NOT NULL,
    idCargoFK INT NOT NULL,
    FOREIGN KEY (idCentroTrabajoFK) REFERENCES Centro_Trabajo(idCentroTrabajo),
    FOREIGN KEY (idCargoFK) REFERENCES Cargo(idCargo)
);

CREATE TABLE Capacitacion (
    idCapacitacion INT AUTO_INCREMENT PRIMARY KEY,
    duracion DECIMAL(3, 1) NULL,
    tema VARCHAR(120) NOT NULL,
    actividad VARCHAR(120) NULL,
    asistenciaProgramada INT NOT NULL,
    accidentesAsociados INT NULL,
    idUsuarioFK INT NOT NULL,
    idProgramaFK INT NOT NULL,
    FOREIGN KEY (idUsuarioFK) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idProgramaFK) REFERENCES Programa(idPrograma)
);


-- Tabla Puente M:N
CREATE TABLE detalleCapacitacion (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    idResponsableFK INT NOT NULL,
    idCapacitacionFK INT NOT NULL,
    FOREIGN KEY (idResponsableFK) REFERENCES Responsable(idResponsable),
    FOREIGN KEY (idCapacitacionFK) REFERENCES Capacitacion(idCapacitacion)
);

CREATE TABLE Programacion (
    idProgramacion INT AUTO_INCREMENT PRIMARY KEY,
    fechaProgramada DATE NULL,
    horaProgramada TIME NULL,
    lugarProgramado VARCHAR(50) NULL,
    modalidadProgramada ENUM('presencial', 'virtual') NOT NULL,
    idCapacitacionFK INT NOT NULL,
    estadoProgramacion ENUM('realizada', 'programada', 'cancelada') NOT NULL,
    FOREIGN KEY (idCapacitacionFK) REFERENCES Capacitacion(idCapacitacion)
);

CREATE TABLE Asistencia (
    idAsistencia INT AUTO_INCREMENT PRIMARY KEY,
    asistio BOOL NOT NULL,
    fechaDeAsistencia DATETIME NULL,
    evaluacionCapacitador INT NULL,
    comentariosCapacitacion VARCHAR(120) NULL,
    idProgramacionFK INT NOT NULL,
    idTrabajadorFK INT NOT NULL,
    FOREIGN KEY (idProgramacionFK) REFERENCES Programacion(idProgramacion),
    FOREIGN KEY (idTrabajadorFK) REFERENCES Trabajador(idTrabajador)
);

-- -----------------------------------------------------
-- INSERCIÓN DE RESGISTROS POR TABLA
-- -----------------------------------------------------
