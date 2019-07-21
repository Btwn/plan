SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSMostrarTarimas
@Estacion	int

AS BEGIN
DECLARE
@Empresa		varchar(5),
@ID				int,
@Modulo			varchar(10),
@ModuloID		int,
@Movimiento		varchar(50),
@RenglonID		int,
@Articulo		varchar(20),
@SubCuenta		varchar(50)
DELETE FROM WMSTarimaDisponible WHERE Estacion = @Estacion AND ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
DECLARE CrTarima CURSOR FOR
SELECT B.Empresa, B.ID, B.Modulo, B.ModuloID, B.Mov+' '+ISNULL(B.MovID,''), B.RenglonID, B.Articulo, B.SubCuenta
FROM ListaID A
JOIN WMSPedidosSinSurtir B
ON A.ID = B.ID
AND A.Estacion = B.Estacion
WHERE A.Estacion = @Estacion
OPEN CrTarima
FETCH NEXT FROM CrTarima INTO @Empresa, @ID, @Modulo, @ModuloID, @Movimiento, @RenglonID, @Articulo, @SubCuenta
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT WMSTarimaDisponible(Estacion, Empresa, ID, Modulo, ModuloID, Movimiento, Almacen,
Articulo, SubCuenta, Tarima, SerieLote, Disponible)
SELECT @Estacion, @Empresa, @ID, @Modulo, @ModuloID, @Movimiento, A.Almacen,
A.Articulo, ISNULL(B.SubCuenta,''), A.Tarima, ISNULL(B.SerieLote,''),
SUM(CASE WHEN ISNULL(B.Tarima,'') <> ''
THEN ISNULL(B.Existencia,0)-ISNULL(C.Apartado,0)
ELSE ISNULL(A.Disponible,0)-ISNULL(A.Apartado,0)
END)
FROM ArtDisponibleTarima A
JOIN Tarima T
ON A.Tarima = T.Tarima
JOIN AlmPos AP
ON T.Almacen = AP.Almacen
AND T.Posicion = AP.Posicion
LEFT JOIN SerieLote B
ON A.Tarima = B.Tarima
AND A.Articulo = B.Articulo
LEFT JOIN ArtApartadoTarimaSL C
ON A.Tarima = C.Tarima
AND A.Articulo = C.Articulo
AND B.SerieLote = C.SerieLote
WHERE A.Articulo = @Articulo
AND (CHARINDEX('-', A.Tarima)-1) < 0
AND AP.Tipo IN ('Domicilio','Ubicacion','Cross Docking')
GROUP BY A.Almacen, A.Articulo, ISNULL(B.SubCuenta,''), A.Tarima, B.SerieLote
HAVING SUM(CASE WHEN ISNULL(B.Tarima,'') <> ''
THEN ISNULL(B.Existencia,0)-ISNULL(C.Apartado,0)
ELSE ISNULL(A.Disponible,0)-ISNULL(A.Apartado,0)
END) > 0
FETCH NEXT FROM CrTarima INTO @Empresa, @ID, @Modulo, @ModuloID, @Movimiento, @RenglonID, @Articulo, @SubCuenta
END
CLOSE CrTarima
DEALLOCATE CrTarima
END

