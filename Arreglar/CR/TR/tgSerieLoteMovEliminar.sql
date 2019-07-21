SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSerieLoteMovEliminar ON SerieLoteMov

FOR DELETE
AS BEGIN
DECLARE
@Modulo 	char(5),
@Sucursal  	int,
@ID     	int,
@Estatus	char(15),
@Mensaje 	char(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Estatus = NULL
SELECT @Modulo = MIN(Modulo), @Sucursal = MIN(Sucursal) , @ID = MIN(ID) FROM Deleted
IF @Modulo = 'VTAS' SELECT @Estatus = Estatus FROM Venta  WHERE Sucursal = @Sucursal AND ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Estatus = Estatus FROM Compra WHERE Sucursal = @Sucursal AND ID = @ID ELSE
IF @Modulo = 'INV'  SELECT @Estatus = Estatus FROM Inv    WHERE Sucursal = @Sucursal AND ID = @ID ELSE
IF @Estatus NOT IN (NULL, 'SINAFECTAR', 'CONFIRMAR')
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 30330
RAISERROR (@Mensaje,16,-1)
END
END

