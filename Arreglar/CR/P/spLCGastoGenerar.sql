SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLCGastoGenerar
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Modulo			char(5),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@Moneda			varchar(10),
@TipoCambio		float,
@ImporteTotal		money,
@LineaCredito		varchar(20),
@Acreedor		varchar(10),
@Ok             	int          = NULL OUTPUT,
@OkRef          	varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@GastoID	int,
@GastoMov	varchar(20),
@GastoMovID	varchar(20),
@Condicion	varchar(50),
@Renglon	float,
@Concepto	varchar(50),
@Porcentaje	float,
@Importe	money,
@Impuestos	float,
@Referencia	varchar(50)
SELECT @GastoMov = ACGasto FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Acreedor IS NULL SELECT @Ok = 40020
SELECT @Condicion = Condicion FROM Prov WHERE Proveedor = @Acreedor
INSERT Gasto (Sucursal,  Empresa,  Mov,       FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      UltimoCambio, Acreedor,  Condicion,  OrigenTipo, Origen, OrigenID, Prioridad)
VALUES (@Sucursal, @Empresa, @GastoMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @Acreedor, @Condicion, @Modulo,    @Mov,   @MovID,   'Normal')
SELECT @GastoID = SCOPE_IDENTITY()
SELECT @Renglon    = 0.0,
@Referencia = @Mov+' '+@MovID
DECLARE crLCGasto CURSOR LOCAL FOR
SELECT g.Concepto, NULLIF(g.Importe, 0.0), NULLIF(g.Porcentaje, 0.0), c.Impuestos
FROM LCGasto g
LEFT OUTER JOIN Concepto c ON c.Concepto = g.Concepto AND c.Modulo = 'GAS'
WHERE g.LineaCredito = @LineaCredito
OPEN crLCGasto
FETCH NEXT FROM crLCGasto INTO @Concepto, @Importe, @Porcentaje, @Impuestos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0
IF @Porcentaje IS NOT NULL SELECT @Importe = @ImporteTotal * (@Porcentaje/100.0)
INSERT GastoD (
ID,       Sucursal,  Renglon,  Concepto,  Fecha,         Referencia,  Cantidad,  Precio,   Importe,  Impuestos )
SELECT @GastoID, @Sucursal, @Renglon, @Concepto, @FechaEmision, @Referencia, 1,         @Importe, @Importe, @Importe*(@Impuestos/100.0)
END
FETCH NEXT FROM crLCGasto INTO @Concepto, @Importe, @Porcentaje, @Impuestos
END
CLOSE crLCGasto
DEALLOCATE crLCGasto
IF EXISTS(SELECT * FROM GastoD WHERE ID = @GastoID)
BEGIN
EXEC spAfectar 'GAS', @GastoID, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
SELECT @GastoMovID = MovID FROM Gasto WHERE ID = @GastoID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'GAS', @GastoID, @GastoMov, @GastoMovID, @Ok OUTPUT
END ELSE
DELETE Gasto WHERE ID = @GastoID
RETURN
END

