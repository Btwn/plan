SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvProdSerieLoteDesdeOrden
@Sucursal				int,
@Modulo				char(5),
@OID					int,
@DID					int,
@CopiarArtCostoInv			bit = 0,
@Accion				varchar(20),
@Ok					int OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE
@ProdSerieLoteDesdeOrden			bit,
@ProdSerieloteIndicarArrastre       bit,
@Empresa						varchar(5),
@OMovTipo						varchar(20),
@DMovTipo						varchar(20),
@ProdAutoLote					varchar(20),
@ORenglon						float,
@ORenglonID						int,
@OArticulo						varchar(20),
@OSubCuenta						varchar(50),
@OAlmacen						varchar(20),
@OCantidad						float,
@OCantidadA						float,
@OProdSerieLote					varchar(50),
@DRenglon						float,
@DRenglonID						varchar(20),
@DArticulo						varchar(20),
@DSubCuenta						varchar(50),
@DAlmacen						varchar(20),
@DCantidad						float,
@DCantidadA						float,
@DProdSerieLote					varchar(20),
@Cantidad						float,
@SerieLote						varchar(50),
@Limite							float,
@CantidadLoteDestino			float,
@TotalCantidadLoteDestino		float,
@Centro							varchar(20),
@CentroDestino					varchar(20),
@Verificar						int
DECLARE @SerieLoteMovArrastre		TABLE
(
Empresa			varchar(5),
Modulo			varchar(5),
ID				int,
RenglonID		int,
Articulo		varchar(20),
SubCuenta		varchar(50),
SerieLote		varchar(50),
CentroOrigen	varchar(10),
CentroDestino	varchar(10),
Cantidad		float
)
SELECT
@Empresa = p.Empresa,
@OMovTipo = mt.Clave
FROM Prod p WITH(NOLOCK) 
JOIN MovTipo mt WITH(NOLOCK) 
ON mt.Mov = p.Mov AND mt.Modulo = 'PROD'
WHERE ID = @OID
SELECT
@DMovTipo = mt.Clave
FROM Prod p WITH(NOLOCK)  
JOIN MovTipo mt WITH(NOLOCK) 
ON mt.Mov = p.Mov AND mt.Modulo = 'PROD'
WHERE ID = @DID
SELECT @ProdSerieLoteDesdeOrden = ProdSerieLoteDesdeOrden ,
@ProdAutoLote = ProdAutoLote,
@ProdSerieloteIndicarArrastre = ProdSerieloteIndicarArrastre
FROM EmpresaCfg2 WITH(NOLOCK) 
WHERE Empresa = @Empresa
IF @ProdSerieLoteDesdeOrden = 1 AND @OMovTipo IN ('PROD.O') AND @DMovTipo IN ('PROD.A','PROD.E','PROD.R','PROD.M')AND @ProdAutoLote ='Nivel Renglon' AND @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
DECLARE crActualizar CURSOR FOR
SELECT  opd.Renglon, opd.RenglonID, opd.Articulo, opd.SubCuenta, opd.Almacen, opd.Cantidad, opd.CantidadA, opd.ProdSerieLote, dpd.Renglon, dpd.RenglonID, dpd.Articulo, ISNULL(dpd.SubCuenta,''), dpd.Almacen, dpd.Cantidad, dpd.CantidadA, dpd.ProdSerieLote,dpd.Centro,dpd.CentroDestino
FROM ProdD dpd WITH(NOLOCK) 
JOIN ProdD opd WITH(NOLOCK)  
ON  dpd.ProdSerieLote = opd.ProdSerieLote
WHERE dpd.ID = @DID AND opd.ID = @OID
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @ORenglon, @ORenglonID, @OArticulo, @OSubCuenta, @OAlmacen, @OCantidad, @OCantidadA, @OProdSerieLote, @DRenglon, @DRenglonID, @DArticulo, @DSubCuenta, @DAlmacen, @DCantidad, @DCantidadA, @DProdSerieLote, @Centro, @CentroDestino
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF (SELECT Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @OArticulo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
BEGIN
DELETE FROM SerieLoteMov WHERE ID = @DID AND Modulo = @Modulo AND Articulo = @DArticulo AND ISNULL(SubCuenta,'') = ISNULL(@DSubCuenta,'') AND RenglonID = @DRenglonID AND Empresa = @Empresa
IF @@ERROR <> 0 SET @Ok = 1
SET @TotalCantidadLoteDestino = 0.0
IF @ProdSerieloteIndicarArrastre = 0
BEGIN
DECLARE crActualizar2 CURSOR FOR
SELECT SerieLote, Cantidad
FROM SerieLoteMov WITH(NOLOCK) 
WHERE ID = @OID
AND Modulo = @Modulo
AND Articulo = @OArticulo
AND ISNULL(SubCuenta,'') = ISNULL(@OSubCuenta,'')
AND RenglonID = @ORenglonID
AND Empresa = @Empresa
END
ELSE
IF @ProdSerieloteIndicarArrastre = 1
BEGIN
DECLARE crActualizar2  CURSOR FOR
SELECT slm.SerieLote, slm.Cantidad
FROM SerieLoteMovArrastre slma WITH(NOLOCK) 
JOIN SerieLoteMov slm WITH(NOLOCK) 
ON slm.ID = slma.ID
AND slm.RenglonID = slma.RenglonID
AND slm.Articulo = slma.Articulo
AND slm.SubCuenta = slma.SubCuenta
AND slm.SerieLote = slma.SerieLote
AND slm.Modulo = slma.Modulo
AND slm.Empresa = slma.Empresa
WHERE slma.ID = @OID
AND slma.Modulo = @Modulo
AND slma.Articulo = @OArticulo
AND ISNULL(slma.SubCuenta,'') = ISNULL(@OSubCuenta,'')
AND slma.RenglonID = @ORenglonID
AND slma.Empresa = @Empresa
AND slma.CentroOrigen = @Centro
AND ISNULL(slma.CentroDestino,'') = ISNULL(@CentroDestino,'')
END
SET @Limite = @DCantidad
OPEN crActualizar2
FETCH NEXT FROM crActualizar2 INTO @SerieLote, @Cantidad
WHILE @@FETCH_STATUS = 0 AND @Limite > 0.0 AND @Ok IS NULL
BEGIN
IF @Limite >= @Cantidad
SET @CantidadLoteDestino = @Cantidad
ELSE
SET @CantidadLoteDestino = @Limite
INSERT SerieLoteMov (Empresa,  Modulo,  ID,   RenglonID,   Articulo,   SubCuenta,   SerieLote,  Cantidad,             Sucursal)
VALUES (@Empresa, @Modulo, @DID, @DRenglonID, @DArticulo, @DSubCuenta, @SerieLote, @CantidadLoteDestino, @Sucursal)
IF @@ERROR <> 0 SET @Ok = 1
IF @ProdSerieloteIndicarArrastre = 1 AND @Ok IS NULL
BEGIN
INSERT @SerieLoteMovArrastre (Empresa, Modulo,  ID,   RenglonID,   Articulo,   SubCuenta,   SerieLote,  CentroOrigen, CentroDestino,  Cantidad)
SELECT @Empresa, @Modulo, @OID, @DRenglonID, @DArticulo, @DSubCuenta, @SerieLote, @Centro,      @CentroDestino, @CantidadLoteDestino
END
SET @Limite = @Limite - @CantidadLoteDestino
SET @TotalCantidadLoteDestino = @TotalCantidadLoteDestino + @CantidadLoteDestino
FETCH NEXT FROM crActualizar2 INTO @SerieLote, @Cantidad
END
CLOSE crActualizar2
DEALLOCATE crActualizar2
IF @DCantidad <> @TotalCantidadLoteDestino SELECT @Ok = 20330, @OkRef = @DArticulo + '. ' + ISNULL(@DSubCuenta,'')
END
FETCH NEXT FROM crActualizar INTO @ORenglon	, @ORenglonID, @OArticulo, @OSubCuenta, @OAlmacen, @OCantidad, @OCantidadA, @OProdSerieLote, @DRenglon, @DRenglonID, @DArticulo, @DSubCuenta, @DAlmacen, @DCantidad, @DCantidadA, @DProdSerieLote,@Centro, @CentroDestino
END
CLOSE crActualizar
DEALLOCATE crActualizar
DELETE FROM SerieLoteMovArrastre
FROM SerieLoteMovArrastre slma WITH(NOLOCK)  
JOIN @SerieLoteMovArrastre slma2 WITH(NOLOCK) 
ON slma.Empresa = slma2.Empresa
AND slma.Modulo = slma2.Modulo
AND slma.ID = slma2.ID
AND slma.RenglonID = slma2.RenglonID
AND slma.Articulo = slma2.Articulo
AND ISNULL(slma.SubCuenta,'') = ISNULL(slma2.SubCuenta,'')
AND slma.SerieLote = slma2.SerieLote
AND slma.CentroOrigen = slma2.CentroOrigen
AND ISNULL(slma.CentroDestino,'') = ISNULL(slma2.CentroDestino,'')
END
END

