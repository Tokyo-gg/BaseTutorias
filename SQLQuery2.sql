CREATE TABLE Usuario (
    Id INT PRIMARY KEY ,
    N1 NVARCHAR(50),            -- Primer nombre
    N2 NVARCHAR(50),            -- Segundo nombre
    A1 NVARCHAR(50),            -- Primer apellido
    A2 NVARCHAR(50),            -- Segundo apellido
    Email NVARCHAR(100) UNIQUE, -- Email único
    Contraseña NVARCHAR(100)
);

CREATE TABLE Rol (
    Id INT PRIMARY KEY ,
    Nombre NVARCHAR(50)             -- Nombre del rol (Ejemplo: 'Estudiante', 'Tutor', 'Administrador')
);

CREATE TABLE UsuarioRol (
    Id INT PRIMARY KEY ,
    Id_usuario INT,             -- FK a Usuario.Id
    Id_rol INT,                 -- FK a Rol.Id
    CONSTRAINT FK_UsuarioRol_Usuario FOREIGN KEY (Id_usuario) REFERENCES Usuario(Id),
    CONSTRAINT FK_UsuarioRol_Rol FOREIGN KEY (Id_rol) REFERENCES Rol(Id)
);

CREATE TABLE Permiso (
    Id INT PRIMARY KEY ,
    Reporte_de_tutor NVARCHAR(100),
	Administrar_Facturacion NVARCHAR(100),
	Subir_reporte NVARCHAR(100),
	Agendar_tutoria NVARCHAR(100),
    Descripcion NVARCHAR(255)
);

CREATE TABLE RolPermiso (
    Id INT PRIMARY KEY ,
    Id_Rol INT,
    Id_Permiso INT,
    CONSTRAINT FK_RolPermiso_Rol FOREIGN KEY (Id_rol) REFERENCES Rol(Id),
    CONSTRAINT FK_RolPermiso_Permiso FOREIGN KEY (Id_permiso) REFERENCES Permiso(Id)
);

