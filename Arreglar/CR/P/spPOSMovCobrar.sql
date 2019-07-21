SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMovCobrar
@Empresa				varchar(5),
@Sucursal				int,
@Usuario				varchar(10),
@ID						varchar(50),
@Codigo					varchar(50),
@Referencia				varchar(50),
@CtaDinero				varchar(10),
@ToleranciaRedondeo		float,
@MovClave				varchar(20),
@Monedero				varchar(20),
@ImporteRef				float,
@CodigoAccion			varchar(50)		OUTPUT,
@Importe				float			OUTPUT,
@Saldo					float			OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT,
@Cambio					bit	= 0,
@RIDCobro				int				OUTPUT

AS
BEGIN
DECLARE
@FormaPago						varchar(50),
@RequiereReferencia				bit,
@PermiteCambio					bit,
@FormaPagoSaldoAFavor			varchar(50),
@FormaPagoMoneda				varchar(20),
@FormaPagoTipoCambio			float,
@ImporteEnCaja					float,
@ImporteEnMovimiento			float,
@Mov							varchar(20),
@MovID							varchar(20),
@Prefijo						varchar(5),
@Consecutivo					int,
@noAprobacion					int,
@fechaAprobacion				datetime,
@Fecha							datetime,
@Caja							varchar(10),
@CtaDineroDestino				varchar(10),
@Cajero							varchar(10),
@Abierto						bit,
@Voucher						varchar(MAX),
@Banco							varchar(255),
@Host							varchar(20),
@Cluster						varchar(20),
@MonedaPrincipal				varchar(10),
@MonedaMov    					varchar(10),
@RedondeoMonetarios				int,
@ArticuloOfertaFP				varchar(20),
@ImporteMov						float,
@Descuento						float,
@ImporteOfer					float,
@Renglon						float,
@ArtTipo						varchar(50),
@RenglonTipo					varchar(1),
@RenglonID						int,
@FormaPagoOfer					varchar(50),
@PrecioOfer						float,
@Unidad							varchar(50),
@ArticuloRedondeo				varchar(20),
@CodigoRedondeo					varchar(50),
@Hora							int,
@Minutos						int,
@HoraMinutos					int,
@MonederoMoneda					varchar(10),
@MonederoTipoCambio				float,
@ImporteMonedero				float,
@SevicioLDI						varchar(20),
@LDI							bit,
@ImporteRedondeo				float,
@DImporte						float,
@ImporteDescuento				float,
@DImpuesto1						float,
@DImpuesto2						float,
@DImpuesto3						float,
@CfgAnticipoArticuloServicio	varchar(20),
@POSMonedaAct					bit,
@Comision3						float,
@Comision3Porcentaje			float,
@CImporte		                float
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF NULLIF(@MovClave,'') IS NULL
SELECT @MovClave = mt.Clave
FROM POSL p
JOIN Movtipo mt ON p.Mov = mt.Mov and mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @Fecha = GETDATE()
SELECT @Hora = DATEPART(HOUR,@Fecha)
SELECT @Minutos= DATEPART(MINUTE,@Fecha)
SELECT @HoraMinutos = (@Hora*60)+@Minutos
IF @MovClave IN ('POS.ACM', 'POS.CCM', 'POS.CPCM', 'POS.TCM', 'POS.TRM') AND @Importe < 1.00
BEGIN
SELECT @Ok = 30100, @OkRef = 'EL IMPORTE NO PUEDE SER MENOR A 1 PARA LA FORMA DE PAGO SELECCIONADA'
RETURN
END
IF @Monedero IS NOT NULL
BEGIN
SELECT @MonederoMoneda = Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
SELECT @MonederoTipoCambio = ISNULL(TipoCambio,1.0)
FROM POSLTipoCambioRef
WHERE Moneda = @MonederoMoneda AND Sucursal = @Sucursal
IF NOT EXISTS(SELECT TipoCambio FROM POSLTipoCambioRef WHERE Moneda = @MonederoMoneda AND Sucursal = @Sucursal)
SELECT @Ok =  20196, @OkRef = @MonederoMoneda
IF NULLIF(@MonederoMoneda ,'') IS NULL
SELECT @Ok = 30050 , @OkRef = @Monedero
END
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef
WHERE TipoCambio = 1
AND Sucursal = @Sucursal AND EsPrincipal = 1
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT
@Caja = Caja,
@Cajero = Cajero,
@CtaDineroDestino=CtaDineroDestino
FROM POSL
WHERE ID = @ID
IF @MovClave NOT IN ('POS.AC','POS.ACM','POS.CAC','POS.CACM','POS.IC','POS.EC','POS.AP')
SELECT TOP 1
@Caja = pec.Caja,
@Cajero = pec.Cajero
FROM POSEstatusCaja  pec
WHERE Usuario = @Usuario
AND Abierto = 1
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT
@FormaPago = cb.FormaPago,
@RequiereReferencia = fp.RequiereReferencia,
@PermiteCambio = fp.PermiteCambio
FROM CB
INNER JOIN FormaPago fp ON CB.FormaPago = fp.FormaPago
WHERE Codigo = @Codigo
IF @MovClave IN ('POS.N', 'POS.F')
BEGIN
IF (SELECT COUNT(DISTINCT FormaPago) FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID ) >=5
BEGIN
IF @FormaPago NOT IN (SELECT DISTINCT FormaPago FROM POSLCobro with (NOLOCK) WHERE ID = @ID )
BEGIN
SELECT @Ok = 10060, @OkRef = 'NO PUEDE INGRESAR MAS DE 5 DIFERENTES FORMAS PAGO'
RETURN
END
END
END
IF @MovClave IN ('POS.N', 'POS.F', 'POS.A','POS.P','POS.NPC','POS.INVD', 'POS.INVA','POS.FA','POS.CXCD', 'POS.CXCC')
BEGIN
EXEC spPOSEstatusCajaVerificar @ID, @Caja, @Cajero,'Abierto' , @Abierto OUTPUT
IF @Abierto = 0
SELECT @Ok = 30440, @okRef = @Caja
END
SELECT @FormaPagoSaldoAFavor = pc.FormaPagoSaldoAFavor, @ArticuloOfertaFP = pc.ArtOfertaFP, @CodigoRedondeo = pc.RedondeoVentaCodigo,@LDI = MonederoLDI
FROM POSCfg pc
WHERE Empresa = @Empresa
IF (SELECT ISNULL(VentaMonederoA,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
SET @LDI = 0
IF @FormaPago IS NULL
SELECT @Ok = 30530, @OkRef = @Codigo
IF @RequiereReferencia = 1
AND @MovClave NOT IN ('POS.AC','POS.AP', 'POS.CC', 'POS.CPC','POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.CTCM','POS.IC','POS.EC','POS.TRM','POS.CTRM')
BEGIN
IF NULLIF(@Referencia,'') IS NULL
SELECT @Ok = 20910, @OkRef = @FormaPago
END
IF ISNULL(@Importe,0) = 0 AND @Saldo <> 0
SELECT @Ok = 40140, @OkRef = @Codigo
EXEC xpPOSMovCobrarVerificar @ID, @Codigo, @Referencia, @FormaPago, @CtaDinero, @ToleranciaRedondeo, @CodigoAccion OUTPUT, @Importe OUTPUT, @Saldo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @MovClave IN ('POS.CC', 'POS.CPC','POS.CCM','POS.CPCM')
BEGIN
SELECT @ImporteEnCaja = SUM(plc.Importe * mt.Factor)
FROM POSLCobro plc
INNER JOIN POSL p ON plc.ID = p.ID
INNER JOIN MovTipo mt ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.Caja = @Caja
AND plc.FormaPago = @FormaPago
SELECT @ImporteEnMovimiento = SUM(Importe)
FROM POSLCobro pc
WHERE pc.ID = @ID
AND pc.FormaPago = @FormaPago
SELECT @ImporteEnCaja = ROUND(@ImporteEnCaja,@RedondeoMonetarios)
SELECT @ImporteEnMovimiento = ROUND(@ImporteEnMovimiento,@RedondeoMonetarios)
IF @Mov = 'CPC' AND (ISNULL(@Importe,0) + ISNULL(@ImporteEnMovimiento,0)) > ISNULL(@ImporteEnCaja,0) AND @Ok IS NULL
SELECT @Ok = 30455, @OkRef = @FormaPago
END
IF @Ok IS NULL AND @PermiteCambio = 0 AND @MovClave IN ('POS.F', 'POS.N', 'POS.A','POS.NPC','POS.AF', 'POS.CXCD', 'POS.CXCC')
BEGIN
SELECT @Comision3 = isnull(Comision3,0) FROM FormaPago WHERE FormaPago = @FormaPago
IF @Comision3 IS NULL
SELECT @Comision3 = 0
SELECT @CImporte = (@Importe *ISNULL(@Comision3,0.0)/100)
IF ROUND(@Importe,@RedondeoMonetarios) > ROUND(@Saldo+@CImporte, @RedondeoMonetarios)
SELECT @Ok = 30590, @OkRef = @FormaPago
END
IF @Ok IS NULL AND @PermiteCambio = 0 AND @MovClave IN ('POS.CXCC')
BEGIN
IF (SELECT ISNULL(Comision3,0) FROM FormaPago WHERE FormaPago = @FormaPago) > 0
BEGIN
SELECT @Comision3 = NULL, @CImporte = NULL
SELECT @Comision3 = isnull(Comision3,0) FROM FormaPago WHERE FormaPago = @FormaPago
SELECT @Comision3Porcentaje = (@Comision3 /100) + 1
SELECT @CImporte = (@Importe /@Comision3Porcentaje)
SELECT @Importe = (@Importe /@Comision3Porcentaje)
SELECT @CImporte = (@Importe *ISNULL(@Comision3,0.0)/100)
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef,
TipoCambio,	Voucher, Banco, MonedaRef,CtaDineroDestino)
VALUES (
@ID, @FormaPago, @CImporte, 'COMISION CREDITO', @CtaDinero, @Monedero, @Fecha, @CtaDinero, @Cajero, @Host, @CImporte,
ISNULL(@FormaPagoTipoCambio,1), @Voucher, @Banco,@FormaPagoMoneda,@CtaDineroDestino)
IF @@ERROR<> 0
SET @Ok = 1
END
END
IF @Importe < 0 AND ISNULL(@Cambio,0) = 0 AND @MovClave NOT IN ('POS.N','POS.NPC','POS.CXCD', 'POS.CC')
SELECT @Ok = 30351
IF @Ok IS NULL
BEGIN
SELECT
@Mov = Mov,
@MovID = MovID
FROM POSL pl
WHERE pl.ID = @ID
IF @MovID IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @Mov,
@MovID OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE POSL SET
MovID = @MovID,
Prefijo = @Prefijo,
Consecutivo = @Consecutivo,
noAprobacion = @noAprobacion,
fechaAprobacion = @fechaAprobacion
WHERE ID = @ID
END
END
IF @Ok IS NULL
BEGIN
SELECT @FormaPagoMoneda =
CASE WHEN @POSMonedaAct = 0
THEN ISNULL(NULLIF(Moneda,''), @MonedaPrincipal)
ELSE ISNULL(NULLIF(POSMoneda,''), @MonedaPrincipal)
END
FROM FormaPago
WHERE FormaPago = @FormaPago
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal
BEGIN
IF NOT EXISTS(SELECT TOP 1 TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @FormaPagoMoneda)
SELECT @ok = 35040, @okRef = @FormaPago
END
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal AND @MovClave IN( 'POS.FA', 'POS.CXCC','POS.CXCD' )
SELECT @ok = 30045, @okRef = @okRef+@FormaPago
IF @MovClave IN ('POS.AP','POS.IC','POS.EC') AND EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID)
BEGIN
IF EXISTS (SELECT * FROM POSLCobro WHERE ID = @ID AND MonedaRef <> @FormaPagoMoneda)
SELECT @Ok = 30084
END
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT TOP 1 @FormaPagoTipoCambio = ROUND(TipoCambio ,@RedondeoMonetarios)
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @FormaPagoMoneda
ELSE
SELECT @FormaPagoTipoCambio = 1
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal
AND @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC', 'POS.AP','POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.IC','POS.EC','POS.TRM') AND ISNULL(@Cambio,0) = 0
BEGIN
IF NOT EXISTS(SELECT TOP 1 TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @FormaPagoMoneda)
SELECT @ok = 35040, @okRef = @FormaPago
SELECT @ImporteRef = ROUND(@Importe,@RedondeoMonetarios)
SELECT @Importe = ROUND(ROUND(@Importe,@RedondeoMonetarios) * ISNULL(@FormaPagoTipoCambio,1.0),@RedondeoMonetarios)
END
ELSE
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal
AND @MovClave IN ('POS.N','POS.F','POS.NPC','POS.FA','POS.CXCC','POS.CXCD' ) AND ISNULL(@Cambio,0) = 0
BEGIN
IF NOT EXISTS(SELECT TOP 1 TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @FormaPagoMoneda)
SELECT @ok = 35040, @okRef = @FormaPago
SELECT @ImporteRef = ROUND(ROUND(@Importe,@RedondeoMonetarios) / ISNULL(@FormaPagoTipoCambio,1),@RedondeoMonetarios)
END
ELSE
SELECT @ImporteRef = ROUND(@Importe,@RedondeoMonetarios)
IF EXISTS(SELECT * FROM POSLRefBancaria WHERE ID = @ID)
BEGIN
SELECT TOP 1
@Voucher = Voucher,
@Banco = Banco
FROM POSLRefBancaria
WHERE ID = @ID
DELETE FROM POSLRefBancaria WHERE ID = @ID
END
IF ISNULL(@Cambio,0) = 1
BEGIN
SELECT @ImporteRef = ROUND(ROUND(@Importe,@RedondeoMonetarios)/ @FormaPagoTipoCambio,@RedondeoMonetarios)
END
IF @Ok IS NULL AND @MovClave IN ('POS.F', 'POS.N', 'POS.A','POS.NPC','POS.P')
BEGIN
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv
INNER JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
IF EXISTS(SELECT * FROM POSRedondeoTemp WHERE ID = @ID)
BEGIN
SELECT @ImporteRedondeo = ISNULL(Importe,0.0) FROM POSRedondeoTemp WHERE ID = @ID
IF  @ImporteRedondeo >0
BEGIN
EXEC spPOSVentaInsertaRedondeo @ID, 'INSERTAR', @ImporteRedondeo
EXEC spPOSVentaInsertaRedondeo @ID, 'ELIMINAR COBRO', NULL
END
END
IF EXISTS(SELECT * FROM  POSOfertaFormaPago
WHERE Estatus = 'ACTIVA' AND FormaPago = @FormaPago AND @Fecha BETWEEN ISNULL(FechaD,@Fecha)
AND ISNULL(FechaA,@Fecha) AND @HoraMinutos BETWEEN ISNULL(dbo.fnHoraEnEntero(HoraD),0)
AND ISNULL(dbo.fnHoraEnEntero(HoraA),1440)
GROUP BY  Descuento,MontoMinimo
HAVING @ImporteMov >=MAX(MontoMinimo))
AND NOT EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID)
AND NOT EXISTS (SELECT * FROM POSLVenta WHERE Articulo = @CfgAnticipoArticuloServicio AND ID = @ID)
BEGIN
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @Descuento = Descuento, @FormaPagoOfer = FormaPago
FROM POSOfertaFormaPago
WHERE Estatus = 'ACTIVA' AND FormaPago = @FormaPago AND @Fecha BETWEEN ISNULL(FechaD,@Fecha)
AND ISNULL(FechaA,@Fecha) AND  @HoraMinutos BETWEEN ISNULL(dbo.fnHoraEnEntero(HoraD),0)
AND ISNULL(dbo.fnHoraEnEntero(HoraA),1440)
GROUP BY Descuento,MontoMinimo,FormaPago
HAVING @ImporteMov >=MAX(MontoMinimo)
SELECT @ImporteOfer = (@ImporteMov-(@ImporteMov*(@Descuento/100)))
SELECT @ImporteOfer = ROUND(@ImporteOfer,@RedondeoMonetarios)
SELECT @PrecioOfer = ((@ImporteMov*(ISNULL(@Descuento,0.0)/100)))*-1
IF @Importe >= @ImporteOfer AND @FormaPago = @FormaPagoOfer
AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel))
BEGIN
SELECT @ArtTipo = Tipo, @Unidad = Unidad
FROM Art
WHERE Articulo = @ArticuloOfertaFP
SELECT @Renglon = MAX(Renglon)+2048.0, @RenglonID = MAX(RenglonID)+1
FROM POSLVenta
WHERE ID = @ID
SELECT @RenglonTipo = dbo.fnRenglonTipo(@ArtTipo)
DECLARE crDescuentoFP CURSOR LOCAL FOR
SELECT SUM(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100)))), ISNULL(plv.Impuesto1,0.0), ISNULL(plv.Impuesto2,0.0), ISNULL(plv.Impuesto3,0.0)
FROM POSLVenta plv
JOIN POSL p ON p.ID = plv.ID
WHERE  plv.ID = @ID   AND  plv.Articulo NOT IN( @ArticuloRedondeo,@ArticuloOfertaFP)
GROUP BY  ISNULL(plv.Impuesto1,0.0), ISNULL(plv.Impuesto2,0.0), ISNULL(plv.Impuesto3,0.0)
OPEN crDescuentoFP
FETCH NEXT FROM crDescuentoFP INTO @DImporte, @DImpuesto1, @DImpuesto2, @DImpuesto3
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @ImporteDescuento = (@DImporte*(ISNULL(@Descuento,0.0)/100))
SELECT @ImporteDescuento = ROUND(@ImporteDescuento,@RedondeoMonetarios)
INSERT POSLVenta(
ID, Renglon, RenglonSub, RenglonID,  RenglonTipo, Cantidad, Articulo, Precio, PrecioSugerido, Impuesto1, Impuesto2,
Impuesto3, PrecioImpuestoInc, Unidad, Factor, AplicaDescGlobal)
SELECT
@ID, @Renglon, 0, @RenglonID ,@RenglonTipo, -1, @ArticuloOfertaFP, @ImporteDescuento, @ImporteDescuento,  @DImpuesto1, @DImpuesto2,
@DImpuesto3, dbo.fnPOSPrecioConImpuestos(@ImporteDescuento, @DImpuesto1, @DImpuesto2, @DImpuesto3, @Empresa), @Unidad, 1, 0
SELECT  @Renglon = @Renglon +2048.0, @RenglonID = @RenglonID +1, @ImporteDescuento = 0.0
FETCH NEXT FROM crDescuentoFP INTO @DImporte, @DImpuesto1, @DImpuesto2, @DImpuesto3
END
CLOSE crDescuentoFP
DEALLOCATE crDescuentoFP
END
END
END
IF ISNULL(@Monedero,'') IS NOT NULL
SELECT @ImporteMonedero =  dbo.fnImporteMonTarjeta(@Importe, @FormaPagoMoneda, @FormaPagoTipoCambio, @MonederoMoneda, @MonederoTipoCambio, @Sucursal )
IF @MovClave IN ('POS.TCM','POS.CTCM')
BEGIN
UPDATE POSL SET Caja = @CtaDinero WHERE ID = @ID
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino)
VALUES (
@ID, @FormaPago, @Importe, @Referencia, @CtaDinero, @Monedero, @Fecha, @CtaDinero, @Cajero, @Host, @ImporteRef, @FormaPagoTipoCambio,
@Voucher, @Banco, @FormaPagoMoneda, @CtaDineroDestino)
IF @@ERROR<> 0
SET @Ok = 1
END
ELSE IF @MovClave IN ('POS.TRM','POS.CTRM' )
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino)
VALUES (
@ID, @FormaPago, @Importe, @Referencia, @CtaDinero, @Monedero, @Fecha, @CtaDinero, @Cajero, @Host, @ImporteRef, @FormaPagoTipoCambio,
@Voucher, @Banco, @FormaPagoMoneda, @CtaDineroDestino)
IF @@ERROR<> 0
SET @Ok = 1
END
ELSE IF @MovClave IN ('POS.CXCC' )
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte)
VALUES (
@ID, @FormaPago, @Importe, @Referencia, @CtaDinero, @Monedero, @Fecha, @Caja, @Cajero, @Host, @ImporteRef, @FormaPagoTipoCambio,
@Voucher, @Banco, @FormaPagoMoneda, @CtaDineroDestino, @MonederoMoneda, @MonederoTipoCambio, @ImporteMonedero)
IF @@ERROR<> 0
SET @Ok = 1
END
ELSE IF @MovClave NOT IN ('POS.CXCC','POS.TRM','POS.CTRM', 'POS.TCM','POS.CTCM')
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino, MonederoMoneda, MonederoTipoCambio, MonederoImporte)
VALUES (
@ID, @FormaPago, @Importe, @Referencia, @CtaDinero, @Monedero, @Fecha, @Caja, @Cajero, @Host, @ImporteRef, @FormaPagoTipoCambio,
@Voucher, @Banco, @FormaPagoMoneda, @CtaDineroDestino, @MonederoMoneda, @MonederoTipoCambio, @ImporteMonedero)
IF @@ERROR<> 0
SET @Ok = 1
END
SELECT @RIDCobro = SCOPE_IDENTITY()
IF @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.AP','POS.ACM','POS.CCM','POS.CPCM','POS.IC','POS.EC')
BEGIN
UPDATE POSL
SET Importe = (SELECT ROUND(SUM(ImporteRef*TipoCambio),@RedondeoMonetarios) FROM POSLCobro WHERE ID = @ID)
WHERE ID = @ID
END
END
IF ISNULL(@Monedero,'') IS NOT NULL AND NULLIF(@ImporteMonedero,0.0) IS NOT NULL AND ISNULL(@ImporteMonedero,0.0) <> 0.0
BEGIN
SELECT @SevicioLDI = Servicio
FROM POSLDIFormaPago plfp
WHERE plfp.FormaPago = @FormaPago
IF @ImporteMonedero < 0.0
BEGIN
SELECT @SevicioLDI = ServicioInverso
FROM POSLDIFormaPago plfp
WHERE plfp.FormaPago = @FormaPago
SELECT @ImporteMonedero = (@ImporteMonedero*-1)
END
IF @Monedero IS NOT NULL AND @SevicioLDI IS NOT NULL AND @Ok IS NULL AND ISNULL(@LDI,0) = 1
BEGIN
IF @SevicioLDI <> '9999'
EXEC spPOSLDI @SevicioLDI , @ID, @Monedero,@Empresa,@Usuario,@Sucursal, NULL, @ImporteMonedero ,1,NULL,
@Ok OUTPUT ,@OkRef OUTPUT  ,'POS',@RIDCobro = @RIDCobro
END
END
IF @Ok IS NULL
EXEC xpPOSMovCobrarDespues @ID, @Codigo, @Referencia, @FormaPago, @CtaDinero, @ToleranciaRedondeo, @CodigoAccion OUTPUT, @Importe OUTPUT, @Saldo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END

