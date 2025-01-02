/*
El reto planteado implica el desarrollo integral de un proyecto para la empresa Neoris,
enfocado en enriquecer la experiencia de aprendizaje de sus empleados a través de la
gamificación.

El script presente crea las tablas y procedimientos necesarios como base para el proyecto 
planteado. Asimismo tiene algunos datos de prueba para comprobación de ejecuciones.
*/

USE master;
ALTER DATABASE Reto
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;


DROP DATABASE IF EXISTS Reto;
CREATE DATABASE Reto;
USE Reto;


-- =============================== Tablas ==============================
-- Creaci�n de la tabla Preferencias
CREATE TABLE Preferencias (
    prefID INT PRIMARY KEY,
    darkMode BIT,
    lenguaje VARCHAR(50),
    preferredIDE VARCHAR(50),
    screenResolution VARCHAR(20)
);

-- Creaci�n de la tabla Recompensas
CREATE TABLE Recompensas (
    nombre VARCHAR(100),
    recompID INT PRIMARY KEY,
    costoPuntos INT,
    c�digo VARCHAR(50)
);

-- Creaci�n de la tabla ElementosAvatar
CREATE TABLE ElementosAvatar (
    elem_avatarID INT PRIMARY KEY,
    nombre VARCHAR(100),
    parteCuerpo VARCHAR(50),
    costoPuntos INT
);

-- Creaci�n de la tabla Nivel
CREATE TABLE Nivel (
    nivelID INT PRIMARY KEY,
    nombre VARCHAR(100),
    puntosReq INT
);

-- Creaci�n de la tabla Progreso
CREATE TABLE Progreso (
    progID INT PRIMARY KEY,
    nivelID INT FOREIGN KEY REFERENCES Nivel(nivelID),
    cursosCompletos INT,
    puntos INT,
    tiempoJuego INT,
    highScore INT,
    streak INT,
    juegos INT
);

-- Creaci�n de la tabla Cursos
CREATE TABLE Cursos (
    cursoID INT PRIMARY KEY,
    nombre VARCHAR(100),
    tema VARCHAR(100),
    duracion FLOAT, 
    nivel_curso VARCHAR(50), 
    valorPuntos INT,
);

-- Creaci�n de la tabla Usuario
CREATE TABLE Usuario (
    usuario VARCHAR(50) PRIMARY KEY,
    contrase�a VARCHAR(50),
    correo VARCHAR(100),
    puesto VARCHAR(50),
    admin BIT,
    avatarID INT FOREIGN KEY REFERENCES ElementosAvatar(elem_avatarID),
    progresoID INT FOREIGN KEY REFERENCES Progreso(progID),
    recompensaID INT FOREIGN KEY REFERENCES Recompensas(recompID),
    elementosAvatarID INT FOREIGN KEY REFERENCES ElementosAvatar(elem_avatarID),
    preferenciasID INT FOREIGN KEY REFERENCES Preferencias(prefID),
    Nombre VARCHAR(100),
    FechaNacimiento DATE,
    sexo VARCHAR(10)
);

-- Creaci�n de la tabla Estad�sticas
CREATE TABLE Estad�sticas (
    usuario VARCHAR(50) FOREIGN KEY REFERENCES Usuario(usuario),
    nombre_usuario VARCHAR(100),
    tiempoJuego INT,
    nivelID INT FOREIGN KEY REFERENCES Nivel(nivelID),
    streak INT,
    highScore INT
);

-- Creaci�n de la tabla cursosAsignados
CREATE TABLE cursosAsignados (
    cursoID INT FOREIGN KEY REFERENCES Cursos(cursoID),
    progID INT FOREIGN KEY REFERENCES Progreso(progID),
    PRIMARY KEY (cursoID, progID),
	completo BIT
);


-- =============================== Inserciones ==============================
-- Insertar datos en la tabla Preferencias
INSERT INTO Preferencias (prefID, darkMode, lenguaje, preferredIDE, screenResolution) 
VALUES (1, 1, 'Espa�ol', 'Visual Studio Code', '1920x1080'),
       (2, 0, 'Ingl�s', 'Sublime Text', '2560x1440');

-- Insertar datos en la tabla Recompensas
INSERT INTO Recompensas (nombre, recompID, costoPuntos, c�digo) 
VALUES ('Camiseta exclusiva', 1, 500, 'CAMISETA001'),
       ('Suscripci�n mensual', 2, 1000, 'SUSCRIPCION001');

-- Insertar datos en la tabla ElementosAvatar
INSERT INTO ElementosAvatar (elem_avatarID, nombre, parteCuerpo, costoPuntos) 
VALUES (1, 'Sombrero de copa', 'Cabeza', 200),
       (2, 'Gafas de sol', 'Cara', 150);

-- Insertar datos en la tabla Nivel
INSERT INTO Nivel (nivelID, nombre, puntosReq) VALUES
(1, 'Principiante', 0),
(2, 'Novato', 50),
(3, 'Aprendiz', 100),
(4, 'Intermedio', 200),
(5, 'Avanzado', 350),
(6, 'Experto', 550),
(7, 'Maestro', 800),
(8, 'Gur�', 1100),
(9, 'Leyenda', 1500),
(10, 'M�ximo', 2000);

