-- Este script contiene procedimientos adicionales que ayudan a la funcionalidad de la página web del proyecto. (MySQL)

DELIMITER $$

-- Buscar usuario por correo y contraseña
CREATE PROCEDURE BuscarUsuario (IN p_correo VARCHAR(255), IN p_contraseña VARCHAR(255))
BEGIN
    SELECT * FROM Usuario WHERE correo = p_correo AND contraseña = p_contraseña;
END$$

-- Obtener información del usuario
DROP PROCEDURE IF EXISTS GetUsuarioInfo$$
CREATE PROCEDURE GetUsuarioInfo(IN p_usuario VARCHAR(50))
BEGIN
    SELECT U.Nombre, P.puntos
    FROM Usuario U
    JOIN Progreso P ON U.progresoID = P.progID
    WHERE U.usuario = p_usuario;
END$$

-- Actualizar progreso del usuario
DROP PROCEDURE IF EXISTS ActualizarProgresoUsuario$$
CREATE PROCEDURE ActualizarProgresoUsuario(
    IN usuario_param VARCHAR(50),
    IN puntos_a_sumar INT,
    IN tiempo_juego_a_sumar INT,
    IN juegos_a_sumar INT
)
BEGIN
    -- Variables locales
    DECLARE nivel_actual INT;
    DECLARE puntos_actuales INT;
    DECLARE puntos_requeridos_siguiente_nivel INT;
    DECLARE highscore_actual INT;

    -- Actualizar puntos, tiempo de juego y cantidad de juegos
    UPDATE Progreso
    SET puntos = puntos + puntos_a_sumar,
        tiempoJuego = tiempoJuego + tiempo_juego_a_sumar,
        juegos = juegos + juegos_a_sumar
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);

    -- Obtener datos actuales del usuario
    SELECT nivelID INTO nivel_actual
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);

    SELECT puntos INTO puntos_actuales
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);

    SELECT puntosReq INTO puntos_requeridos_siguiente_nivel
    FROM Nivel
    WHERE nivelID = nivel_actual + 1;

    -- Verificar si se alcanzó un nuevo nivel
    IF puntos_actuales >= puntos_requeridos_siguiente_nivel THEN
        UPDATE Progreso
        SET nivelID = nivel_actual + 1
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);
    END IF;

    -- Actualizar highscore si aplica
    SELECT highScore INTO highscore_actual
    FROM Progreso
    WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);

    IF puntos_a_sumar > highscore_actual THEN
        UPDATE Progreso
        SET highScore = puntos_a_sumar
        WHERE progID = (SELECT progID FROM Usuario WHERE usuario = usuario_param);
    END IF;
END$$

-- Obtener todas las recompensas
CREATE PROCEDURE GetAllRewards()
BEGIN
    SELECT * FROM Recompensas;
END$$

-- Obtener clasificación por puntos
DROP PROCEDURE IF EXISTS GetClasificacionPuntos$$
CREATE PROCEDURE GetClasificacionPuntos()
BEGIN
    DECLARE ranking INT DEFAULT 0;

    DROP TEMPORARY TABLE IF EXISTS Clasificacion;
    CREATE TEMPORARY TABLE Clasificacion (
        posicion INT,
        usuario VARCHAR(50),
        puntos INT
    );

    INSERT INTO Clasificacion (posicion, usuario, puntos)
    SELECT @ranking := @ranking + 1 AS posicion, U.usuario, P.puntos
    FROM Usuario U
    JOIN Progreso P ON U.progresoID = P.progID
    CROSS JOIN (SELECT @ranking := 0) AS r
    ORDER BY P.puntos DESC;

    SELECT * FROM Clasificacion;
    DROP TEMPORARY TABLE IF EXISTS Clasificacion;
END$$

-- Obtener reporte de usuarios
DROP PROCEDURE IF EXISTS ObtenerReporteUsuarios$$
CREATE PROCEDURE ObtenerReporteUsuarios()
BEGIN
    SELECT U.usuario, U.correo, E.tiempoJuego, P.cursosCompletos, N.nombre AS nivel
    FROM Usuario U
    JOIN Estadísticas E ON U.usuario = E.usuario
    JOIN Progreso P ON U.progresoID = P.progID
    JOIN Nivel N ON P.nivelID = N.nivelID;
END$$

-- Obtener todos los cursos
CREATE PROCEDURE GetAllCourses()
BEGIN
    SELECT * FROM Cursos;
END$$

DELIMITER ;
