SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@Tipo			varchar(50),
@Precio			money,
@TipoTieneVigencia		bit,
@FechaInicio		datetime,
@FechaTermino		datetime,
@Cliente			char(10),
@Agente			char(10),
@Condicion			varchar(50),
@Vencimiento		datetime,
@Descuento			varchar(50),
@CtaDinero			char(10),
@FormaPago			varchar(50),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Serie			varchar(20),
@OrigenTipo		char(10),
@ArticuloTarjetas	char(20),
@CxcFormaCobroTarjetas	varchar(50),
@ContMoneda		char(10),
@MonedaVales		char(10),
@TarjetaDestino			varchar(20) 
SELECT @Serie = NULL
SELECT @ArticuloTarjetas = NULLIF(Articulo,'') FROM Vale WHERE ID = @ID
SELECT @CxcFormaCobroTarjetas = CxcFormaCobroTarjetas, @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @MonedaVales = NULLIF(Moneda,'') FROM FormaPago WHERE FormaPago = @CxcFormaCobroTarjetas
IF @MovTipo = 'VALE.TT' SELECT @TarjetaDestino = NULLIF(RTRIM(TarjetaDestino), '') FROM Vale WHERE ID = @ID 
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo IN ('VTAS.E', 'VALE.D') AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'DISPONIBLE'
IF @Serie IS NOT NULL SELECT @Ok = 36030, @OkRef = @Serie
END ELSE
IF @MovTipo IN ('VALE.V', 'VALE.EV', 'VALE.EO', 'VALE.O') AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'CIRCULACION'
IF @Serie IS NOT NULL SELECT @Ok = 36042, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.B' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'BLOQUEADO'
IF @Serie IS NOT NULL SELECT @Ok = 36060, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.DB' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus NOT IN ('DISPONIBLE', 'CIRCULACION')
IF @Serie IS NOT NULL SELECT @Ok = 36040, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.A' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'CONCLUIDO'
IF @Serie IS NOT NULL SELECT @Ok = 36090, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.CM' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'COBRADO'
IF @Serie IS NOT NULL SELECT @Ok = 36080, @OkRef = @Serie
END
IF @MovTipo IN ('VALE.ET') AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'DISPONIBLE'
IF @Serie IS NOT NULL SELECT @Ok = 36011, @OkRef = @Serie
END ELSE
/*    IF @MovTipo IN ('VALE.OT') AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'CIRCULACION'
IF @Serie IS NOT NULL SELECT @Ok = 36031, @OkRef = @Serie
END ELSE*/
IF @MovTipo = 'VALE.BT' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'BLOQUEADO'
IF @Serie IS NOT NULL SELECT @Ok = 36031, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.DBT' AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus NOT IN ('DISPONIBLE', 'CIRCULACION')
IF @Serie IS NOT NULL SELECT @Ok = 36031, @OkRef = @Serie
END ELSE 
IF @MovTipo = 'VALE.TT' AND @Ok IS NULL
BEGIN
IF (SELECT dbo.fnVerSaldoVale(@TarjetaDestino))<(SELECT SUM(Importe) FROM ValeD WHERE ID = @ID)
SELECT @Ok = 30096, @OkRef = 'Tarjeta ' + @TarjetaDestino
END
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM ValeD WHERE ID = @ID) SELECT @Ok = 60010
IF @MovTipo IN ('VALE.V', 'VALE.D', 'VALE.EV', 'VALE.EO', 'VALE.O'/*, 'VALE.OT'*/) AND @Cliente IS NULL SELECT @Ok = 40010
IF @MovTipo IN ('VALE.TT') AND EXISTS (SELECT * FROM ValeD WHERE ID = @ID AND Serie = @TarjetaDestino) 
SELECT @Ok = 10060, @OkRef = 'No se puede transferir de la misma tarjeta: ' + @TarjetaDestino 
IF @MovTipo IN ('VALE.TT', 'VALE.CS') AND @Ok IS NULL
BEGIN
SELECT @Serie = MIN(Serie) FROM ValeD WHERE ID = @ID AND dbo.fnVerSaldoVale(Serie)< Importe 
IF @Serie IS NOT NULL
SELECT @Ok = 10060, @OkRef = 'Tarjeta ' + @Serie + ' excede su saldo: ' 
END
IF @Ok IS NULL
BEGIN
IF @MovTipo IN ('VALE.E', 'VALE.EV', 'VALE.ET', 'VALE.EO')
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND d.Serie = s.Serie AND Estatus <> 'CANCELADO' 
IF @Serie IS NOT NULL
BEGIN
IF @MovTipo = 'VALE.ET'
SELECT @Ok = 36011, @OkRef = @Serie
ELSE
SELECT @Ok = 36010, @OkRef = @Serie
END ELSE
IF @MovTipo = 'VALE.ET'
BEGIN
IF (SELECT NULLIF(Almacen,'') FROM Vale WHERE ID = @ID) = NULL
SELECT @Ok = 20830, @OkRef = NULL
ELSE
IF @ArticuloTarjetas is not null AND (SELECT Tipo FROM Art WHERE Articulo = @ArticuloTarjetas) <> 'Serie'
SELECT @Ok = 10060, @OkRef = 'El Artículo indicado en el Movimiento debe ser Tipo Serie'
ELSE
IF @ArticuloTarjetas is null OR NOT Exists(SELECT * FROM Art WHERE Articulo = @ArticuloTarjetas)
SELECT @Ok = 10530
ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 0
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
END
ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END
END ELSE
BEGIN
SELECT @Serie = MIN(d.Serie) FROM ValeD d WHERE d.ID = @ID AND d.Serie NOT IN (SELECT Serie FROM ValeSerie)
IF @Serie IS NOT NULL
BEGIN
IF @MovTipo in ('VALE.AT', 'VALE.BT', 'VALE.CT', 'VALE.DBT'/*, 'VALE.OT'*/)
SELECT @Ok = 36021, @OkRef = @Serie
ELSE
SELECT @Ok = 36020, @OkRef = @Serie
END
IF @MovTipo = 'VALE.AT' AND @Ok IS NULL
BEGIN
SELECT @OrigenTipo = NULLIF(OrigenTipo,'') FROM Vale WHERE ID = @ID
IF @OrigenTipo IS NULL SELECT @Ok = 60070
END
END
IF @MovTipo IN ('VALE.V', 'VALE.C', 'VALE.CT', 'VALE.O'/*, 'VALE.OT'*/)
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'DISPONIBLE'
IF @Serie IS NOT NULL
BEGIN
IF @MovTipo in ('VALE.CT'/*, 'VALE.OT'*/)
SELECT @Ok = 36031, @OkRef = @Serie
ELSE
SELECT @Ok = 36030, @OkRef = @Serie
END
IF @MovTipo IN ('VALE.V', 'VALE.C', 'VALE.O')
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 0
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
END ELSE
IF @MovTipo = 'VALE.D'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND (s.Estatus <> 'CIRCULACION' OR s.Cliente <> @Cliente)
IF @Serie IS NOT NULL SELECT @Ok = 36045, @OkRef = @Serie
ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END
END ELSE
IF @MovTipo in ('VALE.B', 'VALE.BT')
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus NOT IN ('DISPONIBLE', 'CIRCULACION')
IF @Serie IS NOT NULL
BEGIN
IF @MovTipo in ('VALE.BT')
SELECT @Ok = 36041, @OkRef = @Serie
ELSE
SELECT @Ok = 36040, @OkRef = @Serie
END
IF @MovTipo = 'VALE.B'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END
ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 0
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
END ELSE
IF @MovTipo in ('VALE.DB', 'VALE.DBT')
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'BLOQUEADO'
IF @Serie IS NOT NULL
BEGIN
IF @MovTipo in ('VALE.DBT')
SELECT @Ok = 36061, @OkRef = @Serie
ELSE
SELECT @Ok = 36060, @OkRef = @Serie
END
IF @MovTipo = 'VALE.DB'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 0
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
END ELSE
IF @MovTipo = 'VALE.A'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'COBRADO'
IF @Serie IS NOT NULL SELECT @Ok = 36080, @OkRef = @Serie ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END
IF @CtaDinero IS NULL SELECT @Ok = 40030
END ELSE
IF @MovTipo = 'VALE.AT'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'CIRCULACION'
IF @Serie IS NOT NULL SELECT @Ok = 36043, @OkRef = @Serie ELSE
IF @CtaDinero IS NULL SELECT @Ok = 40030, @OkRef = NULL ELSE
IF (SELECT NULLIF(OrigenTipo,'') FROM Vale WHERE ID = @ID) = NULL SELECT @Ok = 25410 ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 0
IF @Serie IS NOT NULL SELECT @Ok = 36101, @OkRef = @Serie
END
END ELSE
IF @MovTipo IN('VALE.AMLDI','VALE.ACTMLDI')
BEGIN
SELECT @OrigenTipo = NULLIF(OrigenTipo,'') FROM Vale WHERE ID = @ID
IF @OrigenTipo <> 'VTAS'
SELECT @Ok = 25410
END ELSE
IF @MovTipo = 'VALE.CM'
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.Estatus <> 'CIRCULACION'
IF @Serie IS NOT NULL SELECT @Ok = 36042, @OkRef = @Serie ELSE
BEGIN
SELECT @Serie = MIN(d.Serie)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND d.Serie = s.Serie AND s.TipoTarjeta = 1
IF @Serie IS NOT NULL SELECT @Ok = 36100, @OkRef = @Serie
END
END
END
END
RETURN
END

