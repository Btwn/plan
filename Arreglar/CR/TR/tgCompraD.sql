SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCompraD
ON CompraD
FOR INSERT, UPDATE
AS
BEGIN
DECLARE
@ID			int,
@Cantidad	float,
@Estatus	varchar(15),
@Articulo	varchar(20),
@Mensaje	varchar(255)
SELECT @ID = ID,@Articulo = Articulo,@Cantidad = Cantidad FROM Inserted
SELECT @Estatus = Estatus FROM Compra WHERE ID = @ID
IF @ID IS NOT NULL AND @Estatus = 'CONFIRMAR' AND NULLIF(@Cantidad,'') IS NULL
BEGIN
SELECT @Mensaje = 'No se pueden Guardar Cambios en un Movimiento con Estatus Por Confirmar. Articulo: ' + RTRIM(@Articulo)
RAISERROR(@Mensaje , 16, -1)
RETURN
END
RETURN
END

