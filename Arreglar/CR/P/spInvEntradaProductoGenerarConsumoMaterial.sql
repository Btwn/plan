SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvEntradaProductoGenerarConsumoMaterial
@Accion	varchar(20),
@Empresa	char(5),
@ID          int,
@IDGenerar	int		OUTPUT,
@Ok		int		OUTPUT,
@OkRef	varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CfgMermaIncluida		bit,
@CfgDesperdicioIncluido	bit,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgTipoMerma		char(1),
@MovGenerar			varchar(20),
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@Unidad			varchar(50),
@Factor			float,
@SerieLote			varchar(50),
@Renglon			float,
@RenglonID 			int
SELECT @CfgMermaIncluida 	 = ProdMermaIncluida,
@CfgDesperdicioIncluido = ProdDesperdicioIncluido,
@CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgTipoMerma		 = ISNULL(ProdTipoMerma, '%')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @MovGenerar = ProdConsumoMaterial
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Renglon = 0.0, @RenglonID = 0
INSERT Inv (
Empresa, Sucursal, Usuario, Mov,         FechaEmision, Almacen, Concepto, Referencia, Proyecto, Estatus,     OrigenTipo, DocFuente, Moneda, TipoCambio, VerLote)
SELECT Empresa, Sucursal, Usuario, @MovGenerar, FechaEmision, Almacen, Concepto, Referencia, Proyecto, 'CONFIRMAR', 'INV/EP',   ID,        Moneda, TipoCambio, 1
FROM Inv
WHERE ID = @ID
SELECT @IDGenerar = SCOPE_IDENTITY()
DECLARE crSerieLoteMov CURSOR FOR
SELECT DISTINCT d.Articulo, d.SubCuenta, d.Unidad, d.Factor, slm.SerieLote, slm.Cantidad
FROM InvD d
JOIN SerieLoteMov slm ON slm.Empresa = @Empresa AND slm.Modulo = 'INV' AND slm.ID = d.ID AND slm.Articulo = d.Articulo AND ISNULL(slm.SubCuenta, '') = ISNULL(d.Subcuenta, '')
WHERE d.ID = @ID
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @Articulo, @SubCuenta, @Unidad, @Factor, @SerieLote, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spProdExp @IDGenerar, NULL, @SerieLote,
@Articulo, @SubCuenta, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, NULL, NULL,
@CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma,
NULL,
@Renglon OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Modulo = 'INV', @RenglonID = @RenglonID OUTPUT
END
FETCH NEXT FROM crSerieLoteMov INTO @Articulo, @SubCuenta, @Unidad, @Factor, @SerieLote, @Cantidad
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
IF @IDGenerar IS NOT NULL SELECT @Ok = 80030
RETURN
END

