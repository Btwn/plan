SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroVerificar
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
@EstatusNuevo	      	char(15),
@BeneficiarioNombre		varchar(100),
@CtaDinero			char(10),
@CtaDineroTipo		char(20),
@CtaDineroDestino		char(10),
@CtaDineroFactor		float,
@CtaDineroTipoCambio	float,
@CtaDineroMoneda		char(10),
@CtaDineroDestinoMoneda	char(10),
@CtaDineroDestinoTipo	char(20),
@CtaEmpresa			char(5),
@Cajero			char(10),
@FormaPago			varchar(50),
@Referencia	      		varchar(50),
@Importe			money,
@Impuestos			money,
@Saldo			money,
@Corte			int,
@CorteDestino		int,
@Dias			int,
@TasaDiaria			float,
@Retencion			money,
@CfgInversionIntereses	varchar(20),
@InteresTipo		varchar(20),
@Titulo			varchar(10),
@TituloValor		float,
@ValorOrigen		float,
@Contacto			char(10),
@ContactoTipo		varchar(20),
@ContactoEnviarA		int,
@Directo	                bit,
@ConDesglose                bit,
@CfgCajeros			bit,
@CfgSobregiros		bit,
@CfgFormaPagoRequerida	bit,
@CfgChequesDirectos		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@OrigenTipo			char(20),
@OrigenMovTipo		char(20),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Autorizacion		char(10),
@Autorizar			bit	     OUTPUT,
@ChequeDevuelto		bit, 
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT,
@EstacionTrabajo int = NULL 

