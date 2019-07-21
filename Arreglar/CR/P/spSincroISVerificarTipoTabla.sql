SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISVerificarTipoTabla
@Cambiar			bit = 0,
@EnSilencio			bit = 0

AS BEGIN
DECLARE
@SysTabla				varchar(50),
@Tipo					varchar(20),
@TipoMovimiento			int,
@TipoPropuesto			varchar(20)
DECLARE @TipoIncorrecto TABLE
(
Tabla					varchar(50),
TipoActual				varchar(20),
TipoPropuesto			varchar(20)
)
DECLARE crSysTabla CURSOR FOR
SELECT SysTabla, dbo.fnSincroISTablaTipo(SysTabla)
FROM SysTabla
OPEN crSysTabla
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @TipoMovimiento = dbo.fnTablaTipoMovimiento(@SysTabla)
IF @TipoMovimiento = 1
SELECT @TipoPropuesto = 'Movimiento'
ELSE IF @TipoMovimiento = 1
SELECT @TipoPropuesto = 'MovimientoInfo'
IF @TipoMovimiento IN (1,2) AND @Tipo NOT IN ('Movimiento','MovimientoInfo')
BEGIN
INSERT @TipoIncorrecto (Tabla, TipoActual, TipoPropuesto) VALUES (@SysTabla, @Tipo, @TipoPropuesto)
IF @Cambiar = 1 UPDATE SysTabla SET Tipo = @TipoPropuesto WHERE SysTabla = @SysTabla
END
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo
END
CLOSE crSysTabla
DEALLOCATE crSysTabla
IF @EnSilencio = 0 SELECT * FROM @TipoIncorrecto
END

