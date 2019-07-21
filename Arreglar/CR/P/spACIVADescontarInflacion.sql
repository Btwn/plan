SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACIVADescontarInflacion
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Modulo		char(5),
@Hoy			datetime,
@FechaRegistro	datetime,
@Conteo		int		OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@DescuentoInflacionID		int,
@DescuentoInflacionMov		varchar(20),
@DescuentoInflacionMovID	varchar(20),
@Moneda						char(10),
@TipoCambio					float,
@RamaID						int,
@ID							int,
@Mov						varchar(20),
@MovID						varchar(20),
@Contacto					char(10),
@Ordinarios					float,
@Saldo						float,
@Moratorios					float,
@MoratoriosFactor			float,
@InteresesFijos				float,
@InteresesAcumulados		float,
@Metodo						int,
@TasaDiaria					float,
@SumaInflacion				float,
@Renglon					float,
@FactorMes					float,
@Retencion					float,
@RamaEmision				datetime,
@ImporteInflacion			float,
@TipoTasa					varchar(20),
@TieneTasaEsp				bit,
@TasaEsp					float,
@Inflacion					float,
@IvaInteresPorcentaje		float,
@DiasInflacion				float
EXEC xpACDevengarInteresesFactorMes @Hoy, @FactorMes OUTPUT
SELECT @Inflacion = dbo.fnInflacionActualDiaria(@Empresa, @Sucursal)
IF @Inflacion = -1.0
BEGIN
SELECT @Ok = 30075, @OkRef = dbo.fnIdiomaTraducir(@Usuario,'Verifique la moneda utilizada para el cálculo de inflación.')
RETURN
END
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg JOIN Mon m
ON m.Moneda = cfg.ContMoneda
WHERE cfg.Empresa = @Empresa
SELECT @Contacto = CASE WHEN @Modulo = 'CXC' THEN ACClienteDevengados ELSE ACProveedorDevengados END
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Modulo = 'CXC' SELECT @DescuentoInflacionMov = CxcDescuentoInflacion FROM EmpresaCfgMovCxc WHERE Empresa = @Empresa ELSE
IF @Modulo = 'CXP' SELECT @DescuentoInflacionMov = CxpDescuentoInflacion FROM EmpresaCfgMovCxp WHERE Empresa = @Empresa
SELECT @DescuentoInflacionID = NULL
IF @Modulo = 'CXC'
SELECT @DescuentoInflacionID = ID FROM Cxc WHERE Empresa = @Empresa AND Mov = @DescuentoInflacionMov AND FechaEmision = @Hoy AND Moneda = @Moneda AND Estatus IN ('CONCLUIDO')
ELSE
SELECT @DescuentoInflacionID = ID FROM Cxp WHERE Empresa = @Empresa AND Mov = @DescuentoInflacionMov AND FechaEmision = @Hoy AND Moneda = @Moneda AND Estatus IN ('CONCLUIDO')
IF @DescuentoInflacionID IS NOT NULL
EXEC spCx @DescuentoInflacionID, @Modulo, 'CANCELAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @DescuentoInflacionMov OUTPUT, @DescuentoInflacionMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Modulo = 'CXC'
INSERT Cxc (Sucursal,  Empresa,  Mov,                    FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,   ClienteMoneda, ClienteTipoCambio)
VALUES (@Sucursal, @Empresa, @DescuentoInflacionMov, @Hoy,          @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Contacto, @Moneda,       @TipoCambio)
ELSE
INSERT Cxp (Sucursal,  Empresa,  Mov,           FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Proveedor, ProveedorMoneda, ProveedorTipoCambio)
VALUES (@Sucursal, @Empresa, @DescuentoInflacionMov, @Hoy,          @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Contacto, @Moneda,         @TipoCambio)
SELECT @DescuentoInflacionID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @SumaInflacion = 0.0
IF @DescuentoInflacionID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
DECLARE crInflacion CURSOR FOR
SELECT c.RamaID, r.FechaEmision, SUM(c.Saldo*(c.TasaDiaria/100.0)*c.TipoCambio), SUM(c.Saldo*c.TipoCambio), ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
FROM Cxc c
JOIN Cxc r ON r.ID = c.RamaID AND r.CarteraVencidaCNBV = 0
JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = c.TipoAmortizacion AND ta.Metodo <> 50
JOIN LC ON lc.LineaCredito = r.LineaCredito AND lc.MinistracionHipotecaria = 0 
WHERE c.Empresa = @Empresa
AND c.Estatus = 'PENDIENTE'
AND c.Vencimiento > @Hoy
AND r.FechaEmision <= @Hoy
AND lc.CobroIntereses = 'FIJOS'
GROUP BY c.RamaID, r.FechaEmision, ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
ORDER BY c.RamaID, r.FechaEmision, ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
ELSE
DECLARE crInflacion CURSOR FOR
SELECT c.RamaID, r.FechaEmision, SUM(c.Saldo*(c.TasaDiaria/100.0)*c.TipoCambio), SUM(c.Saldo*c.TipoCambio), ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
FROM Cxp c
JOIN Cxp r ON r.ID = c.RamaID
JOIN LC ON lc.LineaCredito = r.LineaCredito
WHERE c.Empresa = @Empresa
AND c.Estatus = 'PENDIENTE'
AND c.Vencimiento > @Hoy
AND r.FechaEmision <= @Hoy
AND lc.CobroIntereses = 'FIJOS'
GROUP BY c.RamaID, r.FechaEmision, ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
ORDER BY c.RamaID, r.FechaEmision, ISNULL(c.TipoTasa,''), ISNULL(c.TieneTasaEsp,0), ISNULL(c.TasaEsp,0.0), ISNULL(c.IVAInteresPorcentaje,0.0)
OPEN crInflacion
FETCH NEXT FROM crInflacion INTO @RamaID, @RamaEmision, @Ordinarios, @Saldo, @TipoTasa, @TieneTasaEsp, @TasaEsp, @IVAInteresPorcentaje
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @RamaID IS NOT NULL AND ISNULL(@Ordinarios, 0.0) <> 0.0
BEGIN
SELECT @ID = NULL, @InteresesAcumulados = NULL
IF @Modulo = 'CXC'
BEGIN
SELECT @InteresesAcumulados = SUM(InteresesOrdinarios) FROM Cxc WHERE RamaID  = @RamaID
SELECT @ID = MAX(ID) FROM Cxc WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE' AND @Hoy BETWEEN FechaEmision AND Vencimiento-1
IF @ID IS NULL
SELECT @ID = MIN(ID) FROM Cxc WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE'
END ELSE
BEGIN
SELECT @InteresesAcumulados = SUM(InteresesOrdinarios) FROM Cxp WHERE RamaID  = @RamaID
SELECT @ID = MAX(ID) FROM Cxp WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE' AND @Hoy BETWEEN FechaEmision AND Vencimiento-1
IF @ID IS NULL
SELECT @ID = MIN(ID) FROM Cxp WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE'
END
IF NULLIF(@InteresesAcumulados, 0.0) IS NULL
SELECT @DiasInflacion = DATEDIFF(day, @RamaEmision, @Hoy) + 1.0
ELSE
SELECT @DiasInflacion = 1.0
SELECT @Ordinarios = @Ordinarios * @FactorMes * @DiasInflacion
SET @ImporteInflacion = dbo.fnImporteInflacion(@TipoTasa, @TieneTasaEsp, @TasaEsp, @Inflacion, @Ordinarios, @IVAInteresPorcentaje, 0.0)
IF @ImporteInflacion = -1.0
BEGIN
SELECT @Ok = 30075, @OkRef = dbo.fnIdiomaTraducir(@Usuario,'Verifique la moneda utilizada para el cálculo de inflación.')
RETURN
END
IF @ImporteInflacion > 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @SumaInflacion = @SumaInflacion + ISNULL(@ImporteInflacion, 0.0)
IF @Modulo = 'CXC'
INSERT CxcD (ID,                   Sucursal,  Renglon,  Aplica, AplicaID, InteresesOrdinariosIVADescInfl)
SELECT @DescuentoInflacionID, @Sucursal, @Renglon, Mov,    MovID,    NULLIF(@ImporteInflacion, 0.0)
FROM Cxc
WHERE ID = @ID
ELSE
INSERT CxpD (ID,                   Sucursal,  Renglon,  Aplica, AplicaID, InteresesOrdinariosIVADescInfl)
SELECT @DescuentoInflacionID, @Sucursal, @Renglon, Mov,    MovID,    NULLIF(@ImporteInflacion, 0.0)
FROM Cxp
WHERE ID = @ID
END
END
END
FETCH NEXT FROM crInflacion INTO @RamaID, @RamaEmision, @Ordinarios, @Saldo, @TipoTasa, @TieneTasaEsp, @TasaEsp, @IVAInteresPorcentaje
END  
CLOSE crInflacion
DEALLOCATE crInflacion
IF @Modulo = 'CXC'
BEGIN
IF EXISTS(SELECT * FROM CxcD WHERE ID = @DescuentoInflacionID)
UPDATE Cxc SET Importe = @SumaInflacion WHERE ID = @DescuentoInflacionID
ELSE
BEGIN
DELETE Cxc WHERE ID = @DescuentoInflacionID
SELECT @DescuentoInflacionID = NULL
END
END ELSE
BEGIN
IF EXISTS(SELECT * FROM CxpD WHERE ID = @DescuentoInflacionID)
UPDATE Cxp SET Importe = @SumaInflacion WHERE ID = @DescuentoInflacionID
ELSE
BEGIN
DELETE Cxp WHERE ID = @DescuentoInflacionID
SELECT @DescuentoInflacionID = NULL
END
END
IF @DescuentoInflacionID IS NOT NULL
EXEC spCx @DescuentoInflacionID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @DescuentoInflacionMov OUTPUT, @DescuentoInflacionMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