-- Insertar datos en la tabla Progreso
INSERT INTO Progreso (progID, nivelID, cursosCompletos, puntos, tiempoJuego, highScore, streak, juegos) 
VALUES (1, 1, 5, 1000, 3600, 500, 10, 20),
       (2, 2, 3, 800, 2700, 400, 8, 15),
	   (3, 3, 9, 1200, 4500, 20, 12, 25);

-- Insertar datos en la tabla Usuario
INSERT INTO Usuario (usuario, contrase�a, correo, puesto, admin, avatarID, progresoID, recompensaID, elementosAvatarID, preferenciasID, Nombre, FechaNacimiento, sexo) 
VALUES ('usuario1', 'contrase�a123', 'usuario1@example.com', 'Desarrollador', 1, 1, 1, 1, 1, 1, 'Juan P�rez', '1990-05-15', 'Masculino'),
       ('usuario2', 'password456', 'usuario2@example.com', 'Dise�ador', 0, 2, 2, 2, 2, 2, 'Mar�a Garc�a', '1988-10-20', 'Femenino'),
	   ('usuario3', 'password789', 'usuario3@example.com', 'Desarrollador', 0, 2, 3, 2, 2, 2, 'Ana L�pez', '1995-08-25', 'Femenino');

-- Insertar datos en la tabla Estad�sticas
INSERT INTO Estad�sticas (usuario, nombre_usuario, tiempoJuego, nivelID, streak, highScore) 
VALUES ('usuario1', 'Juan P�rez', 5000, 1, 15, 25),
       ('usuario2', 'Mar�a Garc�a', 3800, 2, 10, 15);

-- Insertar los cursos
INSERT INTO Cursos (cursoID, nombre, tema, duracion, nivel_curso, valorPuntos) VALUES
(1, 'Intro to ChatGPT and Generative AI', 'Prompt Engineering', 2.5, 'B�sico', 30),
(2, 'ChatGPT Complete Course - Prompt Engineering for ChatGPT', 'Prompt Engineering', 7.5, 'Intermedio', 75),
(3, 'ChatGPT Complete Guide: Learn Midjourney, ChatGPT 4 & More', 'Prompt Engineering', 26.5, 'Intermedio', 90),

(4, 'Introducci�n a GitHub Copilot', 'GitHub Copilot', 1.0, 'B�sico', 20),
(5, 'Aspectos b�sicos de la IA generativa', 'GitHub Copilot', 1.5, 'Intermedio', 25),

(6, 'Introducci�n a GitHub Advanced Security', 'GitHub Advanced Security', 1.5, 'B�sico', 25),
(7, 'Administraci�n de GitHub para GitHub Advanced Security', 'GitHub Advanced Security', 1.5, 'Intermedio/Avanzado', 35),

(8, 'AI Chatbots Development Exploring Generative AI with ChatGPT', 'GEN AI', 1.0, 'B�sico', 20),
(9, 'ChatGPT for Programmers: Build Python Apps in Seconds', 'GEN AI', 2.5, 'B�sico', 35),
(10, 'Generative AI & ChatGPT : Text, Image and Code completion', 'GEN AI', 3.5, 'Intermedio', 50),
(11, 'ChatGPT, Midjourney, DALL-E 3 & APIs - The Complete Guide', 'GEN AI', 17.0, 'Avanzado', 85),

(12, 'AI 101 fundamentals for managers & leaders (100% business)', 'GEN AI fundamentals', 2.0, 'B�sico', 30),
(13, 'Aspectos b�sicos de GitHub Copilot: descripci�n del programador de pares de inteligencia artificial', 'GEN AI fundamentals', 3.5, 'Intermedio', 50);

-- Insertar cursos asignados
INSERT INTO cursosAsignados (cursoID, progID, completo)
VALUES 
    (1, 1, 0),
	(3, 1, 0),
    (2, 2, 1),
	(1, 3, 1),
	(2, 3, 1),
	(3, 3, 1),
	(4, 3, 1),
	(5, 3, 1),
	(6, 3, 1),
	(7, 3, 1),
	(8, 3, 1),
	(9, 3, 1);





-- ================================ Stored Procedures =============================
DROP PROCEDURE ObtenerReporteUsuarios;
GO
CREATE PROCEDURE ObtenerReporteUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.usuario,
        U.correo,
        E.tiempoJuego,
        P.cursosCompletos,
        N.nombre AS nivel
    FROM 
        Usuario U
    INNER JOIN 
        Estad�sticas E ON U.usuario = E.usuario
    INNER JOIN 
        Progreso P ON U.progresoID = P.progID
    INNER JOIN 
        Nivel N ON P.nivelID = N.nivelID;
END;

EXEC ObtenerReporteUsuarios;




