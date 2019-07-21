SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionTagAyuda (@Notificacion varchar(55))
RETURNS @Resultado
TABLE (Notificacion varchar(55), Tag varchar(100), Asunto bit NULL, Mensaje bit NULL, Consulta bit NULL, Condicion bit NULL, Descripcion varchar(100) NULL)

AS BEGIN
INSERT INTO @Resultado(
Notificacion,  Tag, Asunto, Mensaje, Consulta, Condicion, Descripcion)
SELECT @Notificacion, Tag, Asunto, Mensaje, Consulta, Condicion, Descripcion
FROM NotificacionTagAyuda
UNION ALL
SELECT Notificacion, '<' + ConsultaNombre + '>', NULL, NULL, NULL, NULL, NULL
FROM NotificacionConsulta
WHERE Notificacion = @Notificacion
RETURN
END

