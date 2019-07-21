SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACMinistracionHipotecaria
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Hoy			datetime,
@FechaRegistro	datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Intereses			money,
@InteresesID		int,
@InteresesMov		varchar(20),
@InteresesMovID		varchar(20),
@Bonificacion		money,
@BonificacionID		int,
@BonificacionMov		varchar(20),
@BonificacionMovID		varchar(20),
@Documento			money,
@DocumentoID		int,
@DocumentoMov		varchar(20),
@DocumentoMovID		varchar(20),
@LineaCredito		varchar(20),
@Importe			money,
@Disposiciones		money,
@Moneda			char(10),
@TipoCambio			float,
@Acreditado			varchar(10),
@TipoTasa			varchar(20),
@TipoTasaBonificacion	varchar(20),
@TasaDiaria			float,
@TasaDiariaBonificacion	float,
@TieneTasaEsp		bit,
@TasaEsp			float,
@VigenciaDesde		datetime,
@CorteDesde			datetime,
@TipoVencimiento		varchar(20),
@Dias			int,
@Aplica			varchar(20),
@AplicaID			varchar(20),
@Saldo			money,
@Renglon			float
BEGIN TRANSACTION
SELECT @InteresesMov = ACMHIntereses,
@BonificacionMov = ACMHInteresesBonificacion,
@DocumentoMov = ACMHInteresesDocumento
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DECLARE crLC CURSOR FOR
SELECT lc.LineaCredito, lc.Importe, lc.Moneda, m.TipoCambio, lc.Acreditado, lc.TipoTasa, ISNULL(lc.TieneTasaEsp, 0), lc.TasaEsp, NULLIF(lc.TipoTasaBonificacion, ''), lc.VigenciaDesde,
ta.PagoVencimiento, ta.PagoDias
FROM LC
JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = lc.TipoAmortizacion
JOIN Mon m ON m.Moneda = lc.Moneda
WHERE lc.Empresa = @Empresa AND lc.MinistracionHipotecaria = 1 AND lc.Estatus = 'ALTA' AND @Hoy BETWEEN lc.VigenciaDesde AND lc.VigenciaHasta
OPEN crLC
FETCH NEXT FROM crLC INTO @LineaCredito, @Importe, @Moneda, @TipoCambio, @Acreditado, @TipoTasa, @TieneTasaEsp, @TasaEsp, @TipoTasaBonificacion, @VigenciaDesde, @TipoVencimiento, @Dias
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spTipoTasa @TipoTasa, @TasaDiaria OUTPUT, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp
SELECT @Intereses = @Importe * (@TasaDiaria / 100.0)
INSERT Cxc (Sucursal,  Empresa,  Mov,           FechaEmision,  Referencia,    Importe,    Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,     ClienteMoneda, ClienteTipoCambio)
VALUES (@Sucursal, @Empresa, @InteresesMov, @Hoy,          @LineaCredito, @Intereses, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Acreditado, @Moneda,       @TipoCambio)
SELECT @InteresesID = SCOPE_IDENTITY()
EXEC spCx @InteresesID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @InteresesMov OUTPUT, @InteresesMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @TipoTasaBonificacion IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Disposiciones = SUM(Importe)
FROM Cxc
WHERE Empresa = @Empresa AND Cliente = @Acreditado AND LineaCredito = @LineaCredito AND Estatus IN ('PENDIENTE', 'CONCLUIDO') AND Moneda = @Moneda
IF @Disposiciones IS NOT NULL
BEGIN
EXEC spTipoTasa @TipoTasaBonificacion, @TasaDiariaBonificacion OUTPUT
SELECT @Bonificacion = (@Importe - ISNULL(@Disposiciones, 0.0)) * (@TasaDiariaBonificacion/100.0)
IF NULLIF(@Bonificacion, 0.0) IS NOT NULL
BEGIN
INSERT Cxc (Sucursal,  Empresa,  Mov,              FechaEmision,  Referencia,    Importe,       Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,     ClienteMoneda, ClienteTipoCambio)
VALUES (@Sucursal, @Empresa, @BonificacionMov, @Hoy,          @LineaCredito, @Bonificacion, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Acreditado, @Moneda,       @TipoCambio)
SELECT @BonificacionID = SCOPE_IDENTITY()
EXEC spCx @BonificacionID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @BonificacionMov OUTPUT, @BonificacionMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
END
END
SELECT @CorteDesde = NULL
SELECT @CorteDesde = dbo.fnEsDiaCorte (@Hoy, @TipoVencimiento, @Dias, @VigenciaDesde)
IF @CorteDesde IS NOT NULL
BEGIN
SELECT @Documento = NULL
SELECT @Documento = SUM(Saldo)
FROM dbo.fnCxcInfo(@Empresa, @Acreditado, @Acreditado)
WHERE Referencia = @LineaCredito AND Estatus = 'PENDIENTE' AND Mov IN (@InteresesMov, @BonificacionMov) AND FechaEmision BETWEEN @CorteDesde AND @Hoy AND Moneda = @Moneda
IF NULLIF(@Documento, 0.0) IS NOT NULL
BEGIN
INSERT Cxc (Sucursal,  Empresa,  Mov,           FechaEmision,  Referencia,    Importe,    Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,     ClienteMoneda, ClienteTipoCambio, AplicaManual)
VALUES (@Sucursal, @Empresa, @DocumentoMov, @Hoy,          @LineaCredito, @Documento, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Acreditado, @Moneda,       @TipoCambio,       1)
SELECT @DocumentoID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
DECLARE crDocumento CURSOR LOCAL FOR
SELECT Mov, MovID, NULLIF(Saldo, 0.0)
FROM dbo.fnCxcInfo(@Empresa, @Acreditado, @Acreditado)
WHERE Referencia = @LineaCredito AND Estatus = 'PENDIENTE' AND Mov IN (@InteresesMov, @BonificacionMov) AND FechaEmision BETWEEN @CorteDesde AND @Hoy AND Moneda = @Moneda
OPEN crDocumento
FETCH NEXT FROM crDocumento INTO @Aplica, @AplicaID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND @Saldo IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT CxcD (ID, Renglon, Sucursal, Aplica, AplicaID, Importe) VALUES (@DocumentoID, @Renglon, @Sucursal, @Aplica, @AplicaID, @Saldo)
END
FETCH NEXT FROM crDocumento INTO @Aplica, @AplicaID, @Saldo
END  
CLOSE crDocumento
DEALLOCATE crDocumento
EXEC spCx @DocumentoID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @DocumentoMov OUTPUT, @DocumentoMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
END
END
FETCH NEXT FROM crLC INTO @LineaCredito, @Importe, @Moneda, @TipoCambio, @Acreditado, @TipoTasa, @TieneTasaEsp, @TasaEsp, @TipoTasaBonificacion, @VigenciaDesde, @TipoVencimiento, @Dias
END  
CLOSE crLC
DEALLOCATE crLC
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

