SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSListaPreciosSubUnidadC ON ListaPreciosSubUnidad

FOR UPDATE
AS BEGIN
DECLARE
@Articulo            varchar(20),
@SubCuenta           varchar(50),
@Unidad              varchar(50),
@ListaPrecios        varchar(20),
@PrecioAnterior      float,
@Precio              float
DECLARE crLista CURSOR local FOR
SELECT i.Articulo, ISNULL(i.SubCuenta,''),  i.Lista,  i.Precio, d.Precio, i.Unidad
FROM INSERTED i
JOIN  DELETED d ON d.Lista= i.Lista AND  d.Moneda= i.Moneda AND d.Articulo = i.Articulo AND d.SubCuenta = i.SubCuenta AND d.Unidad = i.Unidad
WHERE d.Precio <> i.Precio
OPEN crLista
FETCH NEXT FROM crLista INTO @Articulo, @SubCuenta, @ListaPrecios, @Precio, @PrecioAnterior, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT POSAuxiliarArtPrecio(Articulo,  SubCuenta,Fecha,      ListaPrecios, PrecioAnterior,  Precio, Unidad)
SELECT                      @Articulo, @SubCuenta,GETDATE(), @ListaPrecios, @PrecioAnterior ,@Precio, @Unidad
FETCH NEXT FROM crLista INTO @Articulo, @SubCuenta, @ListaPrecios, @Precio, @PrecioAnterior , @Unidad
END
CLOSE crLista
DEALLOCATE crLista
RETURN
END

