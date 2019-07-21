SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpEmbarqueAsignarWMS
@ID			int
AS BEGIN
DECLARE
@ModuloID		int,
@Modulo			char(10),
@WMS			bit,
@Mov			varchar(20),
@Origen			varchar(20),
@Renglon		float,
@RenglonSub		int,
@Tarima			varchar(20)
DECLARE crEmbarqueDArt CURSOR FOR
SELECT Modulo, ModuloID
FROM EmbarqueDArt
WHERE ID = @ID AND Modulo IN ('VTAS', 'COMS')
GROUP BY Modulo, ModuloID
OPEN crEmbarqueDArt
FETCH NEXT FROM crEmbarqueDArt INTO @Modulo, @ModuloID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'VTAS'
SELECT
@WMS      =	ISNULL(a.WMS,0),
@Mov      =	Mov,
@Origen   =	ISNULL(Origen,'')
FROM Venta v JOIN Alm a ON v.Almacen = a.Almacen WHERE v.ID = @ModuloID
ELSE
IF @Modulo = 'COMS'
SELECT
@WMS      =	ISNULL(a.WMS,0),
@Mov      =	Mov,
@Origen   =	ISNULL(Origen,'')
FROM Inv v JOIN Alm a ON v.Almacen = a.Almacen WHERE v.ID = @ModuloID
IF @WMS = 1 AND EXISTS(SELECT * FROM WMSModuloMovimiento WHERE Modulo = @Modulo AND Movimiento IN (@Mov, @Origen))
BEGIN
IF @Modulo = 'VTAS'
DECLARE crTarima CURSOR FOR
SELECT Renglon, RenglonSub, Tarima
FROM VentaD
WHERE ID = @ModuloID AND ISNULL(Tarima,'') <> ''
ELSE
IF @Modulo = 'COMS'
DECLARE crTarima CURSOR FOR
SELECT Renglon, RenglonSub, Tarima
FROM CompraD
WHERE ID = @ModuloID AND ISNULL(Tarima,'') <> ''
OPEN crTarima
FETCH NEXT FROM crTarima INTO @Renglon, @RenglonSub, @Tarima
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE EmbarqueDArt SET Tarima = @Tarima WHERE ID = @ID AND Modulo = @Modulo AND ModuloID = @ModuloID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
FETCH NEXT FROM crTarima INTO @Renglon, @RenglonSub, @Tarima
END 
CLOSE crTarima
DEALLOCATE crTarima
END
END
FETCH NEXT FROM crEmbarqueDArt INTO @Modulo, @ModuloID
END 
CLOSE crEmbarqueDArt
DEALLOCATE crEmbarqueDArt
RETURN
END

