SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCreditoVerificar
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
@EstatusNuevo		char(15),
@Referencia			varchar(50),
@Deudor			varchar(10),
@Acreedor			varchar(10),
@Importe			money,
@LineaCreditoEsp		bit,
@LineaCredito		varchar(20),
@LineaCreditoFondeo		varchar(20),
@TipoAmortizacion		varchar(20),
@TipoTasa			varchar(20),
@TieneTasaEsp		bit,
@TasaEsp			float,
@Condicion			varchar(50),
@Vencimiento		datetime,
@Comisiones			money,
@ComisionesIVA		money,
@CtaDinero			varchar(10),
@FormaPago			varchar(50),
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@OrigenEstatus	varchar(15),
@OrigenAcreedor 	varchar(10),
@OrigenImporte	money,
@OrigenMoneda	varchar(10)
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
BEGIN
IF NULLIF(@FormaPago, '') IS NOT NULL AND NULLIF(@Ok, 0) IS NULL
BEGIN
IF dbo.fnFormaPagoVerificar(@Empresa, @FormaPago, @Modulo, @Mov, @Usuario, '(Forma Pago)', 0) = 0
SELECT @Ok = 30600, @OkRef = dbo.fnIdiomaTraducir(@Usuario, 'Forma Pago') + '. ' + @FormaPago
END
IF @Importe = 0.0 SELECT @Ok = 40140 ELSE
IF @Referencia IS NULL SELECT @Ok = 20910
IF @MovTipo <> 'CREDI.DA'
BEGIN
IF @LineaCreditoEsp = 1 AND NOT EXISTS (SELECT * FROM LC WHERE LineaCredito = @LineaCredito AND Estatus = 'ALTA') SELECT @Ok = 20073, @OkRef = @LineaCredito ELSE
IF @LineaCreditoEsp = 0 AND @LineaCredito IS NOT NULL SELECT @Ok = 20072 ELSE
IF @TipoTasa   IS NULL SELECT @Ok = 40200 ELSE
IF @TipoAmortizacion IS NULL SELECT @Ok = 40210 ELSE
IF @Vencimiento IS NULL SELECT @Ok = 40230 ELSE
IF @Vencimiento < @FechaEmision SELECT @Ok = 30020
END
IF @MovTipo IN ('CREDI.FEX', 'CREDI.FIN', 'CREDI.CES', 'CREDI.DIS', 'CREDI.BTB') AND @Ok IS NULL
BEGIN
IF @Deudor IS NULL SELECT @Ok = 40011 ELSE
IF NOT EXISTS(SELECT * FROM Prov WHERE Proveedor = @Deudor AND Estatus = 'ALTA') SELECT @Ok = 20940, @OkRef = @Deudor
END
IF @MovTipo = 'CREDI.BTB'
BEGIN
IF NOT EXISTS(SELECT * FROM LC WHERE LineaCredito = @LineaCreditoFondeo AND Estatus = 'ALTA')
SELECT @Ok = 20074, @OkRef = @LineaCreditoFondeo
END
IF @MovTipo IN ('CREDI.FEX', 'CREDI.FIN', 'CREDI.CES', 'CREDI.FON', 'CREDI.DA', 'CREDI.FOA') AND @Ok IS NULL
BEGIN
IF @Acreedor IS NULL SELECT @Ok = 40021
END
END
IF @MovTipo = 'CREDI.FOA'
BEGIN
SELECT @OrigenEstatus = NULL
SELECT @OrigenEstatus = Estatus, @OrigenAcreedor = Acreedor, @OrigenImporte = Importe, @OrigenMoneda = Moneda
FROM Credito
WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @OrigenEstatus <> CASE WHEN @Accion = 'CANCELAR' THEN 'CONCLUIDO' ELSE 'PENDIENTE' END OR @OrigenAcreedor <> @Acreedor OR @OrigenImporte <> @Importe OR @OrigenTipo <> @Modulo OR @OrigenMoneda <> @MovMoneda
SELECT @Ok = 20380, @OkRef = @Origen+' '+@OrigenID
END
RETURN
END

