SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOITablaPeriodo
@Empresa       varchar(5),
@Estacion      int

AS BEGIN
DECLARE @BaseNOI        varchar (100),
@EmpresaNOI     varchar(2),
@TipoPeriodo    varchar(50),
@SQL            varchar(max),
@Fecha          datetime,
@FechaD         datetime,
@FechaA         datetime
DECLARE
@Tabla2 table (FechaD datetime, FechaA datetime)
set dateformat dmy
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @TipoPeriodo = TipoPeriodo
FROM InterfaseAspelNOI WHERE  Empresa = @Empresa
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL = 'IF  EXISTS (SELECT * FROM' + @BaseNOI + '.dbo.INTELISIS' + @EmpresaNOI +'
WHERE INTELISIS = 0)
SELECT FECH_NOM_INI,FECH_NOM_FIN
FROM ' + @BaseNOI + '.dbo.INTELISIS' + @EmpresaNOI +'
WHERE INTELISIS = 0'
INSERT @Tabla2 (FechaD,FechaA)
EXEC (@SQL)
IF EXISTS (SELECT * FROM NOITablaPeriodo WHERE Estacion = @Estacion)
DELETE NOITablaPeriodo WHERE Estacion = @Estacion
INSERT NOITablaPeriodo (Estacion, Nomina,                                FechaD, FechaA)
SELECT                 @Estacion, dbo.fnFormatearFecha(FechaA,'DDMMAA'), FechaD, FechaA
FROM @Tabla2
RETURN
END