AS BEGIN
DECLARE
@ImporteTotal 	money,
@ImporteD		money,
@SumaImporte	money,
@CtaSaldo		money,
@CajeroSaldo	money,
@FormaPagoD		varchar(50),
@ReferenciaD	varchar(50),
@FormaMoneda	char(10),
@FormaTipoCambio	float,
@FormaCobroVales	varchar(50),
@CfgValidarAF	varchar(20),
@SubClave   	varchar(20),
@Renglon            float,
@InterfazEmida		bit				
SELECT @InterfazEmida = ISNULL(InterfazEmida, 0) FROM EmpresaGral WHERE Empresa = @Empresa 
SELECT @FormaCobroVales = CxcFormaCobroVales,
@CfgValidarAF = UPPER(RHValidarAF)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Autorizar = 0
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
IF @MovTipo NOT IN ('DIN.CB','DIN.AB') SELECT @Impuestos = 0.0
IF @MovTipo IN ('DIN.CH', 'DIN.CHE') AND @Accion <> 'CANCELAR' AND UPPER(@ContactoTipo) = 'PERSONAL' AND @CfgValidarAF = 'PAGO'
BEGIN
IF (SELECT Estatus FROM Personal WHERE Personal = @Contacto) = 'BAJA'
IF EXISTS(SELECT * FROM ActivoF WHERE Empresa = @Empresa AND Responsable = @Contacto)
SELECT @Ok = 44160, @OkRef = @Contacto
END
SELECT @ImporteTotal = @Importe + @Impuestos
IF @MovTipo IN('DIN.CHE', 'DIN.CH', 'DIN.DE', 'DIN.D') AND @Accion = 'AFECTAR' AND @InterfazEmida = 1 AND dbo.fnDineroEsPagoEmida(@ID) > 1
SELECT @Ok = 20184, @OkRef = '(' + RTRIM(ISNULL(@Mov,'')) + ' ' + RTRIM(ISNULL(@MovID,'')) + ')'
IF @MovTipo IN ('DIN.CH') AND @Accion IN ('CANCELAR') AND @ChequeDevuelto = 1 AND @Ok IS NULL
SELECT @Ok = 35360, @OkRef = '(' + RTRIM(ISNULL(@Mov,'')) + ' ' + RTRIM(ISNULL(@MovID,'')) + ')' 
IF /*@CfgChequesDirectos = 0 AND */@MovTipo IN ('DIN.SCH', 'DIN.SCH', 'DIN.CH', 'DIN.CHE', 'DIN.SD', 'DIN.D', 'DIN.DE') AND @OrigenMovTipo IS NULL
BEGIN
SELECT @Ok = 35310
EXEC xpOk_35310 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('DIN.SD', 'DIN.SCH') AND @OrigenTipo NOT IN ('VTAS', 'CXC', 'AGENT', 'CXP', 'NOM', 'GAS', 'COMS', 'AF', 'CR', 'DIN', 'CAM') AND @Accion <> 'CANCELAR'
BEGIN
SELECT @Ok = 60420, @OkRef = @OrigenTipo
EXEC xpOk_60420 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('DIN.INV', 'DIN.RET') AND @InteresTipo = 'TITULO' AND (@Titulo IS NULL OR @TituloValor = 0.0 OR @ValorOrigen = 0.0)
SELECT @Ok = 10610
IF @Accion = 'CANCELAR'
BEGIN
IF @OrigenMovTipo IN ('DIN.C', 'DIN.CP') AND @Conexion = 0 AND @SubClave NOT IN('DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA')
SELECT @Ok = 30470
/*
IF @SubClave NOT IN('DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA')
SELECT @Corte = NULL, @CorteDestino = NULL
*/
IF @Corte IS NOT NULL OR @CorteDestino IS NOT NULL
IF NOT (@MovTipo IN ('DIN.C', 'DIN.CP') AND @ID = @Corte)
SELECT @Ok = 30470
IF @MovTipo IN ('DIN.I', 'DIN.SD' ,'DIN.E', 'DIN.F', 'DIN.SCH', 'DIN.INV', 'DIN.TI') AND @CtaDineroTipo <> 'CAJA'
IF ROUND(@Saldo, 2) <> ROUND(@ImporteTotal, 2) SELECT @Ok = 60060
IF @Conexion = 0
BEGIN
IF EXISTS(SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo IN ('DIN.CB', 'DIN.AB') AND @OrigenTipo = @Modulo AND @Ok IS NULL
SELECT @Ok = 60070
IF @MovTipo IN ('DIN.I', 'DIN.SD') AND @OrigenMovTipo = 'DIN.C' AND @Ok IS NULL
SELECT @Ok = 60072
IF @MovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.SCH') AND @OrigenMovTipo = 'DIN.TI' AND @Ok IS NULL
SELECT @Ok = 60072
END
END ELSE
BEGIN
IF @MovTipo = 'DIN.RE'
BEGIN
IF @OrigenTipo <> 'AUTO/RE' SELECT @Ok = 25410 ELSE
IF @MovTipoCambio <> 1 SELECT @Ok = 44090
END
IF @Accion = 'AFECTAR' AND @CtaDinero IS NOT NULL AND @Ok IS NULL
BEGIN
IF @CtaEmpresa IS NULL SELECT @Ok = 40160 ELSE
IF @CtaEmpresa <> @Empresa SELECT @Ok = 40170
END
IF @MovTipo NOT IN ('DIN.SD', 'DIN.SCH', 'DIN.DF', 'DIN.CD', 'DIN.RE', 'DIN.REI', 'DIN.RND') AND @Ok IS NULL
BEGIN
IF @ConDesglose = 0
BEGIN
IF @CfgFormaPagoRequerida = 1 AND @FormaPago IS NULL AND @Importe <> 0.0
SELECT @Ok = 30530
ELSE BEGIN
EXEC spFormaPagoMonTC @FormaPago, @Referencia, @MovMoneda, @MovTipoCambio, NULL, NULL, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
IF @MovMoneda <> @FormaMoneda SELECT @Ok = 30045, @OkRef = @FormaPago
END
IF @CfgFormaPagoRequerida = 1 AND NULLIF(@FormaPago, '') IS NOT NULL AND NULLIF(@Ok, 0) IS NULL
IF dbo.fnFormaPagoVerificar(@Empresa, @FormaPago, @Modulo, @Mov, @Usuario, '(Forma Pago)', 0) = 0
SELECT @Ok = 30600, @OkRef = dbo.fnIdiomaTraducir(@Usuario, 'Forma Pago') + '. ' + @FormaPago
END ELSE
BEGIN
SELECT @SumaImporte = 0.0
DECLARE crFormaPagoD CURSOR FOR
SELECT Renglon,NULLIF(RTRIM(FormaPago), ''), Referencia, ISNULL(Importe, 0.0)
FROM DineroD
WHERE ID = @ID AND ISNULL(Importe, 0.0) <> 0.0
OPEN crFormaPagoD
FETCH NEXT FROM crFormaPagoD INTO @Renglon,@FormaPagoD, @ReferenciaD, @ImporteD
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @CfgFormaPagoRequerida = 1 AND @FormaPagoD IS NULL
SELECT @Ok = 30530
ELSE
BEGIN
IF @SubClave NOT IN( 'DIN.AMULTIMONEDA','DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA')
BEGIN
EXEC spFormaPagoMonTC @FormaPagoD, @ReferenciaD, @MovMoneda, @MovTipoCambio, NULL, NULL, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
IF @MovMoneda <> @FormaMoneda SELECT @Ok = 30045, @OkRef = @FormaPagoD
END
END
IF @CfgFormaPagoRequerida = 1 AND NULLIF(@FormaPagoD, '') IS NOT NULL AND NULLIF(@Ok, 0) IS NULL
IF dbo.fnFormaPagoVerificar(@Empresa, @FormaPagoD, @Modulo, @Mov, @Usuario, '(Forma Pago)', 0) = 0
SELECT @Ok = 30600, @OkRef = dbo.fnIdiomaTraducir(@Usuario, 'Forma Pago') + '. ' + @FormaPagoD
SELECT @SumaImporte = @SumaImporte + @ImporteD
IF @Ok IS NULL AND @SubClave = 'DIN.AMULTIMONEDA' AND @MovTipo IN ('DIN.A')
EXEC spDineroVerificarAperturaMultimoneda @ID, @Renglon, @Empresa, @Estatus,  @MovTipo, @FormaPagoD, @ReferenciaD, @ImporteD ,@Ok OUTPUT ,@OkRef OUTPUT
IF @Ok IS NULL AND @SubClave IN('DIN.CMULTIMONEDA','DIN.CPMULTIMONEDA') AND @MovTipo IN ('DIN.C','DIN.CP')
EXEC spDineroVerificarCorteMultimoneda @ID, @Renglon, @Empresa, @Estatus,  @MovTipo, @FormaPagoD, @ReferenciaD, @ImporteD ,@Ok OUTPUT ,@OkRef OUTPUT
END
FETCH NEXT FROM crFormaPagoD INTO @Renglon,@FormaPagoD, @ReferenciaD, @ImporteD
END 
CLOSE crFormaPagoD
DEALLOCATE crFormaPagoD
IF @Ok IS NULL
IF ABS(ROUND(@SumaImporte, 0)) <> ABS(ROUND(@ImporteTotal, 0))  AND @SubClave NOT IN('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA' ) SELECT @Ok = 30230
END
END
IF @Importe = 0.0 AND @MovTipo NOT IN ('DIN.A', 'DIN.C', 'DIN.I', 'DIN.RE', 'DIN.REI', 'DIN.RND') OR
@Importe = 0.0 AND @MovTipo NOT IN ('DIN.A', 'DIN.C','DIN.CP', 'DIN.I', 'DIN.RE', 'DIN.REI', 'DIN.RND')AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA' )
SELECT @Ok = 30100
IF @MovTipo NOT IN ('DIN.I', 'DIN.SD', 'DIN.E', 'DIN.F', 'DIN.SCH') AND @CtaDineroTipo <> 'CAJA' OR (@MovTipo IN ('DIN.A','DIN.C','DIN.CP') AND @SubClave IN('DIN.AMULTIMONEDA','DIN.AMULTIMONEDA','DIN.AMULTIMONEDA') AND @CtaDineroTipo <> 'CAJA')
IF @CtaDinero IS NULL SELECT @Ok = 40120
IF @MovTipo IN ('DIN.DA', 'DIN.CNI') AND @Estatus = 'PENDIENTE' SELECT @Ok = 60040
IF @CtaDinero IS NOT NULL AND @Ok IS NULL AND @CtaDineroMoneda <> @MovMoneda AND @MovTipo NOT IN ('DIN.D', 'DIN.SD', 'DIN.SCH', 'DIN.RE', 'DIN.REI')
AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA' )
SELECT @Ok = 30040
IF @CtaDinero IS NOT NULL AND @Ok IS NULL AND @MovTipo = 'DIN.RE' AND @CtaDineroMoneda = @MovMoneda SELECT @Ok = 30040
IF @MovTipo IN ('DIN.CH', 'DIN.CHE') AND NULLIF(RTRIM(@BeneficiarioNombre), '') IS NULL SELECT @Ok = 35020
IF (@Importe < 0.0 OR @Impuestos < 0.0) AND @MovTipo NOT IN ('DIN.C', 'DIN.CP', 'DIN.RE', 'DIN.REI', 'DIN.RND', 'DIN.CB', 'DIN.AB') SELECT @Ok = 30100
IF @MovTipo IN ('DIN.T', 'DIN.TI', 'DIN.INV', 'DIN.RET', 'DIN.TC', 'DIN.A', 'DIN.AP', 'DIN.CP', 'DIN.C') AND @SubClave NOT IN('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA' )
BEGIN
IF @CtaDineroDestino IS NULL SELECT @Ok = 40040 ELSE
IF @CtaDineroDestino = @CtaDinero AND @Estatus = 'SINAFECTAR' SELECT @Ok = 40050
END
IF @MovTipo = 'DIN.INV'
BEGIN
IF @CtaDinero IS NOT NULL AND @CtaDineroDestino IS NOT NULL AND @Ok IS NULL AND @CtaDineroMoneda <> @CtaDineroDestinoMoneda AND @Estatus = 'SINAFECTAR' SELECT @Ok = 30081
END
IF @MovTipo IN ('DIN.T', 'DIN.TI', 'DIN.INV', 'DIN.RET') AND (@CtaDineroTipo = 'CAJA'  OR @CtaDineroDestinoTipo  = 'CAJA') SELECT @Ok = 40130 ELSE
IF @MovTipo = 'DIN.TC'  AND @SubClave NOT IN('DIN.TCULTIMONEDA') AND (@CtaDineroTipo <> 'CAJA' OR @CtaDineroDestinoTipo <> 'CAJA') SELECT @Ok = 40130
IF @CtaDineroTipo = 'ESTRUCTURA' OR @CtaDineroDestinoTipo = 'ESTRUCTURA' SELECT @Ok = 20680
IF @MovTipo IN ('DIN.A', 'DIN.AP') AND (@CtaDineroTipo = 'CAJA' AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ) OR @CtaDineroDestinoTipo <> 'CAJA')AND @SubClave NOT IN ('DIN.AMULTIMONEDA' )
SELECT @Ok = 30460
/*    IF @MovTipo = 'DIN.T' AND @Ok IS NULL
IF @CtaDineroDestinoMoneda <> @CtaDineroMoneda SELECT @Ok = 30220
*/
IF @Ok IS NOT NULL RETURN
SELECT @CtaSaldo = ISNULL(SUM(Saldo), 0.0)
FROM Saldo
WHERE Empresa = @Empresa
AND Rama = @Modulo
AND Moneda = @CtaDineroMoneda
AND Cuenta = @CtaDinero
IF @Directo = 0 AND @MovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE', 'DIN.I', 'DIN.E', 'DIN.F', 'DIN.INV', 'DIN.RET') AND (@Estatus <> 'PENDIENTE' OR @Accion = 'CANCELAR')
EXEC spDineroAplicar @Sucursal, @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, NULL, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, NULL, NULL, NULL, NULL,
@CtaDinero, @CtaDineroFactor, @CtaDineroTipoCambio, @ImporteTotal, @CfgContX, @CfgContXGenerar, 1,
@Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @EstacionTrabajo 
IF ((@CfgSobregiros = 1 AND @CtaDineroTipo <> 'CAJA') OR @Accion = 'VERIFICAR') AND @MovTipo IN ('DIN.E', 'DIN.F', 'DIN.CH', 'DIN.CHE', 'DIN.CB', 'DIN.DF', 'DIN.CP', 'DIN.C', 'DIN.T', 'DIN.TI', 'DIN.INV', 'DIN.RET', 'DIN.TC', 'DIN.A', 'DIN.AP') AND @CtaDinero IS NOT NULL AND @Ok IS NULL AND @Autorizacion IS NULL AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA','DIN.TCMULTIMONEDA' )
IF @CtaSaldo-@ImporteTotal < 0.0 SELECT @Ok = 60130, @Autorizar = 1
END
IF @MovTipo = 'DIN.A' AND @Accion = 'CANCELAR' AND @SubClave NOT IN ('DIN.AMULTIMONEDA' )
BEGIN
IF EXISTS(SELECT *
FROM Dinero f, MovTipo mt
WHERE f.ID > @ID AND f.Empresa = @Empresa AND f.Mov = mt.Mov AND mt.Clave IN ('DIN.I', 'DIN.E', 'DIN.F', 'DIN.TC', 'DIN.A', 'DIN.AP', 'DIN.CP') AND f.Estatus = 'CONCLUIDO' AND f.Moneda = @MovMoneda AND
((f.CtaDinero = @CtaDineroDestino AND f.Corte IS NULL) OR (f.CtaDineroDestino = @CtaDineroDestino AND f.CorteDestino IS NULL)))
SELECT @Ok = 30480
END
IF @Accion NOT IN ('GENERAR', 'CANCELAR') AND @Ok IS NULL AND @SubClave NOT IN ('DIN.AMULTIMONEDA' ,'DIN.CMULTIMONEDA' ,'DIN.CPMULTIMONEDA' )
EXEC spValidarMovImporteMaximo @Usuario, @Modulo, @Mov, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC xpDineroVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo, @BeneficiarioNombre,
@CtaDinero, @CtaDineroTipo, @CtaDineroDestino, @CtaDineroFactor, @CtaDineroTipoCambio, @CtaDineroMoneda, @CtaDineroDestinoMoneda, @CtaDineroDestinoTipo, @CtaEmpresa, @Cajero,
@Importe, @Impuestos, @Saldo, @Corte, @CorteDestino,
@Directo, @CfgContX, @CfgContXGenerar, @OrigenMovTipo, @Conexion, @SincroFinal, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

