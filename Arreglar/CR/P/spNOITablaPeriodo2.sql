SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOITablaPeriodo2
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
set dateformat dmy
DELETE NOITablaPeriodo WHERE Estacion = @Estacion
INSERT NOITablaPeriodo (Estacion, Nomina,                                FechaD, FechaA)
SELECT  @Estacion, dbo.fnFormatearFecha(FechaA,'DDMMAA'), FechaD, FechaA
FROM NOINominaGenerada
WHERE Empresa = @Empresa
GROUP BY FechaD, FechaA
RETURN
END

