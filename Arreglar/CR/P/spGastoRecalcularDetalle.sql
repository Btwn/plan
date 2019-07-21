SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoRecalcularDetalle
@ID      int,
@Modulo  varchar(5),
@Ok      int OUTPUT,
@OkRef   varchar(255) OUTPUT

AS BEGIN
DECLARE
@Mov                  varchar(20),
@Fecha                datetime,
@Empresa              varchar(5),
@Sucursal             int,
@Acreedor             varchar(10),
@Concepto             varchar(50),
@Renglon              float,
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float,
@Retencion1		float,
@Retencion2		float,
@Retencion3		float,
@TipoImpuesto1	varchar(10),
@TipoImpuesto2	varchar(10),
@TipoImpuesto3	varchar(10),
@TipoRetencion1	varchar(10),
@TipoRetencion2	varchar(10),
@TipoRetencion3	varchar(10),
@TipoImpuesto4	varchar(10),
@Impuesto5		float	,
@TipoImpuesto5	varchar(10),
@TipoImpuesto         bit,
@SubTotal             float,
@Impuesto2BaseImpuesto1 bit,
@Impuesto2Info        bit,
@Impuesto3Info        bit,
@Impuestos            float,
@Impuestos2           float,
@Impuestos3           float,
@MovClave             varchar(20),
@GastoSolicitudAnticipoImpuesto  bit,
@ZonaImpuestos        varchar(30),
@ConceptoImpuestos    float,
@Conceptoretencion2   float,
@RetencionGasto1	float,
@RetencionGasto2	float,
@RetencionGasto3	float,
@ConceptoRetencion    float,
@Conceptoretencion3   float,
@TieneRetencion       bit,
@Retencion2BaseImpuesto1 bit,
@Gasto2Retenciones 	  bit,
@Gasto3Retenciones 	  bit,
@Retenciones            float
SELECT @Impuesto2BaseImpuesto1 = ISNULL(Impuesto2BaseImpuesto1,0), @Impuesto2Info = ISNULL(Impuesto2Info,0), @Impuesto3Info = ISNULL(Impuesto3Info,0),@Retencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1,0)
FROM Version
SELECT @Mov = Mov , @Fecha = FechaEmision , @Empresa = Empresa, @Sucursal = Sucursal, @Acreedor = Acreedor, @TieneRetencion = TieneRetencion
FROM Gasto
WHERE  ID = @ID
SELECT @ZonaImpuestos = ZonaImpuesto FROM Prov WHERE Proveedor = @Acreedor
SELECT @MovClave = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'GAS'
SELECT @TipoImpuesto = ISNULL(TipoImpuesto,0) FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @GastoSolicitudAnticipoImpuesto =ISNULL(GastoSolicitudAnticipoImpuesto,0), @Gasto2Retenciones = ISNULL(Gasto2Retenciones,0), @Gasto3Retenciones = ISNULL(Gasto3Retenciones,0) FROM EmpresaCfg2  WHERE Empresa = @Empresa
DECLARE crGastoD CURSOR FOR
SELECT Renglon, Concepto
FROM GastoD
WHERE ID = @ID
OPEN crGastoD
FETCH NEXT FROM crGastoD INTO @Renglon, @Concepto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @ConceptoImpuestos = Impuestos, @ConceptoRetencion = Retencion, @Conceptoretencion2 = Retencion2, @Conceptoretencion3 = Retencion3 FROM Concepto WHERE Concepto = @Concepto AND Modulo = 'GAS'
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @Fecha, @Empresa, @Sucursal, @Acreedor, NULL, NULL, @Concepto, 1, 1, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3 OUTPUT, @Retencion1 OUTPUT, @Retencion2 OUTPUT, @Retencion3 OUTPUT, @TipoImpuesto1 OUTPUT, @TipoImpuesto2 OUTPUT, @TipoImpuesto3 OUTPUT, @TipoRetencion1 OUTPUT, @TipoRetencion2 OUTPUT, @TipoRetencion3 OUTPUT, @TipoImpuesto4 OUTPUT, @Impuesto5 OUTPUT, @TipoImpuesto5 OUTPUT
UPDATE GastoD SET Impuesto1 = @Impuesto1,
Impuesto2 = @Impuesto2,
Impuesto3 = @Impuesto3,
TipoImpuesto1 = @TipoImpuesto1,
TipoImpuesto2 = @TipoImpuesto2,
TipoImpuesto3 = @TipoImpuesto3,
TipoRetencion1 =@TipoRetencion1,
TipoRetencion2 =@TipoRetencion2,
TipoRetencion3 =@TipoRetencion3,
TipoImpuesto4 = @TipoImpuesto4,
Impuesto5 = @Impuesto5,
TipoImpuesto5 = @TipoImpuesto5
WHERE ID = @ID
AND Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
SELECT @SubTotal = ISNULL(Importe,0.0)-ISNULL(Retencion3,0.0) FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
IF @TipoImpuesto = 1
BEGIN
SELECT @Impuestos = (@SubTotal*(1+CASE WHEN (@Impuesto2BaseImpuesto1 = 0)OR(@Impuesto2Info = 1) THEN 0 ELSE ((ISNULL(Impuesto2,0.0)/100))*(ISNULL(Impuesto1,0.0)/100)END)),
@RetencionGasto1 = @SubTotal * @Retencion1/100
FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
IF @Retencion2BaseImpuesto1 = 1
SELECT  @RetencionGasto2 = @Impuestos * @Retencion2/100
ELSE
SELECT  @RetencionGasto2 = @SubTotal * @Retencion2/100
SELECT @RetencionGasto3 = Importe*@Retencion3/100  FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
END
ELSE
BEGIN
IF @MovClave IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.CCH', 'GAS.DC', 'GAS.CP', 'GAS.DG', 'GAS.DGP', 'GAS.OI', 'GAS.CB', 'GAS.AB')
OR @GastoSolicitudAnticipoImpuesto = 1
BEGIN
EXEC spZonaImp @ZonaImpuestos, @ConceptoImpuestos OUTPUT
SELECT @Impuestos = @SubTotal*ISNULL(@ConceptoImpuestos,0.0)/100
IF @TieneRetencion = 1
BEGIN
SELECT  @RetencionGasto1 = ROUND(@SubTotal*@ConceptoRetencion/100, 4)
IF @Gasto2Retenciones = 1
BEGIN
IF @Retencion2BaseImpuesto1 =1
SELECT @RetencionGasto2 =  ROUND(@Impuestos*@Conceptoretencion2/100,4)
ELSE
SELECT @RetencionGasto2 =  ROUND(@SubTotal*@Conceptoretencion2/100,4)
END
IF @Gasto3Retenciones = 1
SELECT @RetencionGasto3 =  ROUND(Importe*@Conceptoretencion3/100,4) FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
END
END
ELSE
SELECT @Impuestos = Impuestos,@RetencionGasto1 = Retencion, @RetencionGasto2 = Retencion2,@RetencionGasto3 = Retencion3   FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
END
IF @TipoImpuesto = 1 AND @Impuesto2Info = 0
SELECT @Impuestos2 = (@SubTotal*Impuesto2/100)
FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
IF @TipoImpuesto = 1 AND @Impuesto3Info = 0
SELECT   @Impuestos3 =   Cantidad*Impuesto3  FROM GastoD WHERE ID = @ID AND Renglon = @Renglon
UPDATE GastoD SET Impuestos = ISNULL(@Impuestos,0.0), Impuestos2 = ISNULL(@Impuestos2,0.0), Impuestos3 = ISNULL(@Impuestos3,0.0), Retencion = @RetencionGasto1, Retencion2 = @RetencionGasto2, Retencion3 = @RetencionGasto3
WHERE ID = @ID AND Renglon = @Renglon
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crGastoD INTO @Renglon, @Concepto
END
CLOSE crGastoD
DEALLOCATE crGastoD
SELECT @Impuestos = SUM(ISNULL(Impuestos,0.0)), @Retenciones = SUM(ISNULL(Retencion,0.0) + ISNULL(Retencion2,0.0) + ISNULL(Retencion3,0.0)) FROM GastoD WHERE ID = @ID
UPDATE Gasto SET Impuestos = @Impuestos, Saldo = Importe + @Impuestos - @Retenciones WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
RETURN
END

