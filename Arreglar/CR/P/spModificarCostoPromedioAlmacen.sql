SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spModificarCostoPromedioAlmacen
@Empresa	char(5),
@Usuario	char(10),
@Lista		varchar(20),
@Estacion	int,
@Almacen	char(10),
@FechaEmision	datetime,
@AjusteMov	char(20),
@Moneda		char(10),
@TipoCambio	float,
@Factor		float,
@Conteo		int		OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Sucursal		int,
@Renglon		float,
@RenglonID		int,
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Unidad		varchar(50),
@ArtTipo		varchar(20),
@RenglonTipo	char(1),
@AjusteID		int,
@AjusteMovID	varchar(20),
@FechaRegistro	datetime,
@Costo		float,
@Referencia		varchar(50),
@Tarima		varchar(20)
IF EXISTS(SELECT * FROM ArtReservado ar, ListaSt l WHERE ar.Empresa = @Empresa AND ar.Almacen = @Almacen AND ISNULL(ar.Reservado, 0) <> 0 AND l.Estacion = @Estacion AND l.Clave = ar.Articulo)
BEGIN
SELECT @Ok = 20980, @OkRef = @Almacen
RETURN
END
IF @Factor = -1 SELECT @Referencia = 'Salida' ELSE SELECT @Referencia = 'Entrada'
INSERT Inv (Empresa,  Usuario,  Estatus,     Mov,        FechaEmision,  Referencia,  Moneda,  TipoCambio,  Almacen,  Directo, VerLote)
VALUES (@Empresa, @Usuario, 'CONFIRMAR', @AjusteMov, @FechaEmision, @Referencia, @Moneda, @TipoCambio, @Almacen, 0, 1)
SELECT @AjusteID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
DECLARE crAjuste CURSOR FOR
SELECT e.Articulo, e.SubCuenta, e.Tarima, ISNULL(e.Inventario, 0.0)*@Factor, a.Unidad, a.Tipo
FROM ArtSubExistenciaInvTarima e, Art a, ListaSt l
WHERE e.Articulo = a.Articulo AND e.Empresa = @Empresa AND e.Almacen = @Almacen
AND l.Estacion = @Estacion AND l.Clave = a.Articulo
OPEN crAjuste
FETCH NEXT FROM crAjuste INTO @Articulo, @SubCuenta, @Tarima, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad <> 0.0
BEGIN
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon   = @Renglon + 2048, @RenglonID = @RenglonID + 1, @Costo = NULL
IF @Factor = 1
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @Moneda, @TipoCambio, @Lista, @Costo OUTPUT
INSERT INTO InvD (Sucursal,  ID,        Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad, Almacen,  Tarima,  Costo)
VALUES (@Sucursal, @AjusteID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @Cantidad,          @Unidad, @Almacen, @Tarima, @Costo)
IF UPPER(@ArtTipo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
INSERT INTO SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @Empresa, 'INV', @AjusteID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), SerieLote, Existencia
FROM SerieLote
WHERE Sucursal = @Sucursal
AND Empresa = @Empresa
AND Articulo = @Articulo
AND SubCuenta = ISNULL(@SubCuenta, '')
AND Almacen = @Almacen
AND Tarima = @Tarima
AND ISNULL(Existencia, 0) > 0
END
FETCH NEXT FROM crAjuste INTO @Articulo, @SubCuenta, @Tarima, @Cantidad, @Unidad, @ArtTipo
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crAjuste
DEALLOCATE crAjuste
IF @RenglonID > 0
BEGIN
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @AjusteID
SELECT @FechaRegistro = GETDATE()
/*EXEC spInv @AjusteID, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@AjusteMov, @AjusteMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0*/
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END ELSE
DELETE Inv WHERE ID = @AjusteID
RETURN
END

