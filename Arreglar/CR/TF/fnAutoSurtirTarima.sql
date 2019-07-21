SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAutoSurtirTarima (@Empresa varchar(5), @Almacen varchar(10), @Articulo varchar(20), @SubCuenta varchar(50), @Cantidad float, @Unidad varchar(50))
RETURNS @Resultado TABLE (Tarima varchar(20), Posicion varchar(10), Cantidad float)

AS BEGIN
DECLARE
@Tarima				varchar(20),
@Existencia			float,
@CantidadTarima		float,
@CantidadPendiente	float,
@CantidadA			float,
@Posicion			varchar(20),
@PosicionTipo		varchar(20),
@Domicilio			varchar(10),
@DomicilioTarima	varchar(20),
@Pasillo			int,
@Fila				int,
@Nivel				int
DECLARE @TarimaApartada TABLE(
Modulo				varchar(10),
Tarima				varchar(10),
Cantidad			float)
DECLARE @TarimaApartadaR TABLE(
Tarima				varchar(10),
Cantidad			float)
INSERT INTO @TarimaApartada(Modulo, Tarima, Cantidad)
SELECT 'VTAS', d.Tarima, SUM(ISNULL(d.CantidadPendiente, 0) + ISNULL(d.CantidadReservada, 0))
FROM Venta e
JOIN VentaD d ON e.ID = d.ID
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'VTAS' AND mt.Clave IN ('VTAS.P')
WHERE e.Empresa = @Empresa
AND e.Almacen = @Almacen
AND e.Estatus IN ('PENDIENTE', 'SINAFECTAR')
AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND NULLIF(RTRIM(d.Tarima), '') IS NOT NULL
GROUP BY d.Tarima
INSERT INTO @TarimaApartada(Modulo, Tarima, Cantidad)
SELECT 'INV', d.Tarima, SUM(ISNULL(d.CantidadPendiente, 0) + ISNULL(d.CantidadReservada, 0))
FROM Inv e
JOIN InvD d ON e.ID = d.ID
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'INV' AND mt.Clave IN ('INV.OT', 'INV.OI') 
WHERE e.Empresa = @Empresa
AND e.Almacen = @Almacen
AND e.Estatus IN ('PENDIENTE', 'SINAFECTAR')
AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND NULLIF(RTRIM(d.Tarima), '') IS NOT NULL
GROUP BY d.Tarima
INSERT INTO @TarimaApartada(Modulo, Tarima, Cantidad)
SELECT 'COMS', d.Tarima, SUM(ISNULL(d.CantidadPendiente, 0))
FROM Compra e
JOIN CompraD d ON e.ID = d.ID
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'COMS' AND mt.Clave IN ('COMS.OD') 
WHERE e.Empresa = @Empresa
AND e.Almacen = @Almacen
AND e.Estatus IN ('PENDIENTE', 'SINAFECTAR')
AND d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND NULLIF(RTRIM(d.Tarima), '') IS NOT NULL
GROUP BY d.Tarima
INSERT INTO @TarimaApartadaR(Tarima, Cantidad)
SELECT Tarima, SUM(Cantidad)
FROM @TarimaApartada ta
GROUP BY ta.Tarima
SELECT @CantidadPendiente = @Cantidad
SELECT @CantidadTarima = CantidadTarima FROM Art WHERE Articulo = @Articulo
SELECT TOP 1 @Domicilio = ap.Posicion
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'DOMICILIO' AND ap.ArticuloEsp = @Articulo
SELECT @Pasillo = ap.Pasillo, @Fila = ap.Fila, @Nivel = ap.Nivel
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND ap.Posicion = @Posicion
IF @CantidadPendiente < @CantidadTarima AND @Domicilio IS NOT NULL
BEGIN
SELECT @DomicilioTarima = dbo.fnTarimaEnPosicion(@Almacen, @Domicilio)
IF @DomicilioTarima IS NOT NULL
INSERT @Resultado(
Tarima, Posicion,  Cantidad)
VALUES (@DomicilioTarima, @Domicilio, @CantidadPendiente)
END
ELSE
BEGIN
DECLARE crExistenciaTarima CURSOR LOCAL FOR
SELECT e.Tarima, t.Posicion, ap.Tipo, SUM(e.Existencia)
FROM ArtSubExistenciaInvCsgTarima e
JOIN Tarima t ON t.Tarima = e.Tarima
JOIN AlmPos ap ON ap.Almacen = @Almacen AND ap.Posicion = t.Posicion
WHERE e.Empresa = @Empresa AND e.Almacen = @Almacen AND e.Articulo = @Articulo AND e.SubCuenta = ISNULL(@SubCuenta, '')
AND UPPER(ap.Tipo) = 'UBICACION'
AND t.Tarima NOT IN (SELECT Tarima FROM @TarimaApartadaR tar)
GROUP BY e.Tarima, t.Posicion, ap.Tipo, ap.Pasillo, ap.Fila, ap.Nivel
ORDER BY Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel), Abs(ISNULL(Pasillo, 0)-@Pasillo), e.Tarima
OPEN crExistenciaTarima
FETCH NEXT FROM crExistenciaTarima INTO @Tarima, @Posicion, @PosicionTipo, @Existencia
WHILE @@FETCH_STATUS <> -1 AND @CantidadPendiente > 0.0
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Existencia, 0.0) IS NOT NULL
BEGIN
/*IF @PosicionTipo = 'DOMICILIO' OR @CantidadPendiente >= @Existencia
BEGIN*/
IF @Existencia > @CantidadPendiente
BEGIN
SELECT @CantidadA = @CantidadPendiente
SELECT @DomicilioTarima = dbo.fnTarimaEnPosicion(@Almacen, @Domicilio)
SELECT @Tarima = @DomicilioTarima
END
ELSE
SELECT @CantidadA = @Existencia
INSERT @Resultado (
Tarima,   Posicion,  Cantidad)
VALUES (@Tarima, @Posicion, @CantidadA)
SELECT @CantidadPendiente = @CantidadPendiente - @CantidadA
/*END*/
END
FETCH NEXT FROM crExistenciaTarima INTO @Tarima, @Posicion, @PosicionTipo, @Existencia
END
CLOSE crExistenciaTarima
DEALLOCATE crExistenciaTarima
DELETE @TarimaApartadaR
END 
RETURN
END

