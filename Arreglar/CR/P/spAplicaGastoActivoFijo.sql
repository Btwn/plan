SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spAplicaGastoActivoFijo
@Empresa  varchar(5),
@Modulo   varchar(20),
@IDMov    int

AS
BEGIN
DECLARE
@FechaEmision              datetime,
@cID                       int,
@cRenglon                  Float,
@cArticulo                 varchar(20),
@cSerie                    varchar(20),
@cFechaInicioDepreciacion  datetime
DECLARE cActivoFijo CURSOR FOR
SELECT ID, Renglon, Articulo, Serie, FechaInicioDepreciacion
FROM AuxiliarActivoFijo
WHERE IDMov = @IDMov
AND Empresa = @Empresa
AND Modulo = @Modulo
OPEN cActivoFijo
FETCH NEXT FROM cActivoFijo INTO @cID, @cRenglon, @cArticulo, @cSerie, @cFechaInicioDepreciacion
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'GAS'
SELECT @FechaEmision = FechaEmision FROM Gasto WHERE ID = @IDMov
IF @Modulo = 'COMS'
SELECT @FechaEmision = FechaEmision FROM Compra WHERE ID = @IDMov
IF @FechaEmision <= ISNULL(@cFechaInicioDepreciacion,@FechaEmision) OR @Modulo = 'COMS'
BEGIN
UPDATE AuxiliarActivoFijo SET Aplicar = 1, Icono = 339
WHERE ID = @cID
AND IDMov = @IDMov
AND Renglon = @cRenglon
AND Empresa = @Empresa
AND Modulo = @Modulo
AND Articulo = @cArticulo
AND Serie = @cSerie
END
IF @FechaEmision > @cFechaInicioDepreciacion AND @Modulo <> 'COMS'
BEGIN
UPDATE AuxiliarActivoFijo SET Icono = 522
WHERE ID = @cID
AND IDMov = @IDMov
AND Renglon = @cRenglon
AND Empresa = @Empresa
AND Modulo = @Modulo
AND Articulo = @cArticulo
AND Serie = @cSerie
END
FETCH NEXT FROM cActivoFijo INTO @cID, @cRenglon, @cArticulo, @cSerie, @cFechaInicioDepreciacion
END
CLOSE cActivoFijo
DEALLOCATE cActivoFijo
END

