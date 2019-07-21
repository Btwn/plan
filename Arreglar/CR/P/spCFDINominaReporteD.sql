SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaReporteD
@ID				int,
@Personal		varchar(20),
@Movimiento		varchar(20)

AS
BEGIN
DECLARE @Cadena	varchar(max),
@RID		int,
@RIDAnt	int
SELECT @Cadena = ''
CREATE TABLE #Cadena(RID  int IDENTITY, Cadena varchar(max)	NULL)
IF @Movimiento IN('Percepcion')
BEGIN
INSERT INTO #Cadena(Cadena)
SELECT dbo.fnRellenarEspaciosDerecha(TipoSAT, 6)+
dbo.fnRellenarEspaciosDerecha(SUBSTRING(Concepto, 1, 30), 30)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(ImporteExcento, 0)), 1), 16)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(ImporteGravado, 0)), 1), 16)
FROM CFDINominaPercepcionDeduccion
WHERE ID = @ID
AND Personal = @Personal
AND Movimiento = @Movimiento
END
IF @Movimiento IN('Deduccion')
BEGIN
INSERT INTO #Cadena(Cadena)
SELECT dbo.fnRellenarEspaciosDerecha(TipoSAT, 6)+
dbo.fnRellenarEspaciosDerecha(SUBSTRING(Concepto, 1, 30), 32)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(ImporteExcento, 0)), 1), 19)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(ImporteGravado, 0)), 1), 15)
FROM CFDINominaPercepcionDeduccion
WHERE ID = @ID
AND Personal = @Personal
AND Movimiento = @Movimiento
END
ELSE IF @Movimiento IN('HorasExtra')
BEGIN
INSERT INTO #Cadena(Cadena)
SELECT dbo.fnRellenarEspaciosDerecha(Dias, 6)+
dbo.fnRellenarEspaciosDerecha(HorasExtra, 7)+
dbo.fnRellenarEspaciosDerecha(SUBSTRING(TipoHoras, 1, 25), 34)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(ImportePagado, 0)), 1), 14)
FROM CFDINominaHoraExtra
WHERE ID = @ID
AND Personal = @Personal
END
ELSE IF @Movimiento IN('Incapacidad')
BEGIN
INSERT INTO #Cadena(Cadena)
SELECT dbo.fnRellenarEspaciosDerecha(TipoIncapacidad, 6)+
dbo.fnRellenarEspaciosDerecha(Dias, 45)+
'$' + dbo.fnRellenarEspaciosDerecha(CONVERT(varchar, CONVERT(money, ISNULL(Descuento, 0)), 1), 14)
FROM CFDINominaIncapacidad
WHERE ID = @ID
AND Personal = @Personal
END
SELECT @RIDAnt = ''
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM #Cadena
WHERE RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Cadena = @Cadena+ISNULL(Cadena, '') + CHAR(13) FROM #Cadena WHERE RID = @RID
END
SELECT @Cadena
END

