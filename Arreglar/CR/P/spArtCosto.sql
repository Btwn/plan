SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtCosto
@Sucursal			int,
@Accion	     		char(20),
@Empresa          	char(5),
@Modulo           	char(5),
@AfectarCostos		bit,
@EsEntrada        	bit,
@EsSalida	     	bit,
@EsTransferencia  	bit,
@AfectarSerieLote	bit,
@CfgFormaCosteo   	char(20),
@CfgTipoCosteo    	char(20),
@ArtTipo				char(20),
@Articulo	     	char(20),
@SubCuenta	     	varchar(50),
@Cantidad	     	float,
@Unidad				varchar(50),
@Factor	     		float,
@Costo	     		float,
@CostoSinGastos		float,
@Mov	             	char(20),
@MovID	     		varchar(20),
@MovTipo	     		char(20),
@AplicaMovTipo		char(20),
@Fecha            	datetime,
@MovMoneda	     	char(10),
@MovTipoCambio    	float,
@ID		     		int,
@RenglonID	     	int,
@Almacen				char(10),
@AlmacenTipo	     	char(20),
@CostearNivelSubCuenta 	bit,
@CfgCosteoSeries		bit,
@CfgCosteoLotes		bit,
@CfgCosteoMultipleSimultaneo	bit,
@ArtCostoIdentificado	bit,
@ArtCosto	     	float       	 OUTPUT,
@ArtAjusteCosteo		float		 OUTPUT,
@ArtCostoUEPS		float		 OUTPUT,
@ArtCostoPEPS		float		 OUTPUT,
@ArtUltimoCosto		float		 OUTPUT,
@ArtCostoEstandar	float		 OUTPUT,
@ArtCostoPromedio	float		 OUTPUT,
@ArtCostoReposicion	float		 OUTPUT,
@ArtPrecioLista		float		 OUTPUT,
@ArtMoneda        	char(10)	 OUTPUT,
@ArtFactor        	float	 	 OUTPUT,
@ArtTipoCambio    	float	 	 OUTPUT,
@Ok               	int         	 OUTPUT,
@Renglon				float	= NULL,
@RenglonSub			int	= NULL,
@OtraMoneda						varchar(10) = NULL, 
@OtraMonedaTipoCambio			float = NULL, 
@OtraMonedaTipoCambioVenta		float = NULL, 
@OtraMonedaTipoCambioCompra		float = NULL  

