SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSInvInventarioFisicoSerieLote
@ID				int,
@Base			char(20),
@Modulo			char(5),
@Almacen			char(10),
@IDGenerar		int,
@Ok				int OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@WMS			bit,
@Articulo		varchar(20),
@Tarima			varchar(20),
@Unidad			varchar(50),
@Empresa		char(5),
@Sucursal		int,
@TipoCosto		varchar(20),
@Moneda			varchar(10),
@TipoCambio		float,
@FormaCosteo	varchar(20),
@Costo			float,
@Renglon		int,
@RenglonID		int
DECLARE @Posiciones TABLE
(
Posicion		varchar(50)
)
DECLARE @Tarimas TABLE
(
Tarima			varchar(20)
)
SELECT @WMS = ISNULL(WMS,0) FROM Alm WHERE Almacen = @Almacen
IF @WMS = 1
BEGIN
SELECT @Empresa = Empresa,
@Sucursal = Sucursal,
@Moneda = Moneda,
@TipoCambio = TipoCambio
FROM Inv
WHERE ID = @ID
SELECT @FormaCosteo = FormaCosteo
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @FormaCosteo <> 'Articulo'
SET @TipoCosto = (SELECT TipoCosteo FROM EmpresaCfg WHERE Empresa = @Empresa)
INSERT @Posiciones
SELECT DISTINCT l.Posicion
FROM InvD i
JOIN Art a
ON i.Articulo = a.Articulo
AND a.Tipo IN ('SERIE', 'LOTE')
JOIN Tarima t
ON t.Tarima = i.Tarima
JOIN AlmPos l
ON l.Posicion = t.Posicion
WHERE ID = @ID
INSERT @Tarimas
SELECT DISTINCT i.Tarima
FROM InvD i
JOIN Art a
ON i.Articulo = a.Articulo
AND a.Tipo IN ('SERIE', 'LOTE')
JOIN Tarima t
ON t.Tarima = i.Tarima
JOIN AlmPos l
ON l.Posicion = t.Posicion
WHERE ID = @ID
IF EXISTS(
SELECT d.Tarima
FROM ArtDisponibleTarima d
JOIN Tarima t ON d.Tarima = t.Tarima
JOIN Art a ON a.Articulo = d.Articulo
JOIN TMAD wd ON d.Tarima = wd.Tarima
JOIN TMA w ON wd.ID = w.ID AND w.Estatus = 'PROCESAR'
WHERE d.Disponible > 0
AND t.Posicion IN (SELECT * FROM @Posiciones)
AND t.Tarima NOT IN (SELECT * FROM @Tarimas)
AND d.Almacen = @Almacen
AND a.Tipo IN ('SERIE', 'LOTE'))
SELECT @Ok = 20923
DECLARE crInventarioFisico CURSOR FOR
SELECT d.Articulo, d.Tarima
FROM ArtDisponibleTarima d
JOIN Tarima t
ON d.Tarima = t.Tarima
JOIN Art a
ON a.Articulo = d.Articulo
WHERE d.Disponible > 0
AND t.Posicion IN (SELECT * FROM @Posiciones)
AND t.Tarima NOT IN (SELECT * FROM @Tarimas)
AND d.Almacen = @Almacen
AND a.Tipo IN ('SERIE', 'LOTE')
OPEN crInventarioFisico
FETCH NEXT FROM crInventarioFisico INTO @Articulo, @Tarima
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = MAX(Renglon) + 2048,
@RenglonID = MAX(RenglonID) + 1
FROM InvD
WHERE ID = @ID
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @Articulo
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, NULL, @Unidad, @TipoCosto, @Moneda, @TipoCambio, @Costo OUTPUT, NULL, 0
INSERT InvD( ID, Renglon,  RenglonID,  Cantidad, Almacen,  Articulo,  Costo,  FechaRequerida,                Unidad,  CantidadInventario, Tarima)
SELECT      @ID, @Renglon, @RenglonID, 0,        @Almacen, @Articulo, @Costo, dbo.fnFechaSinHora(GETDATE()), @Unidad, 0,                  @Tarima
END
FETCH NEXT FROM crInventarioFisico INTO @Articulo, @Tarima
END 
CLOSE crInventarioFisico
DEALLOCATE crInventarioFisico
END
RETURN
END

