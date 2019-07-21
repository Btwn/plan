SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTarimaAlta
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@Almacen	varchar(10),
@FechaRegistro	datetime,
@FechaCaducidad	datetime,
@Tarima		varchar(20),
@Ok		    int           	OUTPUT,
@OkRef		varchar(255)  	OUTPUT,
@PosicionCC varchar(50)     = null

AS BEGIN
DECLARE
@Articulo	 varchar(20), 
@SubCuenta   varchar(50),  
@Posicion    varchar(10),
@TPosiciones varchar(10),
@TTarima     varchar(20)
SELECT @Articulo  = Articulo,
@SubCuenta = SubCuenta,
@Posicion  = Posicion 
FROM Tarima
WHERE Tarima = @Tarima 
SELECT @TPosiciones = Posicion,
@TTarima     = Tarima
FROM Tarima
WHERE Articulo = @Articulo
AND Estatus = 'ALTA'
AND FechaCaducidad IS NULL
AND Posicion <> @Posicion
IF @FechaCaducidad IS NULL
SELECT @FechaCaducidad = FechaCaducidad FROM Tarima WHERE Tarima = @Tarima
IF @FechaRegistro IS NULL
SELECT @FechaRegistro = Alta FROM Tarima WHERE Tarima = @Tarima
UPDATE Tarima
SET Estatus = 'ALTA',
Alta = @FechaRegistro,
FechaCaducidad = @FechaCaducidad
WHERE Tarima = @Tarima
IF @@ROWCOUNT = 0
INSERT Tarima (
Tarima,  Almacen,  Posicion,           Estatus, Alta, Articulo, SubCuenta
) 
SELECT @Tarima, @Almacen, @PosicionCC /*DefPosicionRecibo*/, 'ALTA',   @FechaRegistro, @Articulo, @SubCuenta 
FROM Alm
WHERE Almacen = @Almacen
UPDATE Tarima
SET FechaCaducidad = @FechaCaducidad
WHERE Tarima = @TTarima
AND Posicion = @TPosiciones
AND Estatus = 'ALTA'
RETURN
END

