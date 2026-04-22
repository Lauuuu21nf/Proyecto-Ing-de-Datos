-- ==============================================================================
-- PROYECTO: Sistema de Capacitaciones SST - TGI
-- DDL BASADO ESTRICTAMENTE EN EL MODELO LÓGICO (JPG)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS sst_tgi;
USE sst_tgi;

-- -----------------------------------------------------
-- CREACIÓN DE TABLAS 
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

CREATE TABLE CentroTrabajo (
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

CREATE TABLE Trabajador (
    idTrabajador INT AUTO_INCREMENT PRIMARY KEY,
    nombreTrabajador VARCHAR(100) NOT NULL,
    empresaDondeTrabaja VARCHAR(60) NOT NULL,
    documentoTrabajador VARCHAR(20) NOT NULL,
    idCentroTrabajoFK INT NOT NULL,
    idCargoFK INT NOT NULL,
    FOREIGN KEY (idCentroTrabajoFK) REFERENCES CentroTrabajo(idCentroTrabajo),
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

-- ========================================================
-- Inserciones: Programa
-- ========================================================
INSERT INTO Programa (nombrePrograma, fasePHVA) VALUES
('Trabajo en Alturas', 'hacer'), ('Plan Estratégico de Seguridad Vial', 'planear'), ('Riesgo Eléctrico', 'hacer'), ('Espacios Confinados', 'hacer'), ('Riesgo Cardiovascular', 'verificar'),
('Manejo de Sustancias Químicas', 'planear'), ('Protección Contra Caídas', 'actuar'), ('Primeros Auxilios y Emergencias', 'hacer'), ('Control de Incendios', 'verificar'), ('Ergonomía y Carga Física', 'planear');

-- ========================================================
-- Inserciones: Cargo
-- ========================================================
INSERT INTO Cargo (nombreCargo) VALUES
('Líder Mecánico'), ('Ayudante Mecánico'), ('Técnico en Instrumentación'), ('Técnico Electricista'), ('Operador de Planta'),
('Supervisor HSE'), ('Coordinador SST'), ('Inspector de Integridad'), ('Conductor de Vehículo Liviano'), ('Conductor de Vehículo Pesado'),
('Brigadista'), ('Auxiliar Administrativo'), ('Analista de Operaciones'), ('Ingeniero de Producción'), ('Ingeniero de Confiabilidad'),
('Técnico en Telecomunicaciones'), ('Auxiliar de Campo'), ('Operador de Compresor'), ('Supervisor de Mantenimiento'), ('Inspector de Calidad'),
('Almacenista'), ('Soldador Certificado'), ('Operador de Válvulas'), ('Jefe de Turno'), ('Médico Ocupacional'),
('Auxiliar de Enfermería'), ('Psicólogo Organizacional'), ('Gestor Ambiental'), ('Coordinador Logístico'), ('Asesor Jurídico');

-- ========================================================
-- Inserciones: Responsable
-- ========================================================
INSERT INTO Responsable (nombreResponsable) VALUES
('Germán Adolfo Parra Londoño'), ('Catalina Esperanza Reyes Mora'), ('Hernando José Vargas Cano'), ('Luisa Fernanda Arango Diaz'), ('Ricardo Camilo Torres Blanco'),
('Sandra Milena Ospina Ruiz'), ('Fabio Ernesto Nieto Garzon'), ('Monica Patricia Suarez Vega'), ('Alejandro Ivan Rojas Puentes'), ('Isabel Cristina Bernal Perez'),
('Juan Manuel Guzman Hoyos'), ('Patricia Elena Serrano Castro'), ('Rodrigo Felipe Acosta Melo'), ('Yaneth Lorena Cano Villamil'), ('Mauricio Alberto Mejia Leon'),
('Claudia Sofia Rincon Mora'), ('Henry Mauricio Lara Pineda'), ('Gloria Amparo Herrera Duque'), ('Julio Cesar Medina Salcedo'), ('Andres Guillermo Velez Montoya');

-- ========================================================
-- Inserciones: CentroTrabajo
-- ========================================================
INSERT INTO CentroTrabajo (nombreCentroTrabajo, ciudad) VALUES
('Sede Administrativa Central', 'Bogotá'), ('Sede Operacional Norte', 'Bogotá'), ('Sede Administrativa II', 'Medellín'), ('Planta Compresora Oriente', 'Medellín'), ('Sede Operacional Barrancabermeja', 'Barrancabermeja'),
('Centro de Control Barrancabermeja', 'Barrancabermeja'), ('Estación Cogua', 'Cogua'), ('Planta Vasconia', 'Barrancabermeja'), ('Sede Operacional Sur', 'Cali'), ('Sede Administrativa Cali', 'Cali'),
('Estación El Pozo', 'Bucaramanga'), ('Sede Técnica Bucaramanga', 'Bucaramanga'), ('Centro Logístico Cartagena', 'Cartagena'), ('Sede Portuaria', 'Cartagena'), ('Estación La Belleza', 'Yopal'),
('Sede Campo Yopal', 'Yopal'), ('Planta Compresora Occidente', 'Pereira'), ('Sede Operacional Eje Cafetero', 'Manizales'), ('Centro de Mantenimiento Villavicencio', 'Villavicencio'), ('Sede Campo Meta', 'Villavicencio');

-- ========================================================
-- Inserciones: Usuario
-- ========================================================
INSERT INTO Usuario (nombreUsuario, rolUsuario, correoUsuario, contrasenaUsuario, estadoUsuario) VALUES
('Diana Carolina Munévar Murillo', 'admin', 'diana.munevar@tgi.com.co', 'ConfioEnLos3Ninos', 'activo'), ('Xavier Enrique Naar Amaris', 'admin', 'xavier.naar@tgi.com.co', 'meHanAscendidoGente', 'activo'), ('Ana Lucia Bernal Perez', 'admin', 'ana.bernal@tgi.com.co', 'Admin2026*', 'inactivo'), ('Carlos Hernan Mejia Rios', 'ayudante', 'carlos.mejia@tgi.com.co', 'Ayuda123#', 'inactivo');

-- ========================================================
-- Inserciones: Trabajador
-- ========================================================
INSERT INTO Trabajador (nombreTrabajador, empresaDondeTrabaja, documentoTrabajador, idCentroTrabajoFK, idCargoFK) VALUES
('Carlos Andres Peña Rios', 'TGI', '1045678901', 1, 3), ('Maria Fernanda Lopez Arce', 'TGI', '1032456789', 1, 12), ('Jorge Enrique Molina Vega', 'TGI', '79456123', 2, 1), ('Luis Alfredo Torres Gomez', 'TGI', '80134567', 2, 2), ('Diana Marcela Ruiz Herrera', 'TGI', '1076543210', 3, 7),
('Andres Felipe Castro Mora', 'TGI', '1023456789', 3, 6), ('Sandra Patricia Vargas Diaz', 'TGI', '52678901', 4, 8), ('Ricardo Emilio Suarez Leon', 'TGI', '71234890', 4, 3), ('Paula Andrea Jimenez Cruz', 'TGI', '1098765432', 5, 9), ('John Freddy Ramirez Pinto', 'TGI', '91234567', 5, 10),
('Angela Maria Ospina Soto', 'TGI', '1065432198', 6, 11), ('Hector Fabio Mendoza Ruiz', 'TGI', '79012345', 6, 18), ('Viviana Paola Guerrero Alba', 'TGI', '1054321987', 7, 5), ('Camilo Augusto Nieto Ramos', 'TGI', '80876543', 7, 23), ('Beatriz Elena Cardona Meza', 'TGI', '43876543', 8, 19),
('Oscar Ivan Calderon Pena', 'TGI', '79543210', 8, 22), ('Liliana Marcela Reyes Cano', 'TGI', '1087654321', 9, 4), ('Ferney Andres Aguilar Leal', 'TGI', '91876543', 9, 1), ('Natalia Esperanza Vidal Torres', 'TGI', '1043219876', 10, 7), ('Juan Pablo Morales Blanco', 'TGI', '80654321', 10, 13),
('Gloria Ines Acosta Pineda', 'TGI', '43210987', 11, 24), ('Manuel Eduardo Florez Rangel', 'TGI', '91654321', 11, 16), ('Adriana Cecilia Sepulveda Marin', 'TGI', '52109876', 12, 12), ('Roberto Carlos Gomez Alvarado', 'TGI', '79876543', 12, 20), ('Paola Milena Sanchez Duarte', 'TGI', '1076512345', 13, 29),
('Eduardo Antonio Parra Quintero', 'TGI', '80321098', 13, 21), ('Claudia Patricia Bermudez Perez', 'TGI', '52876543', 14, 11), ('Nicolas Arturo Velez Castillo', 'TGI', '1067891234', 14, 15), ('Marcela Johana Rojas Contreras', 'TGI', '1089012345', 15, 5), ('Felipe Ernesto Arango Salcedo', 'TGI', '91012345', 15, 2),
('Yesenia Carolina Gutierrez Franco', 'TGI', '1023487650', 16, 25), ('Mauricio Hernan Cano Naranjo', 'TGI', '80567890', 16, 26), ('Sergio Alejandro Blanco Montes', 'TGI', '1056789012', 17, 1), ('Maria Alejandra Quintero Hoyos', 'TGI', '1098012345', 17, 4), ('Jairo Andres Montoya Rivera', 'TGI', '79098765', 18, 23),
('Leidy Tatiana Cortes Pedraza', 'TGI', '1034567809', 18, 12), ('Giovanny Andres Muñoz Mora', 'TGI', '80789012', 19, 19), ('Luz Marina Olarte Bautista', 'TGI', '51234567', 19, 8), ('Daniel Fernando Posada Arias', 'TGI', '1045312678', 20, 10), ('Alba Lucia Pineda Ceballos', 'TGI', '43678901', 20, 7),
('Rodrigo Enrique Pacheco Garzon', 'Contratista Externo', '80012345', 5, 9), ('Javier Mauricio Lozano Arias', 'Contratista Externo', '79345678', 8, 22), ('Sonia Esperanza Barrera Suarez', 'Contratista Externo', '52456789', 2, 11), ('Henry Eliecer Zapata Torres', 'Contratista Externo', '91456789', 13, 2), ('Juliana Andrea Castillo Mora', 'Contratista Externo', '1056012345', 1, 6),
('Ivan Dario Herrera Ceron', 'TGI', '80234567', 6, 14), ('Tatiana Lorena Bedoya Monsalve', 'TGI', '1078901234', 7, 25), ('Gabriel Andres Silva Palacios', 'TGI', '79901234', 3, 16), ('Pilar Constanza Orjuela Medina', 'TGI', '43901234', 9, 27), ('Andres Camilo Garzon Velasquez', 'TGI', '1067012345', 4, 17),
('Yuri Alexandra Cardenas Blanco', 'TGI', '1089123456', 10, 5), ('Carlos Mario Acevedo Torres', 'TGI', '80456781', 11, 20), ('Lina Maria Buritica Lopez', 'TGI', '1021234569', 14, 29), ('Juan Camilo Ochoa Sanchez', 'TGI', '1045601234', 16, 3), ('Dario Hernando Vasquez Pinto', 'TGI', '79234561', 17, 23),
('Ana Milena Chaparro Rincon', 'TGI', '52789015', 12, 8), ('Omar Ferney Quintero Diaz', 'TGI', '91789012', 18, 10), ('Esperanza Margarita Leon Avila', 'TGI', '43123459', 19, 24), ('William Andres Ramirez Calderon', 'Contratista Externo', '80901238', 20, 1), ('Diana Carolina Trujillo Ospina', 'Contratista Externo', '1032109876', 6, 15),
('Alexander Javier Rios Bermudez', 'TGI', '79678903', 7, 18), ('Claudia Ximena Montano Herrera', 'TGI', '52345671', 15, 12), ('Santiago Andres Pinto Guerrero', 'TGI', '1056892345', 3, 6), ('Maria Camila Suarez Nieto', 'TGI', '1098234567', 5, 7), ('Victor Hugo Zuluaga Marin', 'TGI', '91123456', 13, 21),
('Laura Vanessa Moreno Pena', 'TGI', '1043098765', 2, 4), ('Nicolas Esteban Diaz Uribe', 'TGI', '1078012349', 17, 13), ('Zulema Patricia Vargas Cano', 'TGI', '43456790', 8, 26);

-- ========================================================
-- Inserciones: Capacitacion
-- ========================================================
INSERT INTO Capacitacion (duracion, tema, actividad, asistenciaProgramada, accidentesAsociados, idUsuarioFK, idProgramaFK) VALUES
(8.0, 'Uso y verificación de EPP para alturas', 'Revisión de equipos de protección personal', 20, 0, 1, 1), (16.0, 'Trabajo en cuerdas y sistemas de anclaje', 'Entrenamiento en técnicas de ascenso y descenso', 15, 0, 1, 1), (4.0, 'Rescate en alturas', 'Simulacro de rescate en estructura elevada', 12, 1, 2, 1), (6.0, 'Manejo defensivo en vías rurales', 'Conducción segura en terrenos difíciles', 18, 0, 1, 2), (4.0, 'Normativa de tránsito para conductores', 'Revisión de código nacional de tránsito', 25, 0, 2, 2),
(8.0, 'Fatiga al volante y factores de riesgo', 'Análisis de accidentes por fatiga', 10, 0, 1, 2), (6.0, 'Riesgo eléctrico en baja tensión', 'Identificación de peligros eléctricos domésticos', 30, 0, 2, 3), (8.0, 'Bloqueo y etiquetado LOTO', 'Procedimiento estándar LOTO en campo', 14, 0, 1, 3), (4.0, 'Primeros auxilios en electrocución', 'Atención inmediata ante contacto eléctrico', 22, 2, 2, 3), (12.0, 'Entrenamiento trabajador entrante', 'Procedimientos de ingreso a espacio confinado', 16, 0, 1, 4),
(8.0, 'Entrenamiento vigías', 'Funciones y responsabilidades del vigía', 16, 0, 2, 4), (6.0, 'Equipos de rescate en espacios confinados', 'Uso de trípode y arnés en extracción', 10, 1, 1, 4), (4.0, 'Hábitos de vida saludable', 'Actividad física y descanso adecuado', 35, 0, 2, 5), (3.0, 'Alimentación saludable en campo', 'Nutrición básica para trabajadores en turno', 28, 0, 1, 5), (2.0, 'Riesgo cardiovascular y estrés laboral', 'Control del estrés y signos de alerta', 40, 0, 2, 5),
(8.0, 'Almacenamiento seguro de químicos', 'Clasificación SGA y fichas de seguridad', 18, 0, 1, 6), (6.0, 'Uso de EPP químico', 'Selección y mantenimiento de EPP para químicos', 15, 0, 2, 6), (4.0, 'Respuesta ante derrames', 'Plan de acción ante derrame de sustancias', 20, 0, 1, 6), (10.0, 'Sistemas de detención de caídas', 'Tipos de arnés y puntos de anclaje', 22, 0, 2, 7), (6.0, 'Inspección de líneas de vida', 'Criterios de retiro y mantenimiento', 17, 0, 1, 7),
(4.0, 'Caídas al mismo nivel', 'Identificación de superficies resbaladizas', 30, 0, 2, 7), (8.0, 'RCP y desfibrilación', 'Técnica de RCP y uso del DEA', 25, 0, 1, 8), (6.0, 'Manejo de heridas y quemaduras', 'Curación básica y clasificación de quemaduras', 20, 0, 2, 8), (4.0, 'Triaje en campo', 'Clasificación de víctimas en emergencias masivas', 12, 0, 1, 8), (10.0, 'Uso y mantenimiento de extintores', 'Tipos de fuego y agentes extintores', 28, 0, 2, 9),
(8.0, 'Evacuación y brigada contra incendios', 'Plan de evacuación y roles de la brigada', 32, 0, 1, 9), (6.0, 'Sistemas fijos de supresión', 'Fundamentos de rociadores y CO2', 14, 0, 2, 9), (4.0, 'Higiene postural en oficina', 'Ajuste de puesto de trabajo y pausas activas', 45, 0, 1, 10), (6.0, 'Manejo manual de cargas', 'Técnica segura de levantamiento y transporte', 38, 0, 2, 10), (8.0, 'Desórdenes musculoesqueléticos', 'Identificación y prevención de DME en campo', 22, 0, 1, 10),
(5.0, 'Señalización y demarcación en alturas', 'Zonas de peligro y acceso restringido', 18, 0, 2, 1), (3.0, 'Check-list de inspección preoperacional', 'Diligenciamiento de formatos de pre-op', 20, 0, 1, 2), (6.0, 'Riesgo eléctrico en alta tensión', 'Distancias de seguridad y permisos de trabajo', 10, 0, 2, 3), (4.0, 'Atmosferas peligrosas en espacios confinados', 'Medición de gases y niveles permisibles', 14, 0, 1, 4), (3.0, 'Pausas activas y bienestar', 'Ejercicios de estiramiento para jornada laboral', 50, 0, 2, 5),
(8.0, 'Gestión de residuos químicos peligrosos', 'Disposición final y manifiestos de residuos', 16, 0, 1, 6), (6.0, 'Protección de bordes y perímetros', 'Instalación de barandas y mallas de seguridad', 12, 0, 2, 7), (4.0, 'Botiquín de primeros auxilios', 'Inventario y uso correcto de insumos', 30, 0, 1, 8), (10.0, 'Plan de emergencia contra incendio', 'Simulacro integral de emergencia', 20, 0, 2, 9), (6.0, 'Vibración y ruido ocupacional', 'Efectos en salud y medidas de control', 25, 0, 1, 10),
(4.0, 'Investigación de incidentes', 'Metodología de árbol de causas', 18, 0, 2, 1), (8.0, 'Conducción en vías de alto riesgo', 'Manejo en zonas de conflicto y clima adverso', 14, 0, 1, 2), (3.0, 'Medidas de prevención de arco eléctrico', 'Equipos de protección contra arco', 10, 0, 2, 3), (6.0, 'Permisos de trabajo en espacios confinados', 'Diligenciamiento y aprobación de permisos', 15, 0, 1, 4), (4.0, 'Tabaquismo y consumo de alcohol en trabajo', 'Política de sustancias psicoactivas', 35, 0, 2, 5),
(6.0, 'Fichas de datos de seguridad FDS', 'Lectura e interpretación de FDS', 20, 0, 1, 6), (8.0, 'Trabajo en andamios', 'Montaje seguro y puntos críticos de andamios', 12, 0, 2, 7), (4.0, 'Hipotermia e insolación en campo', 'Reconocimiento y atención de emergencias térmicas', 18, 0, 1, 8), (10.0, 'Detección temprana de incendios', 'Sistemas de detección y alarma', 22, 0, 2, 9), (6.0, 'Iluminación y confort visual', 'Condiciones lumínicas en puesto de trabajo', 28, 0, 1, 10);

-- ========================================================
-- Inserciones: detalleCapacitacion
-- ========================================================
INSERT INTO detalleCapacitacion (idResponsableFK, idCapacitacionFK) VALUES
(11, 1), (14, 2), (17, 3), (20, 4), (3, 5),
(6, 6), (9, 7), (12, 8), (15, 9), (18, 10),
(1, 11), (4, 12), (7, 13), (10, 14), (13, 15),
(16, 16), (19, 17), (2, 18), (5, 19), (8, 20),
(11, 21), (14, 22), (17, 23), (20, 24), (3, 25),
(6, 26), (9, 27), (12, 28), (15, 29), (18, 30),
(1, 31), (4, 32), (7, 33), (10, 34), (13, 35),
(16, 36), (19, 37), (2, 38), (5, 39), (8, 40),
(11, 41), (14, 42), (17, 43), (20, 44), (3, 45),
(6, 46), (9, 47), (12, 48), (15, 49), (18, 50),
(8, 1), (16, 2), (3, 3), (10, 4), (18, 5),
(5, 6), (13, 7), (20, 8), (7, 9), (14, 10),
(3, 11), (10, 12), (17, 13), (4, 14), (11, 15),
(19, 16), (6, 17), (14, 18), (1, 19), (9, 20);

-- ========================================================
-- Inserciones: Programacion
-- ========================================================
INSERT INTO Programacion (fechaProgramada, horaProgramada, lugarProgramado, modalidadProgramada, idCapacitacionFK, estadoProgramacion) VALUES
('2026-03-25', '07:00:00', 'Sede Administrativa Central - Sala A', 'presencial', 29, 'realizada'), ('2026-03-26', '07:30:00', 'Sala de Capacitaciones Barrancabermeja', 'virtual', 30, 'realizada'), ('2026-03-27', '08:00:00', 'Auditorio Sede Norte Bogota', 'presencial', 31, 'realizada'), ('2026-03-28', '08:30:00', 'Centro de Entrenamiento Vasconia', 'virtual', 32, 'realizada'), ('2026-03-29', '09:00:00', 'Sala Virtual - Teams', 'presencial', 33, 'realizada'),
('2026-03-30', '09:30:00', 'Campo Cogua - Area Externa', 'virtual', 34, 'realizada'), ('2026-03-31', '10:00:00', 'Sala de Juntas Cali', 'presencial', 35, 'realizada'), ('2026-04-01', '13:00:00', 'Auditorio Sede Medellin', 'virtual', 36, 'realizada'), ('2026-04-02', '13:30:00', 'Centro Logistico Cartagena - Sala B', 'presencial', 38, 'realizada'), ('2026-04-03', '14:00:00', 'Sede Campo Yopal - Carpa Principal', 'virtual', 39, 'realizada'),
('2026-04-04', '14:30:00', 'Planta Compresora Occidente - Sala Tecnica', 'presencial', 40, 'realizada'), ('2026-04-05', '15:00:00', 'Sala Virtual - Zoom', 'virtual', 41, 'realizada'), ('2026-04-06', '15:30:00', 'Sede Bucaramanga - Aula 2', 'presencial', 42, 'realizada'), ('2026-04-07', '16:00:00', 'Area de Entrenamiento Meta', 'virtual', 43, 'cancelada'), ('2026-04-08', '17:00:00', 'Sede Administrativa Central - Sala A', 'presencial', 45, 'realizada'),
('2026-04-09', '17:30:00', 'Sala de Capacitaciones Barrancabermeja', 'virtual', 46, 'realizada'), ('2026-04-10', '07:00:00', 'Auditorio Sede Norte Bogota', 'presencial', 47, 'realizada'), ('2026-04-11', '07:30:00', 'Centro de Entrenamiento Vasconia', 'virtual', 48, 'cancelada'), ('2026-04-12', '08:00:00', 'Sala Virtual - Teams', 'presencial', 49, 'realizada'), ('2026-04-13', '08:30:00', 'Campo Cogua - Area Externa', 'virtual', 50, 'realizada'),
('2026-04-14', '09:00:00', 'Sala de Juntas Cali', 'presencial', 1, 'cancelada'), ('2026-04-15', '09:30:00', 'Auditorio Sede Medellin', 'virtual', 1, 'realizada'), ('2026-04-16', '10:00:00', 'Centro Logistico Cartagena - Sala B', 'presencial', 2, 'cancelada'), ('2026-04-17', '13:00:00', 'Sede Campo Yopal - Carpa Principal', 'virtual', 2, 'realizada'), ('2026-04-18', '13:30:00', 'Planta Compresora Occidente - Sala Tecnica', 'presencial', 3, 'realizada'),
('2026-04-19', '14:00:00', 'Sala Virtual - Zoom', 'virtual', 3, 'realizada'), ('2026-04-20', '14:30:00', 'Sede Bucaramanga - Aula 2', 'presencial', 4, 'realizada'), ('2026-04-21', '15:00:00', 'Area de Entrenamiento Meta', 'virtual', 4, 'realizada'), ('2026-03-25', '15:30:00', 'Sede Administrativa Central - Sala A', 'presencial', 5, 'realizada'), ('2026-03-26', '16:00:00', 'Sala de Capacitaciones Barrancabermeja', 'virtual', 5, 'realizada'),
('2026-03-27', '17:00:00', 'Auditorio Sede Norte Bogota', 'presencial', 6, 'realizada'), ('2026-03-28', '17:30:00', 'Centro de Entrenamiento Vasconia', 'virtual', 6, 'realizada'), ('2026-03-29', '07:00:00', 'Sala Virtual - Teams', 'presencial', 8, 'realizada'), ('2026-03-30', '07:30:00', 'Campo Cogua - Area Externa', 'virtual', 8, 'realizada'), ('2026-03-31', '08:00:00', 'Sala de Juntas Cali', 'presencial', 9, 'realizada'),
('2026-04-01', '08:30:00', 'Auditorio Sede Medellin', 'virtual', 9, 'realizada'), ('2026-04-02', '09:00:00', 'Centro Logistico Cartagena - Sala B', 'presencial', 10, 'realizada'), ('2026-04-03', '09:30:00', 'Sede Campo Yopal - Carpa Principal', 'virtual', 10, 'realizada'), ('2026-04-04', '10:00:00', 'Planta Compresora Occidente - Sala Tecnica', 'presencial', 11, 'realizada'), ('2026-04-05', '13:00:00', 'Sala Virtual - Zoom', 'virtual', 11, 'realizada'),
('2026-04-06', '13:30:00', 'Sede Bucaramanga - Aula 2', 'presencial', 12, 'realizada'), ('2026-04-07', '14:00:00', 'Area de Entrenamiento Meta', 'virtual', 12, 'realizada'), ('2026-04-08', '14:30:00', 'Sede Administrativa Central - Sala A', 'presencial', 13, 'realizada'), ('2026-04-09', '15:00:00', 'Sala de Capacitaciones Barrancabermeja', 'virtual', 13, 'realizada'), ('2026-04-10', '15:30:00', 'Auditorio Sede Norte Bogota', 'presencial', 15, 'realizada'),
('2026-04-11', '16:00:00', 'Centro de Entrenamiento Vasconia', 'virtual', 15, 'realizada'), ('2026-04-12', '17:00:00', 'Sala Virtual - Teams', 'presencial', 16, 'realizada'), ('2026-04-13', '17:30:00', 'Campo Cogua - Area Externa', 'virtual', 16, 'cancelada'), ('2026-04-14', '07:00:00', 'Sala de Juntas Cali', 'presencial', 17, 'realizada'), ('2026-04-15', '07:30:00', 'Auditorio Sede Medellin', 'virtual', 17, 'realizada'),
('2026-04-16', '08:00:00', 'Centro Logistico Cartagena - Sala B', 'presencial', 18, 'cancelada'), ('2026-04-17', '08:30:00', 'Sede Campo Yopal - Carpa Principal', 'virtual', 18, 'realizada'), ('2026-04-23', '09:00:00', 'Planta Compresora Occidente - Sala Tecnica', 'presencial', 19, 'programada'), ('2026-04-24', '09:30:00', 'Sala Virtual - Zoom', 'virtual', 19, 'programada'), ('2026-04-25', '10:00:00', 'Sede Bucaramanga - Aula 2', 'presencial', 20, 'programada'),
('2026-04-26', '13:00:00', 'Area de Entrenamiento Meta', 'virtual', 20, 'programada'), ('2026-04-27', '13:30:00', 'Sede Administrativa Central - Sala A', 'presencial', 21, 'programada'), ('2026-04-28', '14:00:00', 'Sala de Capacitaciones Barrancabermeja', 'virtual', 21, 'programada'), ('2026-04-29', '14:30:00', 'Auditorio Sede Norte Bogota', 'presencial', 22, 'programada'), ('2026-04-30', '15:00:00', 'Centro de Entrenamiento Vasconia', 'virtual', 22, 'programada'),
('2026-05-01', '15:30:00', 'Sala Virtual - Teams', 'presencial', 24, 'programada'), ('2026-05-02', '16:00:00', 'Campo Cogua - Area Externa', 'virtual', 24, 'programada'), ('2026-05-03', '17:00:00', 'Sala de Juntas Cali', 'presencial', 25, 'programada'), ('2026-05-04', '17:30:00', 'Auditorio Sede Medellin', 'virtual', 25, 'programada'), ('2026-05-05', '07:00:00', 'Centro Logistico Cartagena - Sala B', 'presencial', 26, 'programada'),
('2026-05-06', '07:30:00', 'Sede Campo Yopal - Carpa Principal', 'virtual', 26, 'programada'), ('2026-05-07', '08:00:00', 'Planta Compresora Occidente - Sala Tecnica', 'presencial', 27, 'programada'), ('2026-05-08', '08:30:00', 'Sala Virtual - Zoom', 'virtual', 27, 'cancelada'), ('2026-05-09', '09:00:00', 'Sede Bucaramanga - Aula 2', 'presencial', 28, 'programada'), ('2026-05-10', '09:30:00', 'Area de Entrenamiento Meta', 'virtual', 28, 'programada');

-- ========================================================
-- Inserciones: Asistencia
-- ========================================================
INSERT INTO Asistencia (asistio, fechaDeAsistencia, evaluacionCapacitador, comentariosCapacitacion, idProgramacionFK, idTrabajadorFK) VALUES
(TRUE, '2026-04-04 14:36:00', 4.0, 'Excelente capacitador', 11, 1), (FALSE, NULL, NULL, NULL, 51, 2), (TRUE, '2026-04-11 16:12:00', 4.0, NULL, 46, 3), (FALSE, NULL, NULL, NULL, 19, 3), (TRUE, '2026-04-09 17:36:00', 5.0, NULL, 16, 4),
(TRUE, '2026-04-08 14:41:00', 3.0, NULL, 43, 5), (FALSE, NULL, NULL, NULL, 56, 6), (FALSE, NULL, NULL, NULL, 18, 6), (TRUE, '2026-03-28 08:44:00', 4.0, NULL, 4, 7), (FALSE, NULL, NULL, NULL, 59, 8),
(TRUE, '2026-04-05 15:16:00', 4.0, 'Muy bien explicado', 12, 9), (TRUE, '2026-03-29 07:00:00', 5.0, 'No quedo claro', 33, 10), (TRUE, '2026-04-06 15:36:00', 4.0, NULL, 13, 11), (TRUE, '2026-04-15 09:36:00', 1.0, NULL, 22, 12),
(TRUE, '2026-03-30 09:44:00', 4.0, NULL, 6, 12), (FALSE, NULL, NULL, NULL, 57, 13), (TRUE, '2026-03-27 17:05:00', 5.0, 'Muy didactico', 31, 14), (FALSE, NULL, NULL, NULL, 3, 15), (FALSE, NULL, NULL, NULL, 62, 15),
(TRUE, '2026-03-31 10:02:00', 5.0, NULL, 7, 16), (TRUE, '2026-04-14 07:04:00', 4.0, 'Deberias mejorar las instalaciones', 49, 17), (TRUE, '2026-03-27 17:14:00', 5.0, NULL, 31, 17), (FALSE, NULL, NULL, NULL, 58, 18), (TRUE, '2026-04-17 08:41:00', 2.0, NULL, 52, 19),
(FALSE, NULL, NULL, NULL, 61, 20), (FALSE, NULL, NULL, NULL, 26, 20), (TRUE, '2026-04-18 13:49:00', 4.0, 'No quedo claro', 25, 21), (FALSE, NULL, NULL, NULL, 32, 21), (FALSE, NULL, NULL, NULL, 62, 22),
(FALSE, NULL, NULL, NULL, 67, 23), (FALSE, NULL, NULL, NULL, 41, 23), (TRUE, '2026-04-15 07:35:00', 5.0, NULL, 50, 24), (TRUE, '2026-03-31 08:10:00', 4.0, NULL, 35, 24), (TRUE, '2026-04-06 13:33:00', 3.0, 'Falto mas practica en campo', 41, 25),
(TRUE, '2026-04-02 09:18:00', 3.0, 'Buen manejo del grupo', 37, 25), (TRUE, '2026-04-05 13:12:00', 5.0, NULL, 40, 26), (TRUE, '2026-04-17 08:35:00', 3.0, NULL, 52, 26), (FALSE, NULL, NULL, NULL, 53, 27), (FALSE, NULL, NULL, NULL, 70, 28),
(TRUE, '2026-04-09 15:12:00', 4.0, 'El tema no se profundizo suficiente', 44, 28), (TRUE, '2026-04-19 14:09:00', 5.0, NULL, 26, 29), (TRUE, '2026-04-13 08:37:00', 5.0, NULL, 20, 30), (TRUE, '2026-04-20 14:44:00', 5.0, NULL, 27, 31), (FALSE, NULL, NULL, NULL, 47, 31),
(TRUE, '2026-04-07 14:10:00', 3.0, NULL, 42, 32), (TRUE, '2026-04-01 13:08:00', 5.0, 'El instructor llego tarde', 8, 33), (TRUE, '2026-04-11 16:12:00', 4.0, NULL, 46, 33), (FALSE, NULL, NULL, NULL, 21, 34),
(TRUE, '2026-03-29 09:14:00', 5.0, 'Muy bien explicado', 5, 35), (FALSE, NULL, NULL, NULL, 64, 36), (TRUE, '2026-04-10 15:39:00', 1.0, 'El proyector fallo a mitad', 45, 37), (TRUE, '2026-04-02 09:08:00', 4.0, NULL, 37, 38), (TRUE, '2026-04-01 08:37:00', 5.0, NULL, 36, 39),
(TRUE, '2026-04-04 10:00:00', 5.0, NULL, 39, 39), (FALSE, NULL, NULL, NULL, 32, 40), (TRUE, '2026-04-08 17:05:00', 4.0, NULL, 15, 41), (FALSE, NULL, NULL, NULL, 63, 41), (FALSE, NULL, NULL, NULL, 23, 42),
(TRUE, '2026-04-12 17:08:00', 4.0, NULL, 47, 43), (TRUE, '2026-04-18 13:46:00', 4.0, NULL, 25, 43), (FALSE, NULL, NULL, NULL, 54, 44), (FALSE, NULL, NULL, NULL, 60, 45), (FALSE, NULL, NULL, NULL, 65, 46),
(TRUE, '2026-03-30 07:49:00', 4.0, 'Excelente capacitador', 34, 46), (TRUE, '2026-04-10 07:02:00', 4.0, NULL, 17, 47), (TRUE, '2026-04-15 07:41:00', 1.0, NULL, 50, 47), (TRUE, '2026-03-30 09:48:00', 5.0, NULL, 6, 48), (TRUE, '2026-04-03 14:12:00', 5.0, 'Sigue asi', 10, 49),
(FALSE, NULL, NULL, NULL, 18, 50), (TRUE, '2026-04-08 14:44:00', 3.0, NULL, 43, 50), (TRUE, '2026-03-25 07:17:00', 1.0, 'Aprendi mucho', 1, 51), (TRUE, '2026-04-04 10:12:00', 5.0, NULL, 39, 52), (TRUE, '2026-04-09 15:18:00', 3.0, NULL, 44, 53),
(FALSE, NULL, NULL, NULL, 23, 53), (FALSE, NULL, NULL, NULL, 63, 54), (TRUE, '2026-04-21 15:05:00', 1.0, NULL, 28, 55), (TRUE, '2026-04-03 14:16:00', 5.0, 'Buen manejo del grupo', 10, 55), (TRUE, '2026-03-26 07:30:00', 4.0, NULL, 2, 56),
(TRUE, '2026-04-10 07:18:00', 5.0, 'Muy bien explicado', 17, 56), (FALSE, NULL, NULL, NULL, 66, 57), (FALSE, NULL, NULL, NULL, 48, 58), (FALSE, NULL, NULL, NULL, 14, 59), (TRUE, '2026-04-01 13:01:00', 5.0, 'El proyector fallo a mitad', 8, 59),
(FALSE, NULL, NULL, NULL, 55, 60), (TRUE, '2026-03-27 08:01:00', 4.0, NULL, 3, 60), (TRUE, '2026-03-31 08:03:00', 5.0, 'Deberias mejorar las instalaciones', 35, 61), (TRUE, '2026-03-28 08:36:00', 4.0, 'Deberias compartir el material', 4, 61), (FALSE, NULL, NULL, NULL, 5, 62),
(TRUE, '2026-04-02 13:34:00', 3.0, 'Deberias compartir el material', 9, 63), (FALSE, NULL, NULL, NULL, 68, 64), (TRUE, '2026-03-25 15:35:00', 5.0, NULL, 29, 65), (TRUE, '2026-04-12 08:19:00', 4.0, NULL, 19, 66), (TRUE, '2026-03-26 16:01:00', 3.0, NULL, 30, 67),
(FALSE, NULL, NULL, NULL, 51, 67), (TRUE, '2026-04-17 13:09:00', 5.0, 'Deberias compartir el material', 24, 68);


SELECT * FROM Programa;
SELECT * FROM Cargo;
SELECT * FROM Responsable;
SELECT * FROM CentroTrabajo;
SELECT * FROM Usuario;
SELECT * FROM Trabajador;
SELECT * FROM Capacitacion;
SELECT * FROM detalleCapacitacion;
SELECT * FROM Programacion;
SELECT * FROM Asistencia;


-- -----------------------------------------------------
-- CONSULTAS BÁSICAS
-- -----------------------------------------------------
-- RQF004: Consultar información de Usuario
SELECT * FROM Usuario;
-- RQF009: Mostrar lista completa de programas
SELECT * FROM Programa;
-- RQF011: Consultar lista completa de responsables
SELECT * FROM Responsable;
-- RQF014: Mostrar lista completa de capacitaciones
SELECT * FROM Capacitacion;
-- RQF025: Consultar todos los cargos
SELECT * FROM Cargo;
-- RQF027: Consultar todos los centros de trabajo
SELECT * FROM CentroTrabajo;
-- RQF029: Consultar información de trabajadores
SELECT 
t.documentoTrabajador, 
t.nombreTrabajador, 
t.empresaDondeTrabaja, 
c.nombreCargo, 
ct.nombreCentroTrabajo, 
ct.ciudad 
FROM Trabajador t
INNER JOIN Cargo c ON t.idCargoFK = c.idCargo
INNER JOIN CentroTrabajo ct ON t.idCentroTrabajoFK = ct.idCentroTrabajo
-- -----------------------------------------------------
-- CONSULTAS ESPECÍFICAS
-- -----------------------------------------------------
-- RQF013: Consultar infromación general de una capacitación
SELECT c.tema, c.actividad, p.nombrePrograma
FROM Capacitacion c
INNER JOIN Programa p ON c.idProgramaFK = p.idPrograma
WHERE c.idCapacitacion = 1;

-- RQF019: Consultar información de programación
SELECT p.fechaProgramada, p.horaProgramada, c.tema
FROM Programacion p
INNER JOIN Capacitacion c ON p.idCapacitacionFK = c.idCapacitacion
WHERE p.idProgramacion = 1;

-- RQF033: Consultar trabajadores que ejercen un cargo
SELECT 
c.nombreCargo,
t.nombreTrabajador,
t.documentoTrabajador
FROM Cargo c
INNER JOIN  Trabajador t ON t.idCargoFK = c.idCargo
WHERE c.idCargo = 1;

-- RQF034: Consultar trabajadores de un centro de trabajo
SELECT
ct.nombreCentroTrabajo,
t.nombreTrabajador,
t.documentoTrabajador 
FROM CentroTrabajo ct
INNER JOIN Trabajador t ON t.idCentroTrabajoFK = ct.idCentroTrabajo
WHERE ct.idCentroTrabajo = 1;

-- RQF035: Consultar trabajadores por ciudad
SELECT 
t.nombreTrabajador AS Trabajador,
t.documentoTrabajador AS Documento,
ct.ciudad
FROM Trabajador t
INNER JOIN centroTrabajo ct ON ct.idCentroTrabajo = t.idCentroTrabajoFK
WHERE ct.ciudad = 'Barrancabermeja';

-- RQF040: Consultar número de asistentes citados a una programación
SELECT COUNT(*) AS totalAsistentes 
FROM Asistencia
WHERE idProgramacionFK = 1;

-- RQF041: Consultar lista de trabajadores citados a una programación
SELECT t.nombreTrabajador
FROM Asistencia a
INNER JOIN Trabajador t ON a.idTrabajadorFK = t.idTrabajador
WHERE a.idProgramacionFK = 1;

-- RQF042: Consultar programación por estado
SELECT *
FROM Programacion
WHERE estadoProgramacion = 'programada';

-- RQF043: Consultar programaciones en rango de fecha
SELECT *
FROM Programacion
WHERE fechaProgramada BETWEEN '2026-03-25' AND '2026-05-10';

-- RQF047: Calcular número capacitaciones programadas a un trabajador
SELECT COUNT(*) AS totalProgramadas
FROM Asistencia 
WHERE idTrabajadorFK = 1;

-- RQF048: Calcular número de capacitaciones asistidas por un trabajador
SELECT COUNT(*) AS totalAsistidas
FROM Asistencia
WHERE idTrabajadorFK = 1 AND asistio = 1;

-- RQF049: Calcular porcentaje de cumplpimiento a capacitaciones por trabajador
SELECT 
(COUNT(CASE WHEN asistio = 1 THEN 1 END) * 100.0 / COUNT(*)) AS porcentaje
FROM Asistencia 
WHERE idTrabajadorFK = 1;

-- RQF050: Calcular promedio de evaluaciones de los trabajadores a capacitación}
SELECT AVG(evaluacionCapacitador) AS promedio
FROM Asistencia
WHERE idProgramacionFK = 1;

-- RQF052: Consultar número de accidentes asociados a capacitación
SELECT SUM(accidentesAsociados) AS totalAccidentesAsociados
FROM Capacitacion
WHERE idCapacitacion = 1;

-- RQF054: Consultar trabajadores que no pertenecen a TGI
SELECT * FROM Trabajador
WHERE empresaDondeTrabaja <> 'TGI';

-- -----------------------------------------------------
-- MODIFICACIONES
-- -----------------------------------------------------

-- RQF005: Modificar rol de Usuario
UPDATE Usuario 
SET rolUsuario = 'admin' 
WHERE idUsuario = 4;

-- RQF015: Modificar tema y actividad de capacitación
UPDATE Capacitacion 
SET 
tema = 'Nuevo enfoque en Trabajo en Alturas', 
actividad = 'Simulacro avanzado en andamios' 
WHERE idCapacitacion = 1;

-- RQF020: Modificar estado de Programación
UPDATE Programacion 
SET estadoProgramacion = 'cancelada' 
WHERE idProgramacion = 15;

-- RQF022: Cambiar modalidad de programación
UPDATE Programacion 
SET modalidadProgramada = 'virtual' 
WHERE idProgramacion = 12;

-- RQF030: Modificar información de trabajador
UPDATE Trabajador 
SET
empresaDondeTrabaja = 'TGI', 
nombreTrabajador = 'Carlos Andres Peña Modificado' 
WHERE idTrabajador = 6;

-- RQF006: Modificar estado de usuario
UPDATE Usuario
SET estadoUsuario = 'inactivo'
WHERE idUsuario = 1;

-- RQF007: Cambiar contraseña de usuario
UPDATE Usuario
SET contrasenaUsuario = 'voyARetirar'
WHERE idUsuario = 2;

-- RQF017: Modificar nombre de responsable
UPDATE Responsable
SET nombreResponsable = 'Dayro Castellanos Sanchez'
WHERE idResponsable = 3;

-- RQF021: Modificar fecha y hora de programación
UPDATE Programacion 
SET fechaProgramada = '2026-08-15', horaProgramada = '14:00:00' 
WHERE idProgramacion = 5;

-- RQF023: Modificar lugar de realización de programación
UPDATE Programacion
SET lugarProgramado = 'Cementerio'
WHERE idProgramacion = 5;

-- RQF031: Modificar cargo de un trabajador
UPDATE Trabajador
SET idCargoFK = 4
WHERE documentoTrabajador = '1045678901';

-- RQF032: Modificar centro de trabajo de un trabajador
UPDATE Trabajador
SET idCentroTrabajoFK = 2
WHERE documentoTrabajador = '1045678901';

-- RQF046: Resgistrar comentarios de trabajador a programación
UPDATE Asistencia
SET evaluacionCapacitador = 5;
comentariosCapacitacion = 'Muy buen servicio'
WHERE idTrabajadorFK = 1
AND idProgrmacionFK = 2;

-- holateamoprincesahermosa

-- RQF051: Registrar accidente de trabajo asociado a capacitación
UPDATE Capacitacion
SET accidentesAsociados = accidentesAsociados + 1
WHERE id_capacitacion = 1;

-- RQF055: Modificar estado del ciclo PHVA del programa
UPDATE Programa
SET fasePHVA = 'verificar'
WHERE idPrograma = 1;


-- -----------------------------------------------------
-- ELIMINACION
-- -----------------------------------------------------
-- RQF044:
DELETE FROM Asistencia
WHERE idProgramacionFK = 45
AND idTrabajadorFK = 3
AND asistio = 0;	

-- -----------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS, FUNCIONES Y VISTAS
-- -----------------------------------------------------
-- RQF016: Modificar lista de responsables de una capacitación
DELIMITER //
CREATE PROCEDURE sp_modificar_lista_responsables(
    IN p_id_capacitacion INT,
    IN p_id_responsable INT,
    IN p_accion ENUM('agregar', 'eliminar'),
    OUT p_mensaje VARCHAR(50)
)
BEGIN
    DECLARE v_id_detalle INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error, revirtiendo cambios';
    END;
    
    SELECT idDetalle INTO v_id_detalle
    FROM detalleCapacitacion
    WHERE idCapacitacionFK = p_id_capacitacion AND idResponsableFK = p_id_responsable
    LIMIT 1;
    
    IF p_accion = 'agregar' THEN
        IF v_id_detalle IS NOT NULL THEN
            SET p_mensaje = 'El responsable ya estaba asignado';
        ELSE
            START TRANSACTION;
                INSERT INTO detalleCapacitacion (idResponsableFK, idCapacitacionFK)
                VALUES (p_id_responsable, p_id_capacitacion);
            COMMIT;
            SET p_mensaje = 'Responsable agregado a la capacitación correctamente';
        END IF;
        
    ELSEIF p_accion = 'eliminar' THEN
        IF v_id_detalle IS NULL THEN
            SET p_mensaje = 'El responsable no está asignado ya';
        ELSE
            START TRANSACTION;
                DELETE FROM detalleCapacitacion
                WHERE idDetalle = v_id_detalle;
            COMMIT;
            SET p_mensaje = 'Responsable eliminado de la capacitación';
        END IF;
    END IF;
END //
DELIMITER ;

CALL sp_modificar_lista_responsables(16, 16, 'agregar', @msg);

-- RQF036: Añadir trabajador al aforo de una programación de capacitación
DELIMITER //
CREATE PROCEDURE sp_agregar_trabajador_programacion(
IN p_idProgramacion INT,
IN p_idTrabajador INT,
OUT p_mensaje VARCHAR(100)
)
BEGIN
	DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe -- el trabajador ya esta en la programacion¿ si es >0, significa que si
    FROM Asistencia
    WHERE idProgramacionFK = p_idProgramacion
    AND idTrabajadorFK = p_idTrabajador;
	
	IF v_existe = 0 THEN
		INSERT INTO Asistencia(
        asistio,
        idProgramacionFK,
        idTrabajadorFK
        )
        VALUES(
        0,
        p_idProgramacion,
        p_idTrabajador
        );
        SET p_mensaje = 'Trabajador añadido correctamente';
        ELSE
        SET p_mensaje = 'El trabajador ya está convocado';
        END IF;
END //
DELIMITER ;

-- RQF037: Añadir trabajadores al aforo de una programación por centro de trabajo
INSERT INTO Asistencia(
	asistio,
  idProgramacionFK,
  idTrabajadorFK
)
SELECT
0,
1,
t.idTrabajador
FROM Trabajador t
WHERE t.idCentroTrabajoFK = 2;

-- RQF038: Añadir trabajadores al aforo de una programación por ciudad
INSERT INTO Asistencia(
	asistio,
  idProgramacionFK,
  idTrabajadorFK
)
SELECT
0,
1,
t.idTrabajador
FROM Trabajador t
INNER JOIN centroTrabajo ct ON t.idCentroTrabajoFK = ct.idCentroTrabajo
WHERE ct.ciudad = 'Barrancabermeja';

-- RQF039: Añadir trabajadores al aforo de una programación por cargo
INSERT INTO Asistencia(
	asistio,
  idProgramacionFK,
  idTrabajadorFK
)
SELECT
0,
1,
t.idTrabajador
FROM Trabajador t
WHERE t.idCargoFK = 2;



-- RQF045: Registrar asistencia a capacitación
DELIMITER //
CREATE PROCEDURE sp_registrar_asistencia(
	IN p_id_trabajador INT,
    IN p_id_programacion INT,
    IN p_fechaAsistencia DATETIME,
    IN p_evaluacionCapacitador INT,
    IN p_comentariosCapacitacion VARCHAR(120),
    OUT p_mensaje VARCHAR(50)
)
BEGIN 
	DECLARE v_id_asistencia INT;
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error, revirtiendo cambios';
    END;
    
    SELECT idAsistencia INTO v_id_asistencia
    FROM asistencia
    WHERE idTrabajadorFK = p_id_trabajador AND idProgramacionFK = p_id_programacion;
    
    IF v_id_asistencia IS NULL THEN
		SET p_mensaje = 'El trabajador no fue citado a esta programación';
	ELSEIF asistio = 1 THEN
		SET p_mensaje = 'Esta asistencia ya estaba registrada';
    ELSE
		START TRANSACTION;
			UPDATE asistencia SET
				asistio = 1,
				fechaDeAsistencia = p_fechaAsistencia,
                evaluacionCapacitador = p_evaluacionCapacitador,
                comentariosCapacitacion = p_comentariosCapacitacion
			WHERE idAsistencia = v_id_asistencia;
        COMMIT;
        SET p_mensaje = 'Fue registrada la asistencia';
	END IF;
END //
DELIMITER ;

-- RQF053: Calcular porcentaje de cumplimiento de asistencia por rango de fecha en las capacitaciones de un programa
DELIMITER //
CREATE FUNCTION fn_num_asistentes_fechas(
	p_id_programa INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_numAsistentes INT;
    
    SELECT COUNT(a.idAsistencia) INTO v_numAsistentes
    FROM asistencia a
	INNER JOIN Programacion pr on pr.idProgramacion = a.idProgramacionFK
	INNER JOIN Capacitacion c on pr.idCapacitacionFK = c.idCapacitacion
	INNER JOIN Programa p on c.idProgramaFK = p.idPrograma
	WHERE	asistio = 1 AND p.idPrograma = p_id_programa AND
							(a.fechaDeAsistencia BETWEEN p_fecha_inicio AND p_fecha_fin);
                            
	RETURN v_numAsistentes;
END //
DELIMITER ;
DROP FUNCTION fn_asistencia_programada_fechas;
DELIMITER //
CREATE FUNCTION fn_asistencia_programada_fechas(
	p_id_programa INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_asistenciaProgramada INT;
    
	SELECT	COUNT(a.idAsistencia) INTO v_asistenciaProgramada
			FROM programa p
			INNER JOIN Capacitacion c on p.idPrograma = c.idProgramaFK
			INNER JOIN Programacion pr on pr.idCapacitacionFK = c.idCapacitacion
            INNER JOIN Asistencia a on a.idProgramacionFK = pr.idProgramacion
            WHERE p.idPrograma = p_id_programa 
			AND (pr.fechaProgramada BETWEEN p_fecha_inicio AND p_fecha_fin);
    
    RETURN v_asistenciaProgramada;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_porcentaje_cumplimiento_fechas(
	p_id_programa INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS DECIMAL(3,2)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_asistenciaProgramada INT;
    DECLARE v_numAsistentes INT;
    DECLARE v_porcentaje DECIMAL(5,2);
    
	SET v_asistenciaProgramada = fn_asistencia_programada_fechas(p_id_programa, p_fecha_inicio, p_fecha_fin);
    
    SET v_numAsistentes = fn_num_asistentes_fechas(p_id_programa, p_fecha_inicio, p_fecha_fin);
    
    SET v_porcentaje = (v_asistenciaProgramada/v_numAsistentes)*100;
    
    RETURN v_porcentaje;
END //
DELIMITER ;

SELECT 	nombrePrograma,
		COUNT(c.idCapacitacion) AS NumCapacitaciones,
		fn_num_asistentes_fechas(7,'2026-01-01','2026-12-31') as NumAsistentes,
        fn_asistencia_programada_fechas(7,'2026-01-01','2026-12-31') as AsistenciaProgramada, 
		fn_porcentaje_cumplimiento_fechas(7,'2026-01-01','2026-12-31') as PorcentajeCumplimiento
FROM programa p
INNER JOIN capacitacion c ON c.idProgramaFK = p.idPrograma
WHERE p.idPrograma = 7;
