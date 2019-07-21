SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvReciboTraspaso
@Empresa	char(5),
@Usuario	char(10),
@Sucursal	int,
@Estacion	int,
@Fecha		datetime,
@ID             int
AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Conteo			int,
@Mov			char(20),
@MovID			varchar(20),
@MovReciboTraspaso		char(20),
@MovTransitoFaltante	char(20),
@MovTransitoSobrante	char(20),
@Almacen			char(10),
@AlmacenDestino		char(10),
@GenerarID			int,
@Renglon			float,
@RenglonID			int,
@Datos			varchar(255),
@Dato			varchar(255),
@Articulo			char(20),
@ArtTipo			varchar(20),
@RenglonTipo		char(1),
@SubCuenta			varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@Precio			money,
@Costo			money,
@CantidadRecibida		float,
@CantidadTransito		float,
@Unidad			varchar(50),
@Ok				int,
@OkRef			varchar(255),
@Mensaje			varchar(255),
@TransitoSucursal		int
SELECT @Conteo = 0
SELECT @MovReciboTraspaso = InvReciboTraspaso,
@MovTransitoFaltante = InvTransitoFaltante,
@MovTransitoSobrante = InvTransitoSobrante
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Mov = Mov,
@MovID = MovID,
@Almacen = Almacen,
@AlmacenDestino = AlmacenDestino,
@TransitoSucursal = Sucursal
FROM Inv
WHERE ID = @ID
UPDATE InvD SET Almacen = @AlmacenDestino WHERE ID = @ID AND Almacen <> @AlmacenDestino
CREATE TABLE #Recibo (
Articulo 		char(20) 	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Unidad			varchar(50)	COLLATE Database_Default NULL,
Precio			money		NULL,
Costo			money		NULL,
CantidadTransito	float		NULL,
CantidadRecibida	float		NULL)
INSERT #Recibo (Articulo, SubCuenta, Unidad, Precio, Costo, CantidadTransito)
SELECT Articulo, SubCuenta, Unidad, Precio, Costo, SUM(CantidadPendiente)
FROM InvD
WHERE ID = @ID
GROUP BY Articulo, SubCuenta, Unidad, Precio, Costo
DECLARE crListaDatos CURSOR FOR
SELECT CONVERT(varchar(255), Datos)
FROM ListaDatos
WHERE Estacion = @Estacion
ORDER BY ID
OPEN crListaDatos
FETCH NEXT FROM crListaDatos INTO @Datos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Dato OUTPUT, ','
EXEC spQuitarEntreComillas @Dato OUTPUT
SELECT @Articulo = @Dato
EXEC spExtraerDato @Datos OUTPUT, @Dato OUTPUT, ','
EXEC spQuitarEntreComillas @Dato OUTPUT
SELECT @Cantidad = CONVERT(float, @Dato)/100
EXEC spExtraerDato @Datos OUTPUT, @Dato OUTPUT, ','
EXEC spQuitarEntreComillas @Dato OUTPUT
SELECT @SubCuenta = NULLIF(RTRIM(@Dato), '')
UPDATE #Recibo
SET CantidadRecibida = ISNULL(CantidadRecibida, 0.0) + ISNULL(@Cantidad, 0.0)
WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
IF @@ROWCOUNT = 0
INSERT #Recibo (
Articulo,  SubCuenta,  Unidad, CantidadRecibida)
SELECT @Articulo, @SubCuenta, Unidad, @Cantidad
FROM Art
WHERE Articulo = @Articulo
END
FETCH NEXT FROM crListaDatos INTO @Datos
END 
CLOSE crListaDatos
DEALLOCATE crListaDatos
UPDATE #Recibo SET CantidadRecibida = ISNULL(CantidadRecibida, 0.0), CantidadTransito = ISNULL(CantidadTransito, 0.0)
IF EXISTS(SELECT * FROM #Recibo WHERE CantidadRecibida > 0.0 AND CantidadTransito > 0.0)
BEGIN
SELECT @Conteo = @Conteo + 1
INSERT Inv (
Empresa,  Mov,                Usuario,  FechaEmision, Estatus,     Almacen,  AlmacenDestino,  SucursalOrigen,    Sucursal,          Directo, Moneda, TipoCambio, Proyecto, UEN, Referencia, OrigenTipo, Origen, OrigenID)
SELECT @Empresa, @MovReciboTraspaso, @Usuario, @Fecha,       'CONFIRMAR', @Almacen, @AlmacenDestino, @TransitoSucursal, @TransitoSucursal, 0,       Moneda, TipoCambio, Proyecto, UEN, Referencia, 'INV',      Mov,    MovID
FROM Inv
WHERE ID = @ID
SELECT @GenerarID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
DECLARE crRecibo CURSOR FOR
SELECT Articulo, SubCuenta, Unidad, Precio, Costo, CantidadTransito, CantidadRecibida
FROM #Recibo
WHERE CantidadRecibida > 0.0 AND CantidadTransito > 0.0
OPEN crRecibo
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @CantidadRecibida > @CantidadTransito SELECT @Cantidad = @CantidadTransito ELSE SELECT @Cantidad = @CantidadRecibida
IF @Cantidad > 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT InvD (
ID,         Aplica, AplicaID, Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad,  Precio,  Costo,  Almacen,  SucursalOrigen,    Sucursal)
VALUES (@GenerarID, @Mov,   @MovID,   @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Unidad, @Precio, @Costo, @Almacen, @TransitoSucursal, @TransitoSucursal)
END
END
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
END 
CLOSE crRecibo
DEALLOCATE crRecibo
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @GenerarID
END
IF EXISTS(SELECT * FROM #Recibo WHERE CantidadTransito > CantidadRecibida)
BEGIN
SELECT @Conteo = @Conteo + 1
INSERT Inv (
Empresa,  Mov,                  Usuario,  FechaEmision, Estatus,     Almacen,  AlmacenDestino,  SucursalOrigen,    Sucursal,          Directo, Moneda, TipoCambio, Proyecto, UEN, Referencia, OrigenTipo, Origen, OrigenID)
SELECT @Empresa, @MovTransitoFaltante, @Usuario, @Fecha,       'CONFIRMAR', @Almacen, @AlmacenDestino, @TransitoSucursal, @TransitoSucursal, 0,       Moneda, TipoCambio, Proyecto, UEN, Referencia, 'INV',      Mov,    MovID
FROM Inv
WHERE ID = @ID
SELECT @GenerarID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
DECLARE crRecibo CURSOR FOR
SELECT Articulo, SubCuenta, Unidad, Precio, Costo, CantidadTransito, CantidadRecibida
FROM #Recibo
WHERE CantidadTransito > CantidadRecibida
OPEN crRecibo
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cantidad = @CantidadTransito - @CantidadRecibida
IF @Cantidad > 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT InvD (
ID,         Aplica, AplicaID, Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad,  Precio,  Costo,  Almacen,         SucursalOrigen,    Sucursal)
VALUES (@GenerarID, @Mov,   @MovID,   @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Unidad, @Precio, @Costo, @AlmacenDestino, @TransitoSucursal, @TransitoSucursal)
END
END
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
END 
CLOSE crRecibo
DEALLOCATE crRecibo
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @GenerarID
END
IF EXISTS(SELECT * FROM #Recibo WHERE CantidadTransito < CantidadRecibida)
BEGIN
SELECT @Conteo = @Conteo + 1
INSERT Inv (
Empresa,  Mov,                  Usuario,  FechaEmision, Estatus,     Almacen,  AlmacenDestino,  SucursalOrigen,    Sucursal,          Directo, Moneda, TipoCambio, Proyecto, UEN, Referencia, OrigenTipo, Origen, OrigenID)
SELECT @Empresa, @MovTransitoSobrante, @Usuario, @Fecha,       'CONFIRMAR', @Almacen, @AlmacenDestino, @TransitoSucursal, @TransitoSucursal, 0,       Moneda, TipoCambio, Proyecto, UEN, Referencia, 'INV',      Mov,    MovID
FROM Inv
WHERE ID = @ID
SELECT @GenerarID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
DECLARE crRecibo CURSOR FOR
SELECT Articulo, SubCuenta, Unidad, Precio, Costo, CantidadTransito, CantidadRecibida
FROM #Recibo
WHERE CantidadTransito < CantidadRecibida
OPEN crRecibo
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cantidad = @CantidadRecibida - @CantidadTransito
IF @Cantidad > 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT InvD (
ID,         Aplica, AplicaID, Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad,  Precio,  Costo,  Almacen,         SucursalOrigen,    Sucursal)
VALUES (@GenerarID, @Mov,   @MovID,   @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Unidad, @Precio, @Costo, @AlmacenDestino, @TransitoSucursal, @TransitoSucursal)
END
END
FETCH NEXT FROM crRecibo INTO @Articulo, @SubCuenta, @Unidad, @Precio, @Costo, @CantidadTransito, @CantidadRecibida
END 
CLOSE crRecibo
DEALLOCATE crRecibo
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @GenerarID
END
IF @Ok IS NULL
SELECT @Mensaje = 'Se Generaron '+CONVERT(varchar, @Conteo)+' Movimientos por Confirmar.'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

