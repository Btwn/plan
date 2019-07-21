SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_init
@log_id		int,
@empresa	varchar(5),
@ejercicio	smallint,
@periodo	smallint,
@tipo		varchar(50),
@FechaD		datetime	= NULL,
@FechaA		datetime	= NULL

AS BEGIN
IF @tipo IN ('todo', 'flujo')
BEGIN
DELETE
FROM documentos
WHERE empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, ejercicio)
AND periodo = ISNULL(@periodo, periodo)
AND fecha >= ISNULL(@FechaD, fecha)
AND fecha <= ISNULL(@FechaA, fecha)
AND origen_tipo = 'calc'
DELETE
FROM DatosIetu
WHERE empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, ejercicio)
AND periodoasi = ISNULL(@periodo, periodoasi)
AND fecha >= ISNULL(@FechaD, fecha)
AND fecha <= ISNULL(@FechaA, fecha)
DELETE
FROM ximpiva
WHERE empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, ejercicio)
AND periodo = ISNULL(@periodo, periodo)
AND fecha >= ISNULL(@FechaD, fecha)
AND fecha <= ISNULL(@FechaA, fecha)
DELETE
FROM DatosIeps
WHERE empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, ejercicio)
AND periodo = ISNULL(@periodo, periodo)
AND fecha >= ISNULL(@FechaD, fecha)
AND fecha <= ISNULL(@FechaA, fecha)
END
IF @tipo IN ('todo', 'contabilidad')
BEGIN
DELETE
FROM MovContables
WHERE empresa = @empresa
AND anio  = ISNULL(@ejercicio, YEAR(@FechaA))
AND mes	 = ISNULL(@periodo, MONTH(@FechaA))
DELETE
FROM CuentasContables
DELETE
FROM SaldosIni
WHERE Empresa = @empresa AND anio = ISNULL(@ejercicio, YEAR(@FechaD))
END
END

