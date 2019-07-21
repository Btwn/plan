SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVtasAplicarAnticiposTipoServicio
@Estacion       int,
@ID             int

AS BEGIN
DECLARE
@Transaccion                        varchar(50),
@Ok                                 int,
@OkRef                              varchar(255),
@Empresa                            varchar(5),
@Cliente                            varchar(10),
@CfgAnticipoTipoServicio            bit,
@CfgAnticipoArticuloServicio        varchar(20),
@CfgMultiUnidades                   bit,
@CfgVentaFactorDinamico             bit,
@MovMoneda                          varchar(10),
@MovTipoCambio                      float,
@Moneda                             varchar(10),
@TipoCambio                         float,
@Importe                            float,
@Impuestos                          float,
@Retencion                          float,
@Retencion2                          float,
@AnticipoRetencion					float,
@PorcentajeImpuesto                 float,
@PorcentajeRetencion                float,
@PorcentajeRetencion2                float,
@AnticipoAplicar                    float,
@AnticipoSaldo                      float,
@MovAnticipoAplicar                 float,
@Renglon                            float,
@RenglonID                          int,
@Almacen                            varchar(10),
@Unidad                             varchar(50),
@Sucursal                           int,
@AsignoAnticipo                     bit,
@PreciosIVAIncluido                 bit,
@CantidadInventario                 float,
@UnidadFactor                       float,
@FactorAplicar						float,
@TipoImpuesto1						varchar(10) ,
@FechaEmision						datetime,
@Mov								varchar(10),
@Contacto							varchar(10)
SET @Transaccion = 'spVtasAplicarAnticiposTipoServicio' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
UPDATE Venta SET AnticipoFacturadoTipoServicio = 0 WHERE ID = @ID
DELETE FROM VentaD WHERE ID = @ID AND AnticipoFacturado = 1
SELECT @Ok = NULL, @OkRef = NULL
SELECT
@Empresa = Empresa,
@Cliente = Cliente,
@MovMoneda  = Moneda,
@MovTipoCambio = TipoCambio,
@Almacen = Almacen,
@Sucursal = Sucursal
FROM Venta
WHERE ID = @ID
SELECT
@PreciosIVAIncluido = VentaPreciosImpuestoIncluido
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT
@CfgAnticipoTipoServicio     = ISNULL(CxcAnticipoTipoServicio,0),
@CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,''),
@CfgMultiUnidades            = ISNULL(MultiUnidades,0),
@CfgVentaFactorDinamico      = ISNULL(VentaFactorDinamico,0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgAnticipoArticuloServicio IS NULL SELECT @Ok = 10490, @OkRef = @Empresa
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @CfgAnticipoArticuloServicio
IF @CfgAnticipoTipoServicio = 1 AND @Ok IS NULL
BEGIN
SELECT @Renglon = ISNULL(MAX(ISNULL(Renglon,0.0)),0.0) + 2048.0 FROM VentaD WHERE ID = @ID
SELECT @RenglonID = ISNULL(MAX(ISNULL(RenglonID,0)),0.0) + 1 FROM VentaD WHERE ID = @ID
SET @AsignoAnticipo = 0
DECLARE crAnticiposFacturados CURSOR FOR
SELECT Moneda, ISNULL(TipoCambio,0.0), SUM(ISNULL(Importe,0.0)), SUM(ISNULL(Impuestos,0.0)), SUM(ISNULL(Retencion,0.0)), ROUND((ISNULL(Impuestos,0.0)/ISNULL(Importe,0.0))*100.0,0), ROUND((ISNULL(Retencion,0.0)/ISNULL(Importe,0.0))*100.0,0), SUM(ISNULL(AnticipoAplicar,0.0)), SUM(ISNULL(AnticipoSaldo,0.0)), SUM(ISNULL(Retencion2,0.0)), ROUND((ISNULL(Retencion2,0.0)/ISNULL(Importe,0.0))*100.0,0)
FROM Cxc
WHERE Empresa = @Empresa
AND AnticipoSaldo > 0.0
AND Estatus IN ('PENDIENTE','CONCLUIDO')
AND Cliente = @Cliente
AND ISNULL(AnticipoAplicar,0.0) > 0.0
AND AnticipoAplicaID = @ID
GROUP BY Moneda, ISNULL(TipoCambio,0.0), ROUND((ISNULL(Impuestos,0.0)/ISNULL(Importe,0.0))*100.0,0), ROUND((ISNULL(Retencion,0.0)/ISNULL(Importe,0.0))*100.0,0), ROUND((ISNULL(Retencion2,0.0)/ISNULL(Importe,0.0))*100.0,0)
OPEN crAnticiposFacturados
FETCH NEXT FROM crAnticiposFacturados INTO @Moneda, @TipoCambio, @Importe, @Impuestos, @Retencion, @PorcentajeImpuesto, @PorcentajeRetencion, @AnticipoAplicar, @AnticipoSaldo, @Retencion2, @PorcentajeRetencion2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @FactorAplicar = @AnticipoAplicar / (@Importe  + @Impuestos - @Retencion - @Retencion2)
IF @PreciosIVAIncluido = 0
BEGIN
IF @MovMoneda = @Moneda
BEGIN
SET @MovAnticipoAplicar = @AnticipoAplicar
SET @MovAnticipoAplicar = @MovAnticipoAplicar - (@Impuestos * @FactorAplicar)
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (@Retencion * @FactorAplicar)
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (@Retencion2 * @FactorAplicar)
SET @Retencion = @MovAnticipoAplicar*(@PorcentajeRetencion/100.0)
SET @Retencion2 = @MovAnticipoAplicar*(@PorcentajeRetencion2/100.0)
END
ELSE
BEGIN
SET @MovAnticipoAplicar = (@AnticipoAplicar*@TipoCambio)/@MovTipoCambio
SET @MovAnticipoAplicar = @MovAnticipoAplicar - (((@Impuestos*@TipoCambio)/@MovTipoCambio) * @FactorAplicar)
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (((@Retencion*@TipoCambio)/@MovTipoCambio) * @FactorAplicar)
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (((@Retencion2*@TipoCambio)/@MovTipoCambio) * @FactorAplicar)
SET @Retencion = @MovAnticipoAplicar*(@PorcentajeRetencion/100.0)
SET @Retencion2 = @MovAnticipoAplicar*(@PorcentajeRetencion2/100.0)
END
END
ELSE
BEGIN
IF @MovMoneda = @Moneda
BEGIN
SET @MovAnticipoAplicar = @AnticipoAplicar
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (@Retencion * @FactorAplicar) + (@Retencion2 * @FactorAplicar)
SET @Retencion = @MovAnticipoAplicar*(@PorcentajeRetencion/100.0)
SET @Retencion2 = @MovAnticipoAplicar*(@PorcentajeRetencion2/100.0)
END
ELSE
BEGIN
SET @MovAnticipoAplicar = (@AnticipoAplicar*@TipoCambio)/@MovTipoCambio
SET @MovAnticipoAplicar = @MovAnticipoAplicar + (((@Retencion*@TipoCambio)/@MovTipoCambio) * @FactorAplicar) + (((@Retencion2*@TipoCambio)/@MovTipoCambio) * @FactorAplicar)
SET @Retencion = @MovAnticipoAplicar*(@PorcentajeRetencion/100.0)
SET @Retencion2 = @MovAnticipoAplicar*(@PorcentajeRetencion2/100.0)
END
END
SET @AnticipoRetencion = ISNULL(@Retencion,0.0) + ISNULL(@Retencion2,0.0)
SET @CantidadInventario = NULL
SET @UnidadFactor = NULL
IF @CfgMultiUnidades = 1 AND @CfgVentaFactorDinamico = 1
BEGIN
EXEC spUnidadFactor @Empresa, @CfgAnticipoArticuloServicio, NULL, @Unidad, @UnidadFactor OUTPUT
END
EXEC spMovInfo       @ID,'VTAS',@Mov =@Mov output , @FechaEmision=@FechaEmision output,@Contacto =@Contacto output
EXEC spTipoImpuesto 'VTAS',@ID , @Mov,@FechaEmision, @Empresa =@Empresa ,@Sucursal=@Sucursal ,@Contacto=@Contacto  , @Articulo = @CfgAnticipoArticuloServicio,@TipoImpuesto1=@TipoImpuesto1 output
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo, Almacen,  Articulo,                     Precio,              Impuesto1,           Impuesto2, Impuesto3, Cantidad, CantidadInventario, Unidad,  Factor, Sucursal,  AnticipoFacturado, AnticipoMoneda, AnticipoTipoCambio, PrecioMoneda, PrecioTipoCambio, DescuentoTipo, AnticipoRetencion,  Retencion1,           Retencion2           ,TipoImpuesto1)
VALUES (@ID, @Renglon, 0,          @RenglonID, 'N',         @Almacen, @CfgAnticipoArticuloServicio, @MovAnticipoAplicar, @PorcentajeImpuesto, 0.0,       0.0,       -1,       -1*@UnidadFactor,   @Unidad, 1,      @Sucursal, 1,                 @MovMoneda,     @MovTipoCambio,     @MovMoneda,   @MovTipoCambio,   NULL,          @AnticipoRetencion, @PorcentajeRetencion, @PorcentajeRetencion2,@TipoImpuesto1)
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
SET @AsignoAnticipo = 1
FETCH NEXT FROM crAnticiposFacturados INTO @Moneda, @TipoCambio, @Importe, @Impuestos, @Retencion, @PorcentajeImpuesto, @PorcentajeRetencion, @AnticipoAplicar, @AnticipoSaldo, @Retencion2, @PorcentajeRetencion2
END
CLOSE crAnticiposFacturados
DEALLOCATE crAnticiposFacturados
IF @AsignoAnticipo = 1 UPDATE Venta SET AnticipoFacturadoTipoServicio = 1 WHERE ID = @ID
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso Exitoso...'
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