AS BEGIN
IF @Ok IS NOT NULL RETURN
DECLARE
@Existencia			float,
@ArtTipoCosteo      	varchar(10),
@ArtSubCosto		float,
@CostoSerieLote		float,
@UltimoCosto     		float,
@CostoPromedio      	float,
@CostoEstandar		float,
@CostoReposicion		float,
@ArtCostoSinGastos		float,
@UltimoCostoSinGastos	float,
@EsCompraConsignacion	bit
IF @Factor = 0
SET @Factor = NULL
SELECT @ArtAjusteCosteo      = NULL,
@ArtCosto	       = 0.0,
@ArtSubCosto	       = 0.0,
@UltimoCosto          = 0.0,
@UltimoCostoSinGastos = 0.0,
@CostoPromedio        = 0.0,
@CostoEstandar        = 0.0,
@CostoReposicion      = 0.0,
@CostoSerieLote       = NULL,
@EsCompraConsignacion = 0,
@Cantidad             = ISNULL(@Cantidad, 0.0) * ISNULL(@Factor, 1.0),
@Costo				   = ISNULL(@Costo, 0.0) / ISNULL(@Factor, 1.0),		
@CostoSinGastos       = ISNULL(@CostoSinGastos, 0.0) / ISNULL(@Factor, 1.0), 	
@ArtAjusteCosteo      = @ArtCostoUEPS / ISNULL(@Factor, 1.0),			
@ArtCostoUEPS	       = @ArtCostoUEPS / ISNULL(@Factor, 1.0),			
@ArtCostoPEPS	       = @ArtCostoPEPS / ISNULL(@Factor, 1.0),			
@ArtUltimoCosto       = @ArtUltimoCosto / ISNULL(@Factor, 1.0)			
IF @CostearNivelSubCuenta = 0 SELECT @SubCuenta = ''
IF @SubCuenta IS NULL SELECT @SubCuenta = ''
IF @AplicaMovTipo = 'COMS.CC' AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI') SELECT @EsCompraConsignacion = 1
SELECT @ArtMoneda       = MonedaCosto,
@ArtTipoCosteo   = UPPER(TipoCosteo),
@CostoEstandar   = ISNULL(CostoEstandar, 0.0),
@CostoReposicion = ISNULL(CostoReposicion, 0.0)
FROM Art
WHERE Articulo = @Articulo
IF @@ERROR <> 0 SELECT @Ok = 1
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT
IF @AlmacenTipo = 'ACTIVOS FIJOS'
BEGIN
IF @EsEntrada = 1 SELECT @ArtCosto = @Costo / @ArtFactor ELSE	
IF @EsSalida = 1
SELECT @ArtCosto = AVG(ISNULL(NULLIF(ValorRevaluado, 0.0), AdquisicionValor)-ISNULL(DepreciacionAcum, 0.0)) / @ArtFactor  
FROM ActivoF
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND Serie IN (SELECT SerieLote FROM SerieLoteMov WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo)
RETURN
END
IF @CostearNivelSubCuenta = 1
BEGIN
SELECT @CostoEstandar        = ISNULL(CostoEstandar, 0.0),
@CostoReposicion      = ISNULL(CostoReposicion, 0.0)
FROM ArtSub
WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta
SELECT @UltimoCosto	         = ISNULL(UltimoCosto, 0.0),
@UltimoCostoSinGastos = ISNULL(UltimoCostoSinGastos, 0.0),
@CostoPromedio        = ISNULL(CostoPromedio, 0.0)
FROM ArtSubCosto
WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @Empresa AND Sucursal = @Sucursal
END ELSE
SELECT @UltimoCosto	         = ISNULL(UltimoCosto, 0.0),
@UltimoCostoSinGastos = ISNULL(UltimoCostoSinGastos, 0.0),
@CostoPromedio        = ISNULL(CostoPromedio, 0.0)
FROM ArtCosto
WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgFormaCosteo = 'ARTICULO'
SELECT @CfgTipoCosteo = @ArtTipoCosteo
IF UPPER(@CfgTipoCosteo) NOT IN ('PROMEDIO', 'ESTANDAR', 'REPOSICION', 'UEPS', 'PEPS') SELECT @Ok = 70080
EXEC xpArtCosto @Empresa, @Sucursal, @Accion, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, @CostoEstandar OUTPUT, @CostoPromedio OUTPUT, @CostoReposicion OUTPUT, @UltimoCosto OUTPUT, @UltimoCostoSinGastos OUTPUT, @Ok OUTPUT
IF @EsEntrada = 1
BEGIN
IF @EsTransferencia = 1 AND ISNULL(@Costo, 0) = 0.0 SELECT @Costo = @CostoPromedio
IF @MovMoneda <> @ArtMoneda AND @CfgFormaCosteo = 'ARTICULO' AND EXISTS (SELECT * FROM EmpresaCfgModulo where Empresa = @Empresa AND Modulo = @Modulo)
BEGIN
IF EXISTS (SELECT * FROM EmpresaCfgModulo where Empresa = @Empresa AND Modulo = @Modulo AND TipoCambio = 'General')
SELECT @ArtCosto          = @Costo          / @ArtFactor,	
@ArtCostoSinGastos = @CostoSinGastos / @ArtFactor	
ELSE
IF EXISTS (SELECT * FROM EmpresaCfgModulo where Empresa = @Empresa AND Modulo = @Modulo AND TipoCambio = 'Compra')
SELECT @ArtCosto          = @Costo          / ISNULL(dbo.fnTipoCambioCompra(@ArtMoneda), @ArtFactor),	
@ArtCostoSinGastos = @CostoSinGastos / ISNULL(dbo.fnTipoCambioCompra(@ArtMoneda), @ArtFactor)	
ELSE
IF EXISTS (SELECT * FROM EmpresaCfgModulo where Empresa = @Empresa AND Modulo = @Modulo AND TipoCambio = 'Venta')
SELECT @ArtCosto          = @Costo          / ISNULL(dbo.fnTipoCambioVenta(@ArtMoneda), @ArtFactor),	
@ArtCostoSinGastos = @CostoSinGastos / ISNULL(dbo.fnTipoCambioVenta(@ArtMoneda), @ArtFactor)	
END
ELSE
SELECT @ArtCosto          = @Costo          / @ArtFactor,	
@ArtCostoSinGastos = @CostoSinGastos / @ArtFactor	
IF @CfgTipoCosteo IN ('UEPS','PEPS') AND @EsCompraConsignacion = 0
EXEC spAgregarCapas @Sucursal, 'G', @Empresa, @Articulo, @SubCuenta, @Fecha, @Cantidad, @ArtCosto, @Modulo, @Mov, @MovID, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @OtraMoneda = @OtraMoneda, @OtraMonedaTipoCambio = @OtraMonedaTipoCambio, @OtraMonedaTipoCambioVenta = @OtraMonedaTipoCambioVenta, @OtraMonedaTipoCambioCompra = @OtraMonedaTipoCambioCompra 
IF @Accion <> 'CANCELAR'
SELECT @ArtCostoUEPS = @ArtCosto, @ArtCostoPEPS = @ArtCosto
IF @CfgCosteoMultipleSimultaneo = 1 AND @EsCompraConsignacion = 0
BEGIN
EXEC spAgregarCapas @Sucursal, 'U', @Empresa, @Articulo, @SubCuenta, @Fecha, @Cantidad, @ArtCostoUEPS, @Modulo, @Mov, @MovID, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @OtraMoneda = @OtraMoneda, @OtraMonedaTipoCambio = @OtraMonedaTipoCambio, @OtraMonedaTipoCambioVenta = @OtraMonedaTipoCambioVenta, @OtraMonedaTipoCambioCompra = @OtraMonedaTipoCambioCompra 
EXEC spAgregarCapas @Sucursal, 'P', @Empresa, @Articulo, @SubCuenta, @Fecha, @Cantidad, @ArtCostoPEPS, @Modulo, @Mov, @MovID, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @OtraMoneda = @OtraMoneda, @OtraMonedaTipoCambio = @OtraMonedaTipoCambio, @OtraMonedaTipoCambioVenta = @OtraMonedaTipoCambioVenta, @OtraMonedaTipoCambioCompra = @OtraMonedaTipoCambioCompra 
END
IF @Accion <> 'CANCELAR' AND @MovTipo IN ('COMS.F','COMS.FL','COMS.EG','COMS.EI','INV.E','INV.EP','INV.EI','PROD.E')
SELECT @UltimoCosto = @ArtCosto, @UltimoCostoSinGastos = @ArtCostoSinGastos
/* Para que cuando cancele la factura borre SalidaID */
IF @ArtTipo = 'VIN' AND @Accion = 'CANCELAR'
UPDATE VINCostoExtra SET SalidaID = NULL WHERE Empresa = @Empresa AND VIN IN (SELECT SerieLote FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, ''))
END 
ELSE
IF @EsSalida = 1
BEGIN
IF @Accion = 'CANCELAR' OR (@MovTipo IN ('COMS.D', 'INV.A') AND @Costo <> 0.0)
BEGIN
SELECT @ArtCosto = @Costo / @ArtFactor	
IF @CfgTipoCosteo IN ('UEPS','PEPS')
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, @CfgTipoCosteo, 'G', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCosto OUTPUT, @Ok OUTPUT, @CostoEspecifico = 1, @AjusteCosteo = @ArtAjusteCosteo OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
END ELSE
BEGIN
IF @CfgTipoCosteo = 'PROMEDIO'   SELECT @ArtCosto = @CostoPromedio   ELSE
IF @CfgTipoCosteo = 'ESTANDAR'   SELECT @ArtCosto = @CostoEstandar   ELSE
IF @CfgTipoCosteo = 'REPOSICION' SELECT @ArtCosto = @CostoReposicion ELSE
IF @CfgTipoCosteo IN ('UEPS','PEPS') AND @EsCompraConsignacion = 0
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, @CfgTipoCosteo, 'G', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCosto OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
END
IF @CfgCosteoMultipleSimultaneo = 1 AND @EsCompraConsignacion = 0
BEGIN
SELECT @ArtCostoUEPS = @ArtCosto, @ArtCostoPEPS = @ArtCosto
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'UEPS', 'U', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCostoUEPS OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'PEPS', 'P', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCostoPEPS OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
END
END
IF @EsTransferencia = 1 AND @AfectarCostos = 0
BEGIN
IF @CfgTipoCosteo = 'ESTANDAR'   SELECT @ArtCosto = @CostoEstandar ELSE
IF @CfgTipoCosteo = 'REPOSICION' SELECT @ArtCosto = @CostoReposicion
ELSE SELECT @ArtCosto = @CostoPromedio
END
IF /*@AfectarSerieLote = 1 AND */(@EsSalida = 1 OR (@EsTransferencia = 1 AND @AfectarCostos = 0)) AND @Accion <> 'CANCELAR'
IF (@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1)) OR
(@ArtTipo IN ('SERIE', 'VIN')    AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1))
BEGIN
SELECT @CostoSerieLote = 0.0
SELECT @CostoSerieLote = ISNULL(SUM(m.Cantidad*ISNULL(s.CostoPromedio, 0.0))/NULLIF(SUM(m.Cantidad), 0.0), 0.0)
FROM SerieLoteMov m, SerieLote s
WHERE m.Empresa = @Empresa AND m.Modulo = @Modulo AND m.ID = @ID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '') AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen AND m.Tarima = s.Tarima
IF @ArtTipo = 'VIN'
BEGIN
/*        SELECT @CostoSerieLote = @CostoSerieLote + ISNULL(SUM(m.Cantidad*ISNULL(s.CostoExtra, 0.0))/NULLIF(SUM(m.Cantidad), 0.0), 0.0)
FROM SerieLoteMov m, VINCostoExtraEmpresaSinSalida s
WHERE m.Empresa = @Empresa AND m.Modulo = @Modulo AND m.ID = @ID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.VIN = m.SerieLote
IF ISNULL(@CostoSerieLote, 0.0) < 0.0 SELECT @Ok = 20101
*/
UPDATE VINCostoExtra SET SalidaID = @ID WHERE Empresa = @Empresa AND VIN IN (SELECT SerieLote FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, ''))
END
IF @CostoSerieLote <> 0.0 SELECT @ArtCosto = @CostoSerieLote
END
IF @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
BEGIN
SELECT @ArtCosto = @Costo / @ArtFactor	
IF @CfgTipoCosteo IN ('UEPS','PEPS') AND @EsCompraConsignacion = 0
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, @CfgTipoCosteo, 'G', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCosto, @Ok OUTPUT,
@CostoEspecifico = 1, @AjusteCosteo = @ArtAjusteCosteo OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
IF @CfgCosteoMultipleSimultaneo = 1 AND @EsCompraConsignacion = 0
BEGIN
SELECT @ArtCostoUEPS = @ArtCosto, @ArtCostoPEPS = @ArtCosto
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'UEPS', 'U', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCostoUEPS, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub/*,
@CostoEspecifico = 1, @AjusteCosteo = @ArtAjusteCosteo OUTPUT*/
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'PEPS', 'P', @Empresa, @Articulo, @SubCuenta, @Cantidad, 0, @ArtCostoPEPS, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub/*,
@CostoEspecifico = 1, @AjusteCosteo = @ArtAjusteCosteo OUTPUT*/
END
IF @Ok IS NULL
EXEC spExistenciaSucursal @Sucursal, @Empresa, @Articulo, @SubCuenta, @CostearNivelSubCuenta, @Existencia OUTPUT
EXEC spBonificarCostoPromedio @Existencia, @Accion, @MovTipo, @Cantidad, @ArtCosto, @CostoPromedio OUTPUT
END
ELSE
IF @AfectarCostos = 1 AND @EsTransferencia = 1 AND @EsEntrada = 0 AND @EsSalida = 0
BEGIN
SELECT @ArtCosto = @Costo / @ArtFactor		
IF @CfgTipoCosteo IN ('UEPS','PEPS') AND @EsCompraConsignacion = 0
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, @CfgTipoCosteo, 'G', @Empresa, @Articulo, @SubCuenta, @Cantidad, 1, @ArtCosto OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
IF @CfgCosteoMultipleSimultaneo = 1 AND @EsCompraConsignacion = 0
BEGIN
SELECT @ArtCostoUEPS = @ArtCosto, @ArtCostoPEPS = @ArtCosto
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'UEPS', 'U', @Empresa, @Articulo, @SubCuenta, @Cantidad, 1, @ArtCostoUEPS OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
EXEC spModificarCapas @Sucursal, @Accion, @Modulo, @MovTipo, @Mov, @MovID, @Fecha, 'PEPS', 'P', @Empresa, @Articulo, @SubCuenta, @Cantidad, 1, @ArtCostoPEPS OUTPUT, @Ok OUTPUT, @Almacen = @Almacen, @ID = @ID, @Renglon = @Renglon, @RenglonSub = @RenglonSub
END
EXEC spExistenciaSucursal @Sucursal, @Empresa, @Articulo, @SubCuenta, @CostearNivelSubCuenta, @Existencia OUTPUT
EXEC spCalcCostoPromedio @Existencia, 1, @Cantidad, @ArtCosto, @CostoPromedio OUTPUT
END  
IF (@EsEntrada = 1 OR @EsSalida = 1 OR @MovTipo = 'COMS.CC') AND @EsTransferencia = 0 AND @MovTipo NOT IN ('COMS.B', 'COMS.CA', 'COMS.GX') AND @Ok IS NULL
BEGIN
EXEC spExistenciaSucursal @Sucursal, @Empresa, @Articulo, @SubCuenta, @CostearNivelSubCuenta, @Existencia OUTPUT
EXEC spCalcCostoPromedio @Existencia, @EsEntrada, @Cantidad, @ArtCosto, @CostoPromedio OUTPUT
END
IF @AfectarCostos = 1 
BEGIN
IF @CostearNivelSubCuenta = 1
BEGIN
UPDATE ArtSubCosto
SET UltimoCosto          = @UltimoCosto,
UltimoCostoSinGastos = @UltimoCostoSinGastos,
CostoPromedio        = @CostoPromedio
WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @Empresa AND Sucursal = @Sucursal
IF @@ROWCOUNT = 0
INSERT ArtSubCosto (Sucursal,  Empresa,  Articulo,  SubCuenta,  UltimoCosto,  UltimoCostoSinGastos,  CostoPromedio)
VALUES (@Sucursal, @Empresa, @Articulo, @SubCuenta, @UltimoCosto, @UltimoCostoSinGastos, @CostoPromedio)
END ELSE
BEGIN
UPDATE ArtCosto
SET UltimoCosto          = @UltimoCosto,
UltimoCostoSinGastos = @UltimoCostoSinGastos,
CostoPromedio        = @CostoPromedio
WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal
IF @@ROWCOUNT = 0
INSERT ArtCosto (Sucursal,  Empresa,  Articulo,  UltimoCosto,  UltimoCostoSinGastos,  CostoPromedio)
VALUES (@Sucursal, @Empresa, @Articulo, @UltimoCosto, @UltimoCostoSinGastos, @CostoPromedio)
END
IF @@ERROR <> 0 SELECT @Ok = 1
END
SELECT @ArtCosto            = @ArtCosto        * @Factor,
@ArtAjusteCosteo     = @ArtAjusteCosteo * @Factor,
@ArtCostoUEPS        = @ArtCostoUEPS    * @Factor,
@ArtCostoPEPS        = @ArtCostoPEPS    * @Factor,
@ArtUltimoCosto      = @UltimoCosto     * @Factor,
@ArtCostoEstandar    = @CostoEstandar   * @Factor,
@ArtCostoPromedio    = @CostoPromedio   * @Factor,
@ArtCostoReposicion  = @CostoEstandar   * @Factor
SELECT @ArtPrecioLista = dbo.fnPrecioSucursal(@Empresa, @Sucursal, @MovMoneda, @MovTipoCambio, @Articulo, @SubCuenta, @Unidad)
RETURN
END

