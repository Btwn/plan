SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAplicarAnticiposTipoServicio
@Estacion		int,
@ID			Varchar(50)

AS
BEGIN
DECLARE
@Transaccion					varchar(50),
@Ok								int,
@OkRef							varchar(255),
@Empresa						varchar(5),
@Cliente						varchar(10),
@CfgAnticipoTipoServicio		bit,
@CfgAnticipoArticuloServicio	varchar(20),
@CfgMultiUnidades				bit,
@CfgVentaFactorDinamico			bit,
@MovMoneda						varchar(10),
@MovTipoCambio					float,
@Moneda							varchar(10),
@TipoCambio						float,
@Importe						float,
@Impuestos						float,
@Retencion						float,
@PorcentajeImpuesto				float,
@PorcentajeRetencion			float,
@AnticipoAplicar				float,
@AnticipoSaldo					float,
@MovAnticipoAplicarSImp      	float,
@MovAnticipoAplicarCimp			float,
@Renglon						float,
@RenglonID						int,
@Almacen						varchar(10),
@Unidad							varchar(50),
@Sucursal						int,
@AsignoAnticipo					bit,
@PreciosIVAIncluido				bit,
@CantidadInventario				float,
@UnidadFactor					float
SELECT @Ok = NULL, @OkRef = NULL
SELECT
@Empresa = Empresa,
@Cliente = Cliente,
@MovMoneda  = Moneda,
@MovTipoCambio = TipoCambio,
@Almacen = Almacen,
@Sucursal = Sucursal
FROM POSL
WHERE ID = @ID
SELECT @PreciosIVAIncluido = VentaPreciosImpuestoIncluido
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT
@CfgAnticipoTipoServicio     = ISNULL(CxcAnticipoTipoServicio,0),
@CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,''),
@CfgMultiUnidades            = ISNULL(MultiUnidades,0),
@CfgVentaFactorDinamico      = ISNULL(VentaFactorDinamico,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgAnticipoArticuloServicio IS NULL
SELECT @Ok = 10490, @OkRef = @Empresa
SELECT @Unidad = Unidad
FROM Art
WHERE Articulo = @CfgAnticipoArticuloServicio
IF @CfgAnticipoTipoServicio = 1 AND @Ok IS NULL
BEGIN
SELECT @Renglon = ISNULL(MAX(ISNULL(Renglon,0.0)),0.0) + 2048.0
FROM POSLVenta
WHERE ID = @ID
SELECT @RenglonID = ISNULL(MAX(ISNULL(RenglonID,0)),0.0) + 1
FROM POSLVenta
WHERE ID = @ID
SET @AsignoAnticipo = 0
DECLARE crAnticiposFacturados CURSOR FOR
SELECT
Moneda,
ISNULL(TipoCambio,0.0),
SUM(ISNULL(Importe,0.0)),
SUM(ISNULL(Impuestos,0.0)),
SUM(ISNULL(Retencion,0.0)),
(ISNULL(Impuestos,0.0)/ISNULL(Importe,0.0))*100.0,
(ISNULL(Retencion,0.0)/ISNULL(Importe,0.0))*100.0,
SUM(ISNULL(AnticipoAplicar,0.0)),
SUM(ISNULL(AnticipoSaldo,0.0))
FROM POSCxcAnticipoTemp
WHERE AnticipoSaldo > 0.0
AND Cliente = @Cliente
AND ISNULL(AnticipoAplicar,0.0) > 0.0
AND Estacion = @Estacion
GROUP BY Moneda, ISNULL(TipoCambio,0.0), (ISNULL(Impuestos,0.0)/ISNULL(Importe,0.0))*100.0, (ISNULL(Retencion,0.0)/ISNULL(Importe,0.0))*100.0
OPEN crAnticiposFacturados
FETCH NEXT FROM crAnticiposFacturados INTO @Moneda, @TipoCambio, @Importe, @Impuestos, @Retencion, @PorcentajeImpuesto, @PorcentajeRetencion,
@AnticipoAplicar, @AnticipoSaldo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @PreciosIVAIncluido = 0
BEGIN
SET @MovAnticipoAplicarSImp = (((@AnticipoAplicar*@TipoCambio)/@MovTipoCambio)/(1+(@PorcentajeImpuesto/100.0)))*(1+(@PorcentajeRetencion/100.0))
SET @Retencion = @MovAnticipoAplicarSImp*(@PorcentajeRetencion/100.0)
END
ELSE
BEGIN
SET @MovAnticipoAplicarCimp = (((@AnticipoAplicar*@TipoCambio)/@MovTipoCambio)*(1+(@PorcentajeRetencion/100.0)))
SET @Retencion = (((@AnticipoAplicar*@TipoCambio)/@MovTipoCambio)/(1+(@PorcentajeImpuesto/100.0)))*(1+(@PorcentajeRetencion/100.0))
* (@PorcentajeRetencion/100.0)
END
SET @MovAnticipoAplicarSImp = (((@AnticipoAplicar*@TipoCambio)/@MovTipoCambio)/(1+(@PorcentajeImpuesto/100.0)))*(1+(@PorcentajeRetencion/100.0))
SET @MovAnticipoAplicarSImp = (((@AnticipoAplicar*@TipoCambio)/@MovTipoCambio)/(1+(@PorcentajeImpuesto/100.0)))*(1+(@PorcentajeRetencion/100.0))
SET @CantidadInventario = NULL
SET @UnidadFactor = NULL
IF @CfgMultiUnidades = 1 AND @CfgVentaFactorDinamico = 1
BEGIN
EXEC spUnidadFactor @Empresa, @CfgAnticipoArticuloServicio, NULL, @Unidad, @UnidadFactor OUTPUT
END
INSERT POSLVenta (
ID, Renglon, RenglonSub, RenglonID,  RenglonTipo, Articulo, Precio, Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario,
Unidad, Factor, AnticipoFacturado, AnticipoRetencion, PrecioImpuestoInc, Aplicado,AplicaDescGlobal)
VALUES (
@ID, @Renglon, 0, @RenglonID, 'N', @CfgAnticipoArticuloServicio, @MovAnticipoAplicarSImp, ROUND(@PorcentajeImpuesto,2,2), 0.0, 0.0, -1,
-1 * @UnidadFactor, @Unidad, 1, 1, @Retencion, @MovAnticipoAplicarCimp, 1, 0)
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
SET @AsignoAnticipo = 1
FETCH NEXT FROM crAnticiposFacturados INTO @Moneda, @TipoCambio, @Importe, @Impuestos, @Retencion, @PorcentajeImpuesto, @PorcentajeRetencion,
@AnticipoAplicar, @AnticipoSaldo
END
CLOSE crAnticiposFacturados
DEALLOCATE crAnticiposFacturados
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND ISNULL(AnticipoFacturado,0) = 1)
UPDATE POSL
SET AnticipoFacturadoTipoServicio = 1
WHERE ID = @ID
END
END

