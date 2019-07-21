SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaActualizaDevolucion
@RId		int,
@Eliminar	int

AS BEGIN
DECLARE @ID					int,
@VentaDRenglon			float,
@VentaDRenglonID		int,
@Cantidad				float,
@Articulo				varchar(20),
@Almacen				varchar(10),
@Empresa				varchar(5),
@Clave					varchar(20)
SELECT @Clave = mt.Clave
FROM Venta v
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE v.ID = @RId
IF @Clave = 'VTAS.D'
BEGIN
UPDATE VentaDevolucion SET Estatus = 1 WHERE id = @RId
DECLARE crVentaCteD CURSOR FOR
SELECT d.ID, d.Renglon, d.RenglonID, d.Cantidad, d.Articulo, d.Almacen, v.Empresa
FROM Venta v
INNER JOIN VentaD d ON v.ID = d.ID
WHERE v.ID = @RId
OPEN crVentaCteD
FETCH NEXT FROM crVentaCteD INTO @ID, @VentaDRenglon, @VentaDRenglonID, @Cantidad, @Articulo, @Almacen, @Empresa
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS (SELECT * FROM VentaDevolucion WHERE ID = @ID AND RenglonRID = @VentaDRenglon AND Articulo = @Articulo)
UPDATE VentaDevolucion SET Estatus = 0 WHERE ID = @ID AND RenglonRID = @VentaDRenglon AND Articulo = @Articulo
FETCH NEXT FROM crVentaCteD INTO @ID, @VentaDRenglon, @VentaDRenglonID, @Cantidad, @Articulo, @Almacen, @Empresa
END
CLOSE crVentaCteD
DEALLOCATE crVentaCteD
DELETE VentaDevolucion WHERE Estatus = 1 AND id = @RId
END
IF @Eliminar = 1
DELETE VentaDevolucion WHERE ID = @RId
END

