SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoCopiarDetalle
@Sucursal			int,
@ID                		int,
@IDGenerar          		int,
@MovTipo			char(20),
@GenerarMovTipo		char(20),
@CfgGastoCopiarImporte	bit,
@CfgGastoSolicitudAnticipoImpuesto bit,
@Ok                		int OUTPUT

AS BEGIN
SELECT * INTO #GastoDetalle FROM cGastoD WITH (NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
UPDATE #GastoDetalle SET Sucursal = @Sucursal, ID = @IDGenerar
IF @@ERROR <> 0 SELECT @Ok = 1
IF @MovTipo = 'GAS.P'
UPDATE #GastoDetalle SET Provision = Importe
ELSE
UPDATE #GastoDetalle SET Provision = NULL
IF @GenerarMovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP', 'GAS.DG', 'GAS.DC', 'GAS.DGP', 'GAS.OI', 'GAS.CB', 'GAS.AB')
BEGIN
IF @CfgGastoCopiarImporte = 1
BEGIN
IF @CfgGastoSolicitudAnticipoImpuesto = 0
UPDATE #GastoDetalle
SET Precio    = d.Precio/(1+ISNULL(c.Impuestos/100.0, 0.0)),
Importe   = d.Importe/(1+ISNULL(c.Impuestos/100.0, 0.0)),
Impuestos = (d.Importe/(1+ISNULL(c.Impuestos/100.0, 0.0)))*ISNULL(c.Impuestos/100.0, 0.0)
FROM #GastoDetalle d, Concepto c  WITH (NOLOCK)
WHERE d.ID = @IDGenerar AND c.Modulo = 'GAS' AND c.Concepto = d.Concepto
END ELSE
UPDATE #GastoDetalle SET Cantidad = NULL, Precio = NULL, Importe = NULL, Retencion = NULL, Retencion2 = NULL, Retencion3 = NULL, Impuestos = NULL
IF @@ERROR <> 0 SELECT @Ok = 1
END
INSERT INTO cGastoD SELECT * FROM #GastoDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
RETURN
END

