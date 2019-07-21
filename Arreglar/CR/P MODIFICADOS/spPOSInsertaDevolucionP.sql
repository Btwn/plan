SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertaDevolucionP
@ID			varchar(50),
@Mov		varchar(50)

AS
BEGIN
DECLARE
@IDDevolucion					varchar(36),
@Articulo						varchar(20),
@Renglon						float,
@CantidadM						float,
@Cantidad						float,
@UsuarioAutoriza				varchar(10),
@Empresa						varchar(5),
@CfgMultiUnidades				bit,
@CfgVentaFactorDinamico			bit,
@CfgNivelFactorMultiUnidad		varchar(20),
@Unidad							varchar(50),
@UnidadFactor					float
SELECT @Empresa = Empresa FROM POSL WITH(NOLOCK) WHERE ID = @ID
SELECT
@CfgMultiUnidades			= ISNULL(MultiUnidades,0),
@CfgVentaFactorDinamico		= ISNULL(VentaFactorDinamico,0),
@CfgNivelFactorMultiUnidad	= ISNULL(NivelFactorMultiUnidad,0)
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @Mov <> 'NOTA'
BEGIN
UPDATE POSLVenta WITH(ROWLOCK) SET Cantidad = CantidadM, Observaciones = 'Aplico Devolucion' WHERE ID = @ID
DELETE POSLVenta WHERE ID = @ID AND CantidadM IS NULL
SELECT @IDDevolucion = IDDevolucion FROM POSL WITH(NOLOCK) WHERE ID = @ID
UPDATE POSL WITH(ROWLOCK) SET Devolucion = 0 WHERE ID = @IDDevolucion
BEGIN
DECLARE crDev CURSOR LOCAL FOR
SELECT Articulo, Renglon, CantidadM
FROM POSLVenta
WHERE ID = @ID
OPEN crDev
FETCH NEXT FROM crDev INTO @Articulo, @Renglon, @CantidadM
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @CantidadM > = 0 AND @Mov <> 'NOTA'
BEGIN
UPDATE POSLVenta WITH(ROWLOCK) SET Observaciones = 'Aplico Devolucion', CantidadM = ISNULL(CantidadM,0)+@CantidadM*-1
WHERE ID = @IDDevolucion AND Articulo = @Articulo AND Renglon = @Renglon
UPDATE POSLVenta WITH(ROWLOCK) SET Cantidad = Cantidad *-1, CantidadM = CantidadM *-1
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon
END
ELSE
UPDATE POSLVenta WITH(ROWLOCK) SET Observaciones = 'Aplico Devolucion', CantidadM = ISNULL(CantidadM,0)+@CantidadM
WHERE ID = @IDDevolucion AND Articulo = @Articulo AND Renglon = @Renglon
END
FETCH NEXT FROM crDev INTO @Articulo, @Renglon, @CantidadM
END
CLOSE crDev
DEALLOCATE crDev
END
END
IF @Mov = 'NOTA'
BEGIN
SELECT @Articulo = NULL, @Renglon = NULL, @CantidadM = NULL, @Cantidad = NULL, @Unidad = NULL
SELECT @UsuarioAutoriza = UsuarioAutoriza
FROM POSL WITH(NOLOCK)
WHERE ID = @ID
DECLARE crDev CURSOR LOCAL FOR
SELECT Articulo, Renglon, CantidadM, Cantidad, Unidad
FROM POSLVenta
WHERE ID = @ID
AND ISNULL(CantidadM,0) <> 0
OPEN crDev
FETCH NEXT FROM crDev INTO @Articulo, @Renglon, @CantidadM, @Cantidad, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @CantidadM > = 0
BEGIN
SET @UnidadFactor = NULL
IF @CfgMultiUnidades = 1 OR @CfgVentaFactorDinamico = 1
BEGIN
EXEC spUnidadFactor @Empresa, @Articulo, NULL, @Unidad, @UnidadFactor OUTPUT
IF @UnidadFactor IS NULL
SET @UnidadFactor = 1
END
UPDATE POSLVenta WITH(ROWLOCK)
SET Cantidad			= CantidadM,
CantidadInventario	= CASE WHEN @CfgMultiUnidades = 1 OR @CfgVentaFactorDinamico = 1 THEN CantidadM * @UnidadFactor ELSE NULL END,
Observaciones		= 'Cantidad Original:'+CONVERT(varchar, @Cantidad)+' '+'Modificada por: '+@UsuarioAutoriza
WHERE ID = @ID AND Articulo = @Articulo AND Renglon = @Renglon
END
FETCH NEXT FROM crDev INTO @Articulo, @Renglon, @CantidadM, @Cantidad, @Unidad
END
CLOSE crDev
DEALLOCATE crDev
UPDATE POSLVenta WITH(ROWLOCK) SET CantidadM = NULL  WHERE ID = @ID
END
END

