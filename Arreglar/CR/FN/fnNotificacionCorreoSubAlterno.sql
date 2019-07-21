SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionCorreoSubAlterno
(
@Usuario					varchar(10)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@ListaCorreos			varchar(max),
@Correo				varchar(255),
@Personal				varchar(10)
SELECT @Personal = Personal FROM Usuario WHERE Usuario = @Usuario
SET @ListaCorreos = ''
IF NULLIF(@Personal,'') IS NOT NULL
BEGIN
DECLARE crPersonal CURSOR FOR
SELECT ISNULL(ISNULL(NULLIF(p.Email,''),NULLIF(u.Email,'')),'')
FROM Personal p LEFT OUTER JOIN Usuario u
ON u.Personal = p.Personal
WHERE ReportaA = @Personal
AND p.Estatus NOT IN('BAJA')
OPEN crPersonal
FETCH NEXT FROM crPersonal INTO @Correo
WHILE @@FETCH_STATUS = 0
BEGIN
IF NULLIF(@ListaCorreos,'') IS NOT NULL AND NULLIF(@Correo,'') IS NOT NULL SELECT @ListaCorreos = @ListaCorreos + ',' + @Correo ELSE
IF NULLIF(@ListaCorreos,'') IS NULL AND NULLIF(@Correo,'') IS NOT NULL SELECT @ListaCorreos = @ListaCorreos + @Correo
FETCH NEXT FROM crPersonal INTO @Correo
END
CLOSE crPersonal
DEALLOCATE crPersonal
END
RETURN (@ListaCorreos)
END