CREATE TABLE Personal (
    Id INT PRIMARY KEY ,
    Nombre NVARCHAR(100),
    Cargo NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE Asistencia (
    Id INT PRIMARY KEY ,
    Id_personal INT,                              -- FK a Personal.Id
    Fecha DATE,
    Asistencia NVARCHAR(20),                      -- Ej. 'Presente' o 'Ausente'
    Desempeño NVARCHAR(100),
    CONSTRAINT FK_Asistencia_Personal FOREIGN KEY (Id_personal) REFERENCES Personal(Id)
);

CREATE TABLE Tutor (
    Id INT PRIMARY KEY,                           -- FK a Usuario.Id
    Disponibilidad NVARCHAR(255)
);

CREATE TABLE nivel_dificultad (
    Id INT PRIMARY KEY ,
    Categoria INT,                                -- Ejemplo: 1, 2, 3
    Temas NVARCHAR(255)
);

CREATE TABLE Area (
    Id INT PRIMARY KEY ,
    Nombre NVARCHAR(100)
);

CREATE TABLE Materias (
    Id INT PRIMARY KEY ,
    Nombre NVARCHAR(100),
    Id_area INT,                                  -- FK a Area.Id
    Id_dificultad INT,                            -- FK a nivel_dificultad.Id
    CONSTRAINT FK_Materias_Area FOREIGN KEY (Id_area) REFERENCES Area(Id),
    CONSTRAINT FK_Materias_nivel_dificultad FOREIGN KEY (Id_dificultad) REFERENCES nivel_dificultad(Id)
);

CREATE TABLE Sesion (
    Id INT PRIMARY KEY ,
    Tarifa DECIMAL(10,2),
    Id_tutor INT,                                 -- FK a Tutor.Id
    Id_materia INT,                               -- FK a Materias.Id
    Id_estudiante INT,                            -- FK a Usuario.Id
    Tipo_sesion NVARCHAR(50),                     -- Ej. 'Individual' o 'Grupal'
    Fecha DATE,
    Hora_inicio TIME,
    Hora_fin TIME,
    Lugar NVARCHAR(100),                          -- Sucursal si es presencial
    CONSTRAINT FK_Sesion_Tutor FOREIGN KEY (Id_tutor) REFERENCES Tutor(Id),
    CONSTRAINT FK_Sesion_Materias FOREIGN KEY (Id_materia) REFERENCES Materias(Id),
    CONSTRAINT FK_Sesion_Estudiante FOREIGN KEY (Id_estudiante) REFERENCES Usuario(Id)
);

CREATE TABLE Evaluacion (
    Id INT PRIMARY KEY ,
    Id_sesion INT,
    Id_PagoTutor INT,                                -- FK a Sesion.Id
    Evaluacion_estudiante NVARCHAR(255),
    Reporte_tutor NVARCHAR(255),
    Puntaje INT,
    CONSTRAINT FK_Evaluacion_Sesion FOREIGN KEY (Id_sesion) REFERENCES Sesion(Id),
    CONSTRAINT FK_Evaluacion_PagoTutor FOREIGN KEY (Id_PagoTutor) REFERENCES PagoTutor(Id),
);

CREATE TABLE Factura (
    Id INT PRIMARY KEY ,
    Id_sesion INT,                                -- FK a Sesion.Id
    Total DECIMAL(10, 2),
    Tarifa_por_hora DECIMAL(10, 2),
    Tipo_sesion NVARCHAR(50),                     -- Ej. 'Individual' o 'Grupal'
    Id_PagoTutor INT,                             -- FK a PagoTutor.Id
    Fecha DATE,
    CONSTRAINT FK_Factura_Sesion FOREIGN KEY (Id_sesion) REFERENCES Sesion(Id)
    CONSTRAINT FK_Factura_PagoTutor FOREIGN KEY (Id_PagoTutor) REFERENCES PagoTutor(Id);
);

CREATE TABLE TutorMateria (
    Id INT PRIMARY KEY ,
    Id_tutor INT,                                 -- FK a Tutor.Id
    Id_materia INT,                               -- FK a Materias.Id
    CONSTRAINT FK_TutorMateria_Tutor FOREIGN KEY (Id_tutor) REFERENCES Tutor(Id),
    CONSTRAINT FK_TutorMateria_Materias FOREIGN KEY (Id_materia) REFERENCES Materias(Id)
);
-- Tabla HORARIOTUTOR
CREATE TABLE HorarioTutor (
    Id INT PRIMARY KEY ,
    Id_Tutor INT,
    Dia_semana NVARCHAR(20),
    Hora_Inicio TIME,
    Hora_Fin TIME,
    CONSTRAINT FK_HorarioTutor_Tutor FOREIGN KEY (Id_Tutor) REFERENCES Tutor(Id)
);

-- Tabla PAGOTUTOR
CREATE TABLE PagoTutor (
    Id INT PRIMARY KEY ,
    Id_Sesion INT,
    Id_Tutor INT,
    Comision_Administrador DECIMAL(10,2),
    Pago_Tutor DECIMAL(10,2),
    CONSTRAINT FK_PagoTutor_Sesion FOREIGN KEY (Id_Sesion) REFERENCES Sesion(Id),
    CONSTRAINT FK_PagoTutor_Tutor FOREIGN KEY (Id_Tutor) REFERENCES Tutor(Id)
);

-- Tabla ESTUDIANTE
CREATE TABLE Estudiante (
    Id INT PRIMARY KEY,
    Carrera NVARCHAR(100),
    Nombre NVARCHAR(100),
    CONSTRAINT FK_Estudiante_Usuario FOREIGN KEY (Id) REFERENCES Usuario(Id)
);

-- Tabla CONTABILIDAD
CREATE TABLE Contabilidad (
    Id INT PRIMARY KEY ,
    Id_PagoTutor INT,
    Id_Factura INT,
    Ingreso_Bruto DECIMAL(10,2),
    Pago_al_tutor DECIMAL(10,2),
    Ganancia DECIMAL(10,2),
    Fecha DATE,
    CONSTRAINT FK_Contabilidad_PagoTutor FOREIGN KEY (Id_PagoTutor) REFERENCES PagoTutor(Id),
    CONSTRAINT FK_Contabilidad_Factura FOREIGN KEY (Id_Factura) REFERENCES Factura(Id)
);

-- Tabla CONTRATACION
CREATE TABLE Contratacion (
    Id INT PRIMARY KEY ,
    Id_Tutor INT,
    Id_Administrador INT,
    Fecha_de_contratacion DATE,
    CONSTRAINT FK_Contratacion_Tutor FOREIGN KEY (Id_Tutor) REFERENCES Tutor(Id),
    CONSTRAINT FK_Contratacion_Usuario FOREIGN KEY (Id_Administrador) REFERENCES Usuario(Id)
);

INSERT INTO Rol (Nombre) VALUES ('Estudiante');
INSERT INTO Rol (Nombre) VALUES ('Tutor');
INSERT INTO Rol (Nombre) VALUES ('Administrador');

INSERT INTO Usuario (N1, N2, A1, A2, Email, Contraseña)
VALUES ('Juan', 'Carlos', 'Pérez', 'López', 'juan@example.com', 'password123');

INSERT INTO UsuarioRol (Id_usuario, Id_rol)
VALUES (1, 1);

SELECT * FROM Usuario;

SELECT * FROM UsuarioRol;

INSERT INTO Usuario (N1, N2, A1, A2, Email, Contraseña)
VALUES ('gerardo', 'Carlos', 'martinez', 'López', 'gerardo@example.com', 'password1234');

INSERT INTO UsuarioRol (Id_usuario, Id_rol)
VALUES (2, 3);

SELECT * FROM UsuarioRol;

INSERT INTO Usuario (N1, N2, A1, A2, Email, Contraseña)
VALUES ('Rroselin', 'Carlos', 'martinez', 'Ló', 'Rroselin@example.com', 'password12345');

INSERT INTO UsuarioRol (Id_usuario, Id_rol)
VALUES (2,1)

SELECT * FROM UsuarioRol;
