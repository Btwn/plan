SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISOk
@Conversacion		uniqueidentifier,
@TipoMensaje		varchar(255),
@Datos				xml,
@DatosRef			varchar(max),
@SQL_ERROR_NUMBER	int,
@SQL_ERROR_MESSAGE	varchar(255),
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Dias	int
IF @Conversacion IS NULL RETURN
IF @SQL_ERROR_NUMBER <> 0
SELECT @Ok = 1, @OkRef = ISNULL(@SQL_ERROR_MESSAGE, '')+' ['+CONVERT(varchar, @SQL_ERROR_NUMBER)+']'
IF @Ok IS NOT NULL
BEGIN
SELECT @Dias = ISNULL(SincroSBBOkConservar, 1)
FROM Version
DELETE SincroISOk WHERE Fecha < DATEADD(day, -@Dias, GETDATE())
IF NOT EXISTS(SELECT Conversacion FROM SincroISOk WHERE Conversacion = @Conversacion)
INSERT SincroISOk (
Conversacion,  TipoMensaje,  Datos,  DatosRef,  Ok,  OkRef)
VALUES (@Conversacion, @TipoMensaje, @Datos, @DatosRef, @Ok, @OkRef)
END
RETURN
END

