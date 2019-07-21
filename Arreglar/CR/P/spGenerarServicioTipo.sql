SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarServicioTipo
@ID			int,
@Empresa		char(5),
@Sucursal		int,
@Almacen		char(10),
@ListaPreciosEsp	varchar(50),
@ServicioTipo		varchar(50),
@MovMoneda		char(10),
@MovTipoCambio		float,
@FechaRequerida		datetime

AS BEGIN
DECLARE
@Ok			int,
@OkRef		varchar(255),
@Renglon		float,
@RenglonID		int,
@Articulo		char(20),
@SubCuenta		varchar(50),
@Precio		float,
@Cantidad		float,
@Unidad		varchar(50),
@ArtTipo		varchar(20),
@RenglonTipo	char(1),
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		money,
@ZonaImpuesto	varchar(50),
@ListaPrecios	varchar(50),
@FechaEmision	datetime,
@Contacto		varchar(10),
@EnviarA		int,
@Mov		varchar(20),
@Factor             float
SELECT @Renglon = 0.0, @RenglonID = 0
DELETE VentaD WHERE ID = @ID
SELECT @Mov = Mov, @ZonaImpuesto = ZonaImpuesto, @FechaEmision = FechaEmision, @Contacto = Cliente, @EnviarA = EnviarA
FROM Venta
WHERE ID = @ID
DECLARE crPlantilla CURSOR FOR
SELECT p.Articulo, p.SubCuenta, p.Cantidad, ISNULL(NULLIF(RTRIM(p.AlmacenEsp), ''), @Almacen), ISNULL(NULLIF(RTRIM(p.ListaPreciosEsp), ''), @ListaPreciosEsp), a.Unidad, a.Tipo, a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM ServicioTipoPlantilla p, Art a
WHERE p.Tipo = @ServicioTipo AND p.Articulo = a.Articulo
ORDER BY Orden
OPEN crPlantilla
FETCH NEXT FROM crPlantilla INTO @Articulo, @SubCuenta, @Cantidad, @Almacen, @ListaPrecios, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon   = @Renglon + 2048.0,
@RenglonID = @RenglonID + 1,
@Precio    = NULL
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @MovMoneda, @MovTipoCambio, @ListaPrecios, @Precio OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'VTAS', @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@Unidad)
INSERT VentaD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  Unidad,  Precio,  Almacen,  FechaRequerida,  Impuesto1,  Impuesto2,  Impuesto3)
VALUES (@ID, @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Precio, @Almacen, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3*@Factor)
IF UPPER(@ArtTipo) = 'JUEGO'
EXEC spInsertarJuegoOmision @Empresa, @Sucursal, @ID, @Articulo, @Cantidad, @Almacen, @FechaRequerida, @MovMoneda, @MovTipoCambio, @Renglon OUTPUT, @RenglonID OUTPUT
END
FETCH NEXT FROM crPlantilla INTO @Articulo, @SubCuenta, @Cantidad, @Almacen, @ListaPrecios, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3
END
CLOSE crPlantilla
DEALLOCATE crPlantilla
UPDATE Venta SET RenglonID = @RenglonID WHERE ID = @ID
RETURN
END

