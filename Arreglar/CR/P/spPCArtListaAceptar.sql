SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCArtListaAceptar
@Estacion	int,
@ID		int,
@ArticuloEsp varchar(20) = NULL

AS BEGIN
DECLARE
@p                  	int,
@Sucursal			int,
@Empresa			char(5),
@Moneda			char(10),
@TipoCambio			float,
@ListaModificar		varchar(20),
@ListaModificarD		varchar(20),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Precio			float,
@Renglon			float,
@CfgPrecioNivelUnidad	bit,
@CfgListaModificarDetalle	bit,
@Monto			float,
@PC_H2			bit
SELECT @Sucursal       = Sucursal,
@Empresa        = Empresa,
@Moneda         = Moneda,
@TipoCambio	 = TipoCambio,
@ListaModificar = ListaModificar,
@Monto          = Monto
FROM PC
WHERE ID = @ID
SELECT @CfgListaModificarDetalle = ISNULL(PCListaModificarDetalle, 0),
@CfgPrecioNivelUnidad = ISNULL(PrecioNivelUnidad, 0),
@PC_H2	= ISNULL(PC_H2, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgListaModificarDetalle = 1 SELECT @ListaModificarD = @ListaModificar ELSE SELECT @ListaModificarD = NULL
SELECT @Renglon = 0.0
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0) FROM PCD WHERE ID = @ID
IF @Estacion > 0
BEGIN
BEGIN TRANSACTION
DECLARE crLista CURSOR LOCAL FOR
SELECT Clave
FROM ListaSt l
ORDER BY ID
OPEN crLista
FETCH NEXT FROM crLista INTO @Articulo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @SubCuenta = NULL
SELECT @p = CHARINDEX(CHAR(9), @Articulo)
IF @p>0
SELECT @SubCuenta = NULLIF(RTRIM(SUBSTRING(@Articulo, @p+1, LEN(@Articulo))), ''),
@Articulo  = NULLIF(RTRIM(SUBSTRING(@Articulo, 1, @p-1)), '')
IF @PC_H2 = 1
INSERT PCD (ID,  Renglon,                                              Articulo,  SubCuenta,                       Unidad,                     Monto,  ListaModificar)
SELECT @ID, @Renglon+ROW_NUMBER() OVER (order by ListaModificar), @Articulo, ISNULL(s.SubCuenta, @SubCuenta), ISNULL(u.Unidad, a.Unidad), @Monto, ISNULL(lm.ListaModificar, @ListaModificarD)
FROM Art a
LEFT OUTER JOIN ArtUnidad u ON u.Articulo = a.Articulo
LEFT OUTER JOIN ArtSub s ON s.Articulo = a.Articulo
LEFT OUTER JOIN PCListaModificar lm ON lm.ID = @ID
WHERE a.Articulo = @Articulo
ELSE
IF @CfgPrecioNivelUnidad = 1
BEGIN
/*IF EXISTS(SELECT * FROM ArtUnidad WHERE Articulo = @Articulo)
INSERT PCD (ID,  Renglon,  Articulo, Unidad)
SELECT @ID, @Renglon, @Articulo, Unidad
FROM ArtUnidad
WHERE Articulo = @Articulo
ELSE*/
INSERT PCD (ID,  Renglon,                                              Articulo,  SubCuenta,  Unidad,   Monto,  ListaModificar)
SELECT @ID, @Renglon+ROW_NUMBER() OVER (order by ListaModificar), @Articulo, @SubCuenta, a.Unidad, @Monto, ISNULL(lm.ListaModificar, @ListaModificarD)
FROM Art a
LEFT OUTER JOIN PCListaModificar lm ON lm.ID = @ID
WHERE a.Articulo = @Articulo
END ELSE
BEGIN
IF EXISTS(SELECT * FROM PCListaModificar WHERE ID = @ID)
INSERT PCD (
ID,  Renglon,                                             Articulo,  SubCuenta,  Monto,  ListaModificar)
SELECT @ID, @Renglon+ROW_NUMBER() OVER (order by ListaModificar), @Articulo, @SubCuenta, @Monto, ListaModificar
FROM PCListaModificar
WHERE ID = @ID
ELSE
INSERT PCD (
ID,  Renglon,  Articulo,  SubCuenta,  Monto,  ListaModificar)
VALUES (@ID, @Renglon, @Articulo, @SubCuenta, @Monto, @ListaModificarD)
END
END
FETCH NEXT FROM crLista INTO @Articulo
END 
CLOSE crLista
DEALLOCATE crLista
DELETE ListaSt WHERE Estacion = @Estacion
END
DECLARE crPCD CURSOR FOR
SELECT Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), ListaModificar
FROM PCD
WHERE ID = @ID
AND Anterior IS NULL
AND Nuevo IS NULL
ORDER BY ID
OPEN crPCD
FETCH NEXT FROM crPCD INTO @Articulo, @SubCuenta, @Unidad, @ListaModificarD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @CfgListaModificarDetalle = 0 SELECT @ListaModificarD = @ListaModificar
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @Moneda, @TipoCambio, @ListaModificarD, @Precio OUTPUT
UPDATE PCD SET Nuevo = @Precio, Anterior = @Precio WHERE CURRENT OF crPCD
END
FETCH NEXT FROM crPCD INTO @Articulo, @SubCuenta, @Unidad, @ListaModificarD
END 
CLOSE crPCD
DEALLOCATE crPCD
IF @ArticuloEsp IS NOT NULL
DELETE PCD WHERE ID = @ID AND Articulo = @ArticuloEsp AND NULLIF(RTRIM(SubCuenta), '') IS NULL
IF @Estacion > 0
COMMIT TRANSACTION
RETURN
END

