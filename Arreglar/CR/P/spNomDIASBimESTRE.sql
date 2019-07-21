SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spNomDIASBimESTRE
@Personal		VARCHAR(10),
@PeriodoTipo	VARCHAR(20),
@FechaD			DATETIME,
@FechaA			DATETIME

AS
BEGIN
DECLARE
@FechaNominaAl	DATETIME,
@FechaPLus		DATETIME
SELECT @FechaNominaAl = @FechaA
SELECT @FechaPLus = CASE WHEN @FechaNominaAl + 63 < @FechaD THEN @FechaNominaAl + 63
WHEN @FechaNominaAl + 56 < @FechaD THEN @FechaNominaAl + 56
WHEN @FechaNominaAl + 49 < @FechaD THEN @FechaNominaAl + 49
WHEN @FechaNominaAl + 42 < @FechaD THEN @FechaNominaAl + 42
WHEN @FechaNominaAl + 35 < @FechaD THEN @FechaNominaAl + 35
WHEN @FechaNominaAl + 28 < @FechaD THEN @FechaNominaAl + 28
WHEN @FechaNominaAl + 21 < @FechaD THEN @FechaNominaAl + 21
WHEN @FechaNominaAl + 14 < @FechaD THEN @FechaNominaAl + 14
WHEN @FechaNominaAl + 7 < @FechaD THEN @FechaNominaAl + 7
ELSE @FechaNominaAl END
BEGIN
SELECT @FechaPLus
END
END

