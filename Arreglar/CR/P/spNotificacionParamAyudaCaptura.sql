SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionParamAyudaCaptura
@Notificacion		varchar(50),
@Parametro			varchar(100)

AS BEGIN
DECLARE
@Clave					varchar(50),
@Tipo						varchar(20)
SELECT @Clave = Clave FROM Notificacion WHERE Notificacion = @Notificacion
SET @Parametro = RTRIM(@Parametro)
SELECT @Tipo = RTRIM(ISNULL(Tipo,'')) FROM NotificacionClaveParam WHERE Clave = @Clave AND Parametro = @Parametro
IF @Tipo = 'TEXTO'
BEGIN
SELECT CONVERT(varchar(255),'')
UNION ALL
SELECT RTRIM(ISNULL(Valor,''))
FROM NotificacionClaveParamAyuda
WHERE Clave = @Clave
AND Parametro = @Parametro
END ELSE
IF @Tipo = 'NUMERO'
BEGIN
SELECT CONVERT(varchar(255),'')
END ELSE
IF @Tipo = 'FECHA'
BEGIN
SELECT CONVERT(varchar(255),'')
END ELSE
IF @Tipo = 'LOGICO'
BEGIN
SELECT CONVERT(varchar(255),'0')
UNION ALL
SELECT CONVERT(varchar(255),'1')
END
END

