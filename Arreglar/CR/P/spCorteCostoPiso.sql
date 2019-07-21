SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCostoPiso
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaEmision	datetime,
@FechaCorte	datetime

AS BEGIN
DECLARE
@UltimoPagoCostoPiso	datetime,
@Concepto			varchar(50),
@VIN			varchar(20),
@Acreedor			varchar(10),
@Saldo			money,
@GastoMov			char(20),
@GastoID			int,
@Renglon			float,
@Moneda			char(10),
@TipoCambio			float,
@PorcentajeDeducible	float,
@PorcentajeImpuestos	float,
@Impuestos			money,
@Ok				int,
@OkRef			varchar(255),
@Mensaje			varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Renglon = 0.0
SELECT @GastoMov = Gasto FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @UltimoPagoCostoPiso = UltimoPagoCostoPiso,
@Concepto = ConceptoGastoCostoPiso,
@Acreedor = FordCliente
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
CREATE TABLE #CorteCostoPiso (
VIN 	varchar(20) 	COLLATE Database_Default NULL,
Saldo      money    	NULL)
SELECT @PorcentajeDeducible = PorcentajeDeducible, @PorcentajeImpuestos = Impuestos FROM Concepto WHERE Modulo = 'GAS' AND Concepto = @Concepto
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,    UltimoCambio, Acreedor,  Clase,   SubClase,   Condicion,   Prioridad, CostoPisoD, CostoPisoA)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'BORRADOR', GETDATE(),    @Acreedor, c.Clase, c.SubClase, p.Condicion, 'Normal',  @UltimoPagoCostoPiso, @FechaCorte
FROM Concepto c, Prov p
WHERE c.Modulo = 'GAS' AND c.Concepto = @Concepto AND p.Proveedor = @Acreedor
SELECT @GastoID = SCOPE_IDENTITY()
DECLARE crCorteCostoPiso CURSOR FOR
SELECT VIN
FROM VIN
WHERE TipoUnidad = 'Nuevo' AND (UltimoPagoCostoPiso IS NULL OR UltimoPagoCostoPiso = @UltimoPagoCostoPiso)
OPEN crCorteCostoPiso
FETCH NEXT FROM crCorteCostoPiso INTO @VIN
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spVerCostoPiso @Empresa, @VIN, 0, 1, @FechaCorte, @Saldo OUTPUT
IF NULLIF(@Saldo, 0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @Saldo = ROUND(@Saldo, 2)
SELECT @Impuestos = @Saldo * (@PorcentajeImpuestos / 100)
INSERT GastoD (ID,       Renglon,  Concepto,  Fecha,       Referencia,  Cantidad,  Precio, Importe, Impuestos,  Sucursal,  PorcentajeDeducible,  VIN)
VALUES (@GastoID, @Renglon, @Concepto, @FechaCorte, @VIN,        1,         @Saldo, @Saldo,  @Impuestos, @Sucursal, @PorcentajeDeducible, @VIN)
END
END
FETCH NEXT FROM crCorteCostoPiso INTO @VIN
END
CLOSE crCorteCostoPiso
DEALLOCATE crCorteCostoPiso
IF @Ok IS NULL
SELECT @Mensaje = 'Gasto Generado con Exito. (Borrador)'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

