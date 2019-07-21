SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaActiva
@Empresa	varchar(5),
@Sucursal	int,
@FechaHora	datetime,
@ImporteTotalMN	money

AS BEGIN
DECLARE
@ID			int,
@MontoMinimoMN	money,
@TodasSucursales	bit,
@FiltroOk		bit
SET DATEFIRST 7
DECLARE crOferta CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT o.ID, NULLIF(o.MontoMinimo, 0.0)*m.TipoCambio, ISNULL(o.TodasSucursales, 0)
FROM Oferta o
JOIN Mon m ON m.Moneda = o.Moneda
WHERE o.Empresa = @Empresa AND o.Estatus = 'VIGENTE' AND dbo.fnEstaVigenteAvanzado(@FechaHora, o.FechaD, o.FechaA, o.HoraD, o.HoraA, o.DiasEsp) = 1
OPEN crOferta
FETCH NEXT FROM crOferta INTO @ID, @MontoMinimoMN, @TodasSucursales
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @TodasSucursales = 1 OR EXISTS(SELECT * FROM OfertaSucursalEsp WHERE ID = @ID AND SucursalEsp=@Sucursal)
IF @MontoMinimoMN IS NULL OR (ISNULL(@ImporteTotalMN, 0.0) >= ISNULL(@MontoMinimoMN, 0.0))
BEGIN
EXEC spOfertaFiltroOk @ID, @FiltroOk OUTPUT
EXEC xpOfertaActiva @Empresa, @Sucursal, @FechaHora, @ImporteTotalMN, @ID, @FiltroOk OUTPUT
IF @FiltroOk = 1
INSERT #OfertaActiva (ID, Sucursal) VALUES (@ID, @Sucursal)
END
END
FETCH NEXT FROM crOferta INTO @ID, @MontoMinimoMN, @TodasSucursales
END  
CLOSE crOferta
DEALLOCATE crOferta
RETURN
END

