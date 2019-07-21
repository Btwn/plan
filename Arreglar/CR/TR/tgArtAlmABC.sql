SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtAlmABC
ON ArtAlm

FOR  INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @Empresa	VARCHAR(5),
@Articulo	VARCHAR(20),
@SubCuenta	VARCHAR(50),
@Almacen	VARCHAR(10)
DECLARE crArtAlmMES CURSOR FOR
SELECT Empresa, Articulo, SubCuenta, Almacen
FROM INSERTED
OPEN crArtAlmMES
FETCH crArtAlmMES INTO @Empresa, @Articulo, @SubCuenta, @Almacen
WHILE (@@FETCH_STATUS = 0)
BEGIN
DELETE FROM ArtAlmMES
WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen
FETCH crArtAlmMES INTO @Empresa, @Articulo, @SubCuenta, @Almacen
END
CLOSE crArtAlmMES
DEALLOCATE crArtAlmMES
INSERT INTO ArtAlmMES(Empresa, Articulo, Almacen, Minimo, Maximo, PuntoOrden, PuntoOrdenOrdenar, LoteOrdenar, CantidadOrdenar, MultiplosOrdenar, SubCuenta)
SELECT Empresa, Articulo, Almacen, Minimo, Maximo, PuntoOrden, PuntoOrdenOrdenar, LoteOrdenar, CantidadOrdenar, MultiplosOrdenar, SubCuenta
FROM   INSERTED
UPDATE ArtMES SET EstatusIntelIMES = 0 WHERE Articulo IN (SELECT Articulo FROM INSERTED)
UPDATE Art SET TieneMovimientos = 1 WHERE Articulo IN (SELECT Articulo FROM INSERTED)
END

