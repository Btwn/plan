SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirProvision
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaEmision	datetime

AS BEGIN
DECLARE
@Concepto			varchar(50),
@Acreedor			char(10),
@ProvisionTolerancia	float,
@ProvisionImporte		money,
@Acumulado			money,
@Saldo			money,
@GastoMov			char(20),
@GastoID			int,
@Renglon			float,
@Moneda			char(10),
@TipoCambio			float,
@PorcentajeDeducible	float,
@PorcentajeImpuestos	float,
@Impuestos			money,
@Conteo			int,
@Ok				int,
@OkRef			varchar(255),
@Mensaje			varchar(255)
BEGIN TRANSACTION
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
SELECT @GastoMov = GastoProvision
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @ProvisionTolerancia = ISNULL(GastoProvisionTolerancia, 0.0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE crConceptoGAS CURSOR FOR
SELECT Concepto, ProvisionImporte, Impuestos, PorcentajeDeducible
FROM Concepto
WHERE Modulo = 'GAS' AND Provisionable = 1 AND NULLIF(ProvisionImporte, 0.0) IS NOT NULL
OPEN crConceptoGAS
FETCH NEXT FROM crConceptoGAS INTO @Concepto, @ProvisionImporte, @PorcentajeImpuestos, @PorcentajeDeducible
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Acumulado = ISNULL(SUM(d.Importe*e.TipoCambio), 0.0)-ISNULL(SUM(d.Provision*e.TipoCambio), 0.0)
FROM Gasto e, GastoD d, MovTipo mt
WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.Ejercicio = YEAR(@FechaEmision) AND e.Periodo = MONTH(@FechaEmision)
AND d.Concepto = @Concepto
AND mt.Modulo = 'GAS' AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.CCH')
IF @Acumulado < (@ProvisionImporte*(1-(@ProvisionTolerancia/100)))
BEGIN
SELECT @Acreedor = NULL
SELECT @Acreedor = MIN(Acreedor) FROM ConceptoAcreedor WHERE Modulo = 'GAS' AND Concepto = @Concepto AND porOmision = 1
IF @Acreedor IS NULL
SELECT @Acreedor = MIN(Acreedor) FROM ConceptoAcreedor WHERE Modulo = 'GAS' AND Concepto = @Concepto
IF @Acreedor IS NULL SELECT @Ok = 30670, @OkRef = @Concepto
IF @Ok IS NULL
BEGIN
SELECT @Conteo = @Conteo + 1
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,    UltimoCambio, Acreedor,  Clase,   SubClase,   Condicion,   Prioridad)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'BORRADOR', GETDATE(),    @Acreedor, c.Clase, c.SubClase, p.Condicion, 'Normal'
FROM Concepto c, Prov p
WHERE c.Modulo = 'GAS' AND c.Concepto = @Concepto AND p.Proveedor = @Acreedor
SELECT @GastoID = SCOPE_IDENTITY()
SELECT @Saldo = @ProvisionImporte - @Acumulado
SELECT @Impuestos = @Saldo * (@PorcentajeImpuestos / 100)
INSERT GastoD (ID,       Renglon, Concepto,  Fecha,         Cantidad,  Precio, Importe, Impuestos,  Sucursal,  PorcentajeDeducible)
VALUES (@GastoID, 2048.0,  @Concepto, @FechaEmision, 1,         @Saldo, @Saldo,  @Impuestos, @Sucursal, @PorcentajeDeducible)
END
END
END
FETCH NEXT FROM crConceptoGAS INTO @Concepto, @ProvisionImporte, @PorcentajeImpuestos, @PorcentajeDeducible
END
CLOSE crConceptoGAS
DEALLOCATE crConceptoGAS
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = CONVERT(varchar, @Conteo)+' Provision(es) Generadas con Exito. (Borrador)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
END
SELECT @Mensaje
RETURN
END