DROP PROCEDURE ActualizarProgresoUsuario;
GO
CREATE PROCEDURE ActualizarProgresoUsuario
    @usuario_param VARCHAR(50),
    @puntos_a_sumar INT,
    @tiempo_juego_a_sumar INT,
    @juegos_a_sumar INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar puntos, tiempo de juego y juegos
    UPDATE Progreso
    SET puntos = puntos + @puntos_a_sumar,
        tiempoJuego = tiempoJuego + @tiempo_juego_a_sumar,
        juegos = juegos + @juegos_a_sumar
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Verificar y actualizar nivel
    DECLARE @nivel_actual INT;
    DECLARE @puntos_actuales INT;
    DECLARE @puntos_requeridos_siguiente_nivel INT;

    -- Obtener el nivel actual del usuario
    SELECT @nivel_actual = nivelID
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Obtener los puntos actuales del usuario
    SELECT @puntos_actuales = puntos
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Obtener los puntos requeridos para el siguiente nivel
    SELECT @puntos_requeridos_siguiente_nivel = puntosReq
    FROM Nivel
    WHERE nivelID = @nivel_actual + 1;

    -- Verificar si el usuario alcanz� los puntos requeridos para el siguiente nivel
    IF @puntos_actuales >= @puntos_requeridos_siguiente_nivel
    BEGIN
        -- Actualizar el nivel del usuario en la tabla Progreso
        UPDATE Progreso
        SET nivelID = @nivel_actual + 1
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);
    END;

    -- Actualizar highscore
    DECLARE @highscore_actual INT;

    -- Obtener el highscore actual del usuario
    SELECT @highscore_actual = highScore
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Actualizar el highscore si el nuevo es mayor que el actual
    IF @puntos_a_sumar > @highscore_actual
    BEGIN
        UPDATE Progreso
        SET highScore = @puntos_a_sumar
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);
    END;
END;

EXEC ActualizarProgresoUsuario 'usuario1', 28, 1, 1;




DROP PROCEDURE ObtenerCursosAsignados;
GO
CREATE PROCEDURE ObtenerCursosAsignados
    @usuarioID VARCHAR(50)
AS
BEGIN
    SELECT DISTINCT c.*
    FROM cursosAsignados ca
    INNER JOIN Progreso p ON ca.progID = p.progID
    INNER JOIN Cursos c ON ca.cursoID = c.cursoID
    INNER JOIN Usuario u ON p.progID = u.progresoID
    WHERE u.usuario = @usuarioID;
END;

EXEC ObtenerCursosAsignados @usuarioID = 'usuario3';





DROP PROCEDURE ObtenerNumeroCursosCompletos;
GO
CREATE PROCEDURE ObtenerNumeroCursosCompletos
    @usuarioID VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NumeroCursosCompletos INT;

    -- Contar el n�mero de cursos completos para el usuario especificado
    SELECT @NumeroCursosCompletos = COUNT(*)
    FROM cursosAsignados ca
    WHERE ca.progID = (SELECT progresoID FROM Usuario WHERE usuario = @usuarioID)
    AND ca.completo = 1; -- Solo contar los cursos con el bit completo en true

    -- Devolver el resultado
    SELECT @NumeroCursosCompletos AS NumeroCursosCompletos;
END;

EXEC ObtenerNumeroCursosCompletos @usuarioID = 'usuario3';
SELECT * FROM cursosAsignados







/*
DROP PROCEDURE ActualizarHighScoreUsuario;
GO
CREATE PROCEDURE ActualizarHighScoreUsuario
    @usuario_param VARCHAR(50),
    @nuevo_highscore INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @highscore_actual INT;

    -- Obtener el highscore actual del usuario
    SELECT @highscore_actual = highScore
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Actualizar el highscore si el nuevo es mayor que el actual
    IF @nuevo_highscore > @highscore_actual
    BEGIN
        UPDATE Progreso
        SET highScore = @nuevo_highscore
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);
    END;
END;

EXEC ActualizarHighScoreUsuario @usuario_param = 'usuario1', @nuevo_highscore = 26;



DROP PROCEDURE VerificarActualizarNivel;
GO
CREATE PROCEDURE VerificarActualizarNivel(
    @usuario_param VARCHAR(50)
)
AS
BEGIN
    DECLARE @nivel_actual INT;
    DECLARE @puntos_actuales INT;
    DECLARE @puntos_requeridos_siguiente_nivel INT;

    -- Obtener el nivel actual del usuario
    SELECT @nivel_actual = nivelID
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Obtener los puntos actuales del usuario
    SELECT @puntos_actuales = puntos
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);

    -- Obtener los puntos requeridos para el siguiente nivel
    SELECT @puntos_requeridos_siguiente_nivel = puntosReq
    FROM Nivel
    WHERE nivelID = @nivel_actual + 1;

    -- Verificar si el usuario alcanz� los puntos requeridos para el siguiente nivel
    IF @puntos_actuales >= @puntos_requeridos_siguiente_nivel
    BEGIN
        -- Actualizar el nivel del usuario en la tabla Progreso
        UPDATE Progreso
        SET nivelID = @nivel_actual + 1
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = @usuario_param);
    END
END;

EXEC VerificarActualizarNivel 'usuario1';


*/