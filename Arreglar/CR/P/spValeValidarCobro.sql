SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeValidarCobro
@Empresa		char(5),
@Modulo			char(5),
@ID			int,
@Accion 		char(20),
@Fecha			datetime,
@ValesCobrados		money,
@TarjetasCobradas	money,
@Moneda			char(10),
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ValePrecio		money,
@ValeMoneda		char(10),
@SumaPrecio		money,
@Serie		char(20),
@Estatus		char(15),
@FechaInicio	datetime,
@FechaTermino	datetime,
@Saldo		money,
@SaldoAplica	money,
@TipoCambio		float,
@MovTipo		varchar(10),
@OrigenTipo         varchar(20)
IF @Ok IS NOT NULL RETURN
IF @Modulo = 'VTAS'
SELECT @OrigenTipo = OrigenTipo FROM Venta WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @OrigenTipo = OrigenTipo FROM Cxc WHERE ID = @ID
SELECT @SumaPrecio = 0.0
EXEC spMovInfo @ID, @Modulo, @MovTipo = @MovTipo OUTPUT
DELETE ValeSerieMov FROM ValeSerie s
WHERE ValeSerieMov.Empresa = @Empresa AND ValeSerieMov.Modulo = @Modulo AND ValeSerieMov.ID = @ID
AND ValeSerieMov.Serie = s.Serie
AND s.TipoTarjeta <> 0
DECLARE crValeMov CURSOR FOR
SELECT v.Serie
FROM ValeSerieMov v, ValeSerie s
WHERE v.Empresa = @Empresa AND v.Modulo = @Modulo AND v.ID = @ID
AND v.Serie = s.Serie
AND s.TipoTarjeta = 0
OPEN crValeMov
FETCH NEXT FROM crValeMov INTO @Serie
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Estatus = NULL, @Serie = NULLIF(UPPER(RTRIM(@Serie)), '')
SELECT @Estatus      = Estatus,
@FechaInicio  = FechaInicio,
@FechaTermino = FechaTermino,
@ValePrecio   = Precio,
@ValeMoneda   = Moneda
FROM ValeSerie
WHERE Serie = @Serie
IF @ValeMoneda <> @Moneda SELECT @Ok = 36160
IF (@Accion = 'CANCELAR' AND @Estatus = 'COBRADO') OR
(@Accion <> 'CANCELAR' AND @Estatus = 'CIRCULACION')
BEGIN
IF (@Fecha < @FechaInicio) OR (@FechaTermino IS NOT NULL AND @Fecha > @FechaTermino)
SELECT @Ok = 36150
END ELSE
BEGIN
IF @Estatus IS NULL SELECT @Ok = 36020 ELSE
IF @Estatus = 'CANCELADO' SELECT @Ok = 36050 ELSE
IF @Estatus = 'COBRADO'   SELECT @Ok = 36110 ELSE
IF @Estatus = 'BLOQUEADO' SELECT @Ok = 36120 ELSE SELECT @OK = 36130, @OkRef = RTRIM(@Serie)+' ('+RTRIM(@Estatus)+')'
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Serie
SELECT @SumaPrecio = ROUND(@SumaPrecio + @ValePrecio,2)
END
FETCH NEXT FROM crValeMov INTO @Serie
END
CLOSE crValeMov
DEALLOCATE crValeMov
IF @Ok IS NULL AND @ValesCobrados <> @SumaPrecio SELECT @Ok = 36170
IF @OK is null
BEGIN
DELETE TarjetaSerieMov FROM ValeSerie s
WHERE TarjetaSerieMov.Empresa = @Empresa AND TarjetaSerieMov.Modulo = @Modulo AND TarjetaSerieMov.ID = @ID
AND TarjetaSerieMov.Serie = s.Serie
AND s.TipoTarjeta <> 1
SELECT @SumaPrecio = 0.0
DECLARE crTarjetaMov CURSOR FOR
SELECT v.Serie, v.Importe
FROM TarjetaSerieMov v, ValeSerie s
WHERE v.Empresa = @Empresa AND v.Modulo = @Modulo AND v.ID = @ID
AND v.Serie = s.Serie
AND s.TipoTarjeta = 1
OPEN crTarjetaMov
FETCH NEXT FROM crTarjetaMov INTO @Serie, @SaldoAplica
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Estatus = NULL, @Serie = NULLIF(UPPER(RTRIM(@Serie)), '')
SELECT @Estatus      = Estatus,
@FechaInicio  = FechaInicio,
@FechaTermino = FechaTermino,
@ValePrecio   = Precio,
@ValeMoneda   = Moneda
FROM ValeSerie
WHERE Serie = @Serie
SELECT @Saldo = dbo.fnVerSaldoVale(@Serie)
IF @Accion <> 'CANCELAR' AND @MovTipo NOT IN ('CXC.DC', 'CXC.DE') AND @Saldo < @SaldoAplica
SELECT @Ok = 30096
IF @Accion = 'CANCELAR' AND @Saldo < @SaldoAplica
SELECT @Ok = 30096
IF @ValeMoneda <> @Moneda AND @OrigenTipo <> 'POS' SELECT @Ok = 36161 
IF /*(@Accion = 'CANCELAR' AND @Estatus = 'COBRADO') OR */
(@Accion <> 'CANCELAR' AND @Estatus = 'CIRCULACION')
BEGIN
IF (@Fecha < @FechaInicio) OR (@FechaTermino IS NOT NULL AND @Fecha > @FechaTermino)
SELECT @Ok = 36151
END ELSE
IF @Estatus <> 'CIRCULACION'
BEGIN
IF @Estatus IS NULL SELECT @Ok = 36020 ELSE
IF @Estatus = 'CANCELADO' SELECT @Ok = 36051 ELSE
IF @Estatus = 'DISPONIBLE' SELECT @Ok = 36043 ELSE
IF @Estatus = 'BLOQUEADO' SELECT @Ok = 36121 ELSE SELECT @OK = 36131, @OkRef = RTRIM(@Serie)+' ('+RTRIM(@Estatus)+')'
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Serie
SELECT @SumaPrecio = @SumaPrecio + @SaldoAplica
END
FETCH NEXT FROM crTarjetaMov INTO @Serie, @SaldoAplica
END
CLOSE crTarjetaMov
DEALLOCATE crTarjetaMov
IF @Ok IS NULL AND @TarjetasCobradas <> @SumaPrecio /*AND @SumaPrecio <> 0 */ SELECT @Ok = 36171
END
END

