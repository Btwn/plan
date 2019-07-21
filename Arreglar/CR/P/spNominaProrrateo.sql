SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaProrrateo
@ID	                    int,
@Ok                     int             OUTPUT,
@OkRef                  varchar(255)    OUTPUT

AS BEGIN
DECLARE
@Empresa                varchar(5),
@Sucursal               int,
@Concepto               varchar(50),
@CentroCostos           varchar(50),
@Importe                money,
@GenerarID              int,
@GenerarMov             varchar(20),
@GenerarMovID           varchar(20),
@Mov                    varchar(20),
@MovID                  varchar(20),
@Usuario                varchar(10),
@FechaEmision           datetime,
@UltimoCambio           datetime,
@Moneda                 varchar(10),
@TipoCambio             float,
@Renglon                float,
@PorcentajeDeducible    float,
@Proveedor              varchar(20),
@GastoID                int
DELETE FROM NominaProrrateoLog WHERE ID = @ID
SELECT @Mov = Mov, @MovID = MovID, @Usuario = Usuario, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaEmision = FechaEmision FROM Nomina WHERE ID = @ID
SELECT @UltimoCambio = GETDATE()
SELECT nd.ID, nd.Movimiento, ec.Proveedor, ecd.ConceptoGasto, ecd.Concepto, p.Personal, p.ApellidoPaterno + ' ' + p.ApellidoMaterno + ' ' + p.Nombre AS Nombre,
ep.CentroCostos, ep.Empresa, ep.Sucursal, ep.Porcentaje, nd.Importe * (ep.Porcentaje / 100) * CASE WHEN Movimiento = 'Deduccion' THEN -1 ELSE 1 END AS ImporteProrrateo
INTO #ProrrateoNomina
FROM NominaProrrateoConcepto ec
JOIN NominaProrrateoConceptoD ecd ON ec.ConceptoGasto = ecd.ConceptoGasto
JOIN NominaD nd ON ecd.Concepto = nd.Concepto
JOIN Personal p ON nd.Personal = p.Personal
JOIN NominaProrrateoD ep ON p.NominaProrrateo = ep.Prorrateo
WHERE nd.ID = @ID
ORDER BY nd.Renglon
INSERT NominaProrrateoLog(ID, Concepto, Personal, Nombre, CentroCostos, Empresa, Sucursal, Porcentaje, Importe, Proveedor)
SELECT ID, ConceptoGasto, Personal, Nombre, CentroCostos, Empresa, Sucursal, Porcentaje, SUM(ImporteProrrateo), Proveedor
FROM #ProrrateoNomina
GROUP BY ID, ConceptoGasto, Personal, Nombre, CentroCostos, Empresa, Sucursal, Porcentaje, Proveedor
DECLARE crProrrateo CURSOR FOR
SELECT DISTINCT Empresa, Sucursal, Proveedor FROM NominaProrrateoLog WHERE ID = @ID
OPEN crProrrateo
FETCH NEXT FROM crProrrateo INTO @Empresa, @Sucursal, @Proveedor
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @GenerarID = NULL, @GastoID = NULL, @GenerarMovID = NULL
INSERT Gasto(Empresa,  Mov ,     FechaEmision,  UltimoCambio,  Moneda,  TipoCambio,  Usuario, Estatus,      OrigenTipo, Origen, OrigenID, FechaRegistro,  Sucursal, Acreedor)
SELECT @Empresa, 'Nomina', @FechaEmision, @UltimoCambio, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', 'NOM',  @Mov,       @MovID,   @UltimoCambio, @Sucursal, @Proveedor
SELECT @GenerarID = SCOPE_IDENTITY()
DECLARE crProrrateoD CURSOR FOR
SELECT Concepto, CentroCostos, Importe
FROM NominaProrrateoLog
WHERE ID = @ID
AND Empresa = @Empresa
AND Sucursal = @Sucursal
AND Proveedor = @Proveedor
OPEN crProrrateoD
FETCH NEXT FROM crProrrateoD INTO @Concepto, @CentroCostos, @Importe
WHILE @@FETCH_STATUS = 0 AND @GenerarID IS NOT NULL
BEGIN
SELECT @Renglon = ISNULL(@Renglon, 0) + 2048
SELECT @PorcentajeDeducible = PorcentajeDeducible FROM Concepto WHERE Modulo = 'GAS' AND Concepto = @Concepto
INSERT GastoD(ID,          Renglon, RenglonSub, Concepto, Cantidad, Precio,   Importe,  ContUso,       PorcentajeDeducible)
VALUES(@GenerarID, @Renglon, 0,         @Concepto, 1,       @Importe, @Importe, @CentroCostos, @PorcentajeDeducible)
FETCH NEXT FROM crProrrateoD INTO @Concepto, @CentroCostos, @Importe
END
CLOSE crProrrateoD
DEALLOCATE crProrrateoD
IF EXISTS(SELECT * FROM GastoD WHERE ID = @ID)
BEGIN
EXEC spGasto @GenerarID, 'GAS', 'AFECTAR', 'TODO', @UltimoCambio, NULL, @Usuario, 1, 0, 'Nomina', @GenerarMovID OUTPUT, @GastoID, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'NOM', @ID, @Mov, @MovID, 'GAS', @GenerarID, 'Nomina', @GenerarMovID, @Ok OUTPUT
END
END
FETCH NEXT FROM crProrrateo INTO @Empresa, @Sucursal, @Proveedor
END
CLOSE crProrrateo
DEALLOCATE crProrrateo
RETURN
END

