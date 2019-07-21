SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvFusionarBorradores
@Estacion		int

AS BEGIN
DECLARE
@ID		    int,
@Renglon	float,
@RenglonID  int,
@Almacen    varchar(10),
@WMS        bit,
@Ok         int,
@OkRef      varchar(255)
SELECT @Renglon = 0.0
SELECT @ID = MIN(ID) FROM ListaID WHERE Estacion = @Estacion
SELECT @Almacen = Almacen
FROM Inv
WHERE ID = @ID
SELECT @WMS = WMS
FROM Alm
WHERE Almacen = @Almacen
CREATE TABLE #Borrador (
ID			        int		    NOT NULL IDENTITY(1, 1) PRIMARY KEY,
Renglon			    float		NULL,
RenglonID		    int			NULL,
Articulo		    char(20)	COLLATE Database_Default NULL,
SubCuenta		    varchar(20)	COLLATE Database_Default NULL,
Unidad			    varchar(50)	COLLATE Database_Default NULL,
Almacen			    char(10)	COLLATE Database_Default NULL,
Cantidad		    float		NULL,
CantidadInventario	float		NULL,
Tarima              varchar(20) NULL,
PosicionActual      varchar(10) NULL,
PosicionReal        varchar(10) NULL
)
IF ISNULL(@WMS,0) = 0
BEGIN
INSERT #Borrador (Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario)
SELECT d.Articulo, d.SubCuenta, d.Unidad, i.Almacen, "Cantidad" = SUM(d.Cantidad), "CantidadInventario" = SUM(d.CantidadInventario)
FROM Inv i
JOIN InvD d ON i.ID = d.ID
JOIN ListaID l ON i.ID = l.ID AND l.Estacion = @Estacion
GROUP BY d.Articulo, d.SubCuenta, d.Unidad, i.Almacen
ORDER BY d.Articulo, d.SubCuenta, d.Unidad, i.Almacen
END
IF ISNULL(@WMS,0) = 1
BEGIN
INSERT #Borrador (Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario, Tarima, PosicionActual, PosicionReal)
SELECT d.Articulo, d.SubCuenta, d.Unidad, i.Almacen, "Cantidad" = SUM(d.Cantidad), "CantidadInventario" = SUM(d.CantidadInventario), d.Tarima, d.PosicionActual, d.PosicionReal
FROM Inv i
JOIN InvD d ON i.ID = d.ID
JOIN ListaID l ON i.ID = l.ID AND l.Estacion = @Estacion
GROUP BY d.Articulo, d.SubCuenta, d.Unidad, i.Almacen, d.Tarima, d.PosicionActual, d.PosicionReal
ORDER BY d.Articulo, d.SubCuenta, d.Unidad, i.Almacen, d.Tarima, d.PosicionActual, d.PosicionReal
END
IF @Ok IS NULL
BEGIN
UPDATE #Borrador SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048.0
UPDATE #Borrador SET @RenglonID = RenglonID = ISNULL(RenglonID, 0) + @RenglonID + 1
DELETE InvD WHERE ID = @ID
END
IF @Ok IS NULL AND @WMS = 0
BEGIN
INSERT InvD (ID,  Renglon, RenglonID, Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario)
SELECT @ID, Renglon, RenglonID, Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario
FROM #Borrador
DELETE InvD WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
DELETE Inv  WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
SELECT @OkRef = CONVERT(varchar, COUNT(*))+ ' Movimientos Fusionados.'
FROM ListaID
WHERE Estacion = @Estacion
END
IF @Ok IS NULL AND @WMS = 1
BEGIN
INSERT InvD (ID,  Renglon, RenglonID, Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario, Tarima, PosicionActual, PosicionReal)
SELECT @ID, Renglon, RenglonID, Articulo, SubCuenta, Unidad, Almacen, Cantidad, CantidadInventario, Tarima, PosicionActual, PosicionReal
FROM #Borrador
DELETE InvD WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
DELETE Inv  WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
SELECT @OkRef = CONVERT(varchar, COUNT(*))+ ' Movimientos Fusionados.'
FROM ListaID
WHERE Estacion = @Estacion
END
SELECT @OkRef
RETURN
END

