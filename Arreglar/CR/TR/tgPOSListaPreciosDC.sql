SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSListaPreciosDC ON ListaPreciosD

FOR UPDATE
AS BEGIN
DECLARE
@Articulo            varchar(20),
@SubCuenta           varchar(50),
@ListaPrecios        varchar(20),
@PrecioAnterior      float,
@Precio              float,
@Unidad              varchar(50)
DECLARE crLista CURSOR local FOR
SELECT i.Articulo,   i.Lista,  i.Precio, d.Precio
FROM INSERTED i
JOIN  DELETED d ON d.Lista= i.Lista AND  d.Moneda= i.Moneda AND d.Articulo = i.Articulo
WHERE d.Precio <> i.Precio
OPEN crLista
FETCH NEXT FROM crLista INTO @Articulo, @ListaPrecios, @Precio, @PrecioAnterior
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT POSAuxiliarArtPrecio(Articulo,  SubCuenta,             Fecha,      ListaPrecios, PrecioAnterior,  Precio, Unidad)
SELECT                      @Articulo, ISNULL(@SubCuenta,''), GETDATE(), @ListaPrecios, @PrecioAnterior ,@Precio, @Unidad
FETCH NEXT FROM crLista INTO @Articulo,  @ListaPrecios, @Precio, @PrecioAnterior
END
CLOSE crLista
DEALLOCATE crLista
RETURN
END

