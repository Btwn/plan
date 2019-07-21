SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCRVenta
@CRID			int,
@Sucursal		int,
@Almacen		varchar(10),
@CRProcesoDistribuido	bit,
@CRServidorOperaciones	varchar(50),
@CRBaseDatosOperaciones	varchar(50),
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Cxc		bit,
@Renglon		float,
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Precio		float,
@DescuentoLinea	float,
@Importe		money,
@Operaciones	int,
@Cliente		varchar(10),
@ClienteEnviarA	int,
@Posicion		varchar(10),
@DescripcionExtra	varchar(100),
@Mov		varchar(20),
@MovID		varchar(20),
@CFDSerie   varchar(20), 
@CFDFolio	varchar(20), 
@SQL		nvarchar(4000),
@Params		nvarchar(4000)
SELECT @Renglon = 0.0
DECLARE crCRVenta CURSOR LOCAL FOR
SELECT Articulo, SubCuenta, Operaciones, ISNULL(NULLIF(RTRIM(Almacen), ''), @Almacen), Posicion, Cliente, ISNULL(Cxc, 0), Mov, MovID, Cantidad, DescuentoLinea, Importe, ISNULL(CFDSerie,''), ISNULL(CFDFolio,'') 
FROM #CRVenta2
OPEN crCRVenta
FETCH NEXT FROM crCRVenta INTO @Articulo, @SubCuenta, @Operaciones, @Almacen, @Posicion, @Cliente, @Cxc, @Mov, @MovID, @Cantidad, @DescuentoLinea, @Importe, @CFDSerie, @CFDFolio 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0
SELECT @SQL = N'EXEC '
IF @CRProcesoDistribuido = 1 SELECT @SQL = @SQL + @CRServidorOperaciones+'.'+@CRBaseDatosOperaciones+'.dbo.'
SELECT @SQL = @SQL + N'spInsertarCRVenta @CRID, @Sucursal, @Renglon, @Articulo, @SubCuenta, @Operaciones, @Almacen, @Posicion, @Cliente, @Cxc, @Mov, @MovID, @Cantidad, @DescuentoLinea, @Importe, @CFDSerie, @CFDFolio, @Ok OUTPUT, @OkRef OUTPUT' 
SELECT @Params = N'@CRID int, @Sucursal int, @Renglon float, @Articulo varchar(20), @SubCuenta varchar(50), @Operaciones int, @Almacen varchar(10), @Posicion varchar(10), @Cliente varchar(10), @Cxc bit, @Mov varchar(20), @MovID varchar(20), @Cantidad float, @DescuentoLinea float, @Importe money, @CFDSerie varchar(20), @CFDFolio varchar(20), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT' 
EXEC sp_executesql @SQL, @Params, @CRID, @Sucursal, @Renglon, @Articulo, @SubCuenta, @Operaciones, @Almacen, @Posicion, @Cliente, @Cxc, @Mov, @MovID, @Cantidad, @DescuentoLinea, @Importe, @CFDSerie, @CFDFolio, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crCRVenta INTO @Articulo, @SubCuenta, @Operaciones, @Almacen, @Posicion, @Cliente, @Cxc, @Mov, @MovID, @Cantidad, @DescuentoLinea, @Importe, @CFDSerie, @CFDFolio 
END 
CLOSE crCRVenta
DEALLOCATE crCRVenta
RETURN
END

