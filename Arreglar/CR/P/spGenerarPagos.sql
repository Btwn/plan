SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarPagos
@Estacion		int,
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Mov		char(20),
@Vencimiento	datetime

AS BEGIN
DECLARE
@Afectar		bit,
@Moneda			char(10),
@MonedaAnt		char(10),
@TipoCambio		float,
@Conteo			int,
@ID				int,
@Proveedor		char(10),
@FechaEmision	datetime
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Afectar = ISNULL(CxpAfectarPagosAutomaticos, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @Conteo = 0
DECLARE crLista CURSOR FOR
SELECT NULLIF(RTRIM(Clave), '')
FROM ListaSt
WHERE Estacion = @Estacion
OPEN crLista
FETCH NEXT FROM crLista INTO @Proveedor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @MonedaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Moneda = MIN(Moneda)
FROM Mon
WHERE Moneda > @MonedaAnt
IF @Moneda IS NULL BREAK
SELECT @MonedaAnt = @Moneda
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT Cxp (Sucursal,  Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Proveedor,  ProveedorMoneda, ProveedorTipoCambio)
VALUES (@Sucursal, @Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR',  @Proveedor, @Moneda,         @TipoCambio)
SELECT @ID = SCOPE_IDENTITY()
EXEC spSugerirPago @ID, @Empresa, @Moneda, @Proveedor, @Vencimiento
IF EXISTS(SELECT * FROM CxpD WHERE ID = @ID)
BEGIN
IF @Afectar = 1 EXEC spAfectar 'CXP', @ID, @EnSilencio = 1
SELECT @Conteo = @Conteo + 1
END ELSE
DELETE Cxp WHERE ID = @ID
END
END
FETCH NEXT FROM crLista INTO @Proveedor
END 
CLOSE crLista
DEALLOCATE crLista
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' '+RTRIM(@Mov)+'(s)'
END

