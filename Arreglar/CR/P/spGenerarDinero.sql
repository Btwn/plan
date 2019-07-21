SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGenerarDinero]
 @Sucursal INT
,@SucursalOrigen INT
,@SucursalDestino INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaAfectacion DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@ConDesglose BIT
,@GenerarSolicitud BIT
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@FormaPago VARCHAR(50)
,@Tipo CHAR(20)
,@Beneficiario INT
,@Cuenta CHAR(10)
,@CtaDinero CHAR(10)
,@Cajero CHAR(10)
,@Importe MONEY
,@Impuestos MONEY
,@MovEspecifico CHAR(20)
,@BeneficiarioEspecifico VARCHAR(100)
,@Vencimiento DATETIME
,@DineroMov CHAR(20) OUTPUT
,@DineroMovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@ContactoEspecifico CHAR(10) = NULL
,@IVAFiscal FLOAT = NULL
,@IEPSFiscal FLOAT = NULL
,@DesgloseManual BIT = 0
,@OrigenTipo CHAR(10) = NULL
,@ProveedorAutoEndoso VARCHAR(10) = NULL
,@Nota VARCHAR(100) = NULL
,@IgnorarFormaPago BIT = 0
,@SeparacionDelIVA BIT = 0
,@EstacionTrabajo INT = NULL
AS
BEGIN
	DECLARE
		@DineroID INT
	   ,@IDGenerar INT
	   ,@OID INT
	   ,@AplicaMov CHAR(20)
	   ,@AplicaMovID VARCHAR(20)
	   ,@CtaDineroTipo CHAR(20)
	   ,@CfgMovDeposito CHAR(20)
	   ,@CfgMovCheque CHAR(20)
	   ,@CfgMovChequeTraspaso CHAR(20)
	   ,@CfgMovSolicitudDeposito CHAR(20)
	   ,@CfgMovSolicitudCheque CHAR(20)
	   ,@CfgMovChequeDevuelto CHAR(20)
	   ,@CfgMovCajaIngreso CHAR(20)
	   ,@CfgMovCajaEgreso CHAR(20)
	   ,@CfgTipoAfectacion CHAR(20)
	   ,@CfgCargoBancario CHAR(20)
	   ,@CfgCargoBancarioIVA CHAR(20)
	   ,@CfgAbonoBancario CHAR(20)
	   ,@CfgAbonoBancarioIVA CHAR(20)
	   ,@CfgCreditoDA CHAR(20)
	   ,@CfgEmpresaDinero CHAR(5)
	   ,@CfgFormaPagoCambio VARCHAR(50)
	   ,@CfgFormaPagoRequerida BIT
	   ,@ImporteTotal MONEY
	   ,@MovIngreso CHAR(20)
	   ,@MovEgreso CHAR(20)
	   ,@DineroEstatus CHAR(15)
	   ,@DineroAccion CHAR(20)
	   ,@Nombre VARCHAR(100)
	   ,@BeneficiarioNombre VARCHAR(100)
	   ,@LeyendaCheque VARCHAR(100)
	   ,@DineroMovTipo CHAR(20)
	   ,@GenerarDinero BIT
	   ,@FormasPagoRestringidas BIT
	   ,@Contacto CHAR(10)
	   ,@ContactoTipo VARCHAR(20)
	   ,@ContactoEnviarA INT
	   ,@OrigenID INT
	   ,@OrigenEstatus CHAR(15)
	   ,@OrigenSucursal INT
	   ,@OrigenUEN INT
	   ,@Hoy DATETIME
	   ,@DetalleNegativo BIT
	   ,@ArrastrarMovID BIT
	   ,@Financiamiento MONEY
	   ,@CxcMov VARCHAR(20)
	   ,@OrigenCxc VARCHAR(20)
	   ,@OrigenIDCxc VARCHAR(20)
	   ,@OrigenTipoCxc VARCHAR(10)
	   ,@IDVenta INT
	SELECT @DineroID = NULL
		  ,@Nombre = NULL
		  ,@BeneficiarioNombre = NULL
		  ,@LeyendaCheque = NULL
		  ,@MovIngreso = NULL
		  ,@MovEgreso = NULL
		  ,@CtaDineroTipo = NULL
		  ,@DineroMov = NULL
		  ,@DineroMovID = NULL
		  ,@DineroEstatus = 'SINAFECTAR'
		  ,@DineroAccion = @Accion
		  ,@FormasPagoRestringidas = 1
		  ,@DetalleNegativo = 0
		  ,@Contacto = NULL
		  ,@ContactoTipo = NULL
		  ,@ContactoEnviarA = NULL
	SET @Financiamiento = 0.0
	SET @CxcMov = NULL

	IF @Modulo = 'CXC'
	BEGIN

		IF @Mov IN ('Credilana', 'Prestamo Personal', 'Cancela Credilana', 'Cancela Prestamo')
		BEGIN
			SELECT @OrigenCxc = Origen
				  ,@OrigenIDCxc = OrigenID
				  ,@OrigenTipoCxc = OrigenTipo
			FROM Cxc
			WHERE ID = @ID

			IF @OrigenTipoCxc = 'VTAS'
			BEGIN
				SELECT @IDVenta = ID
				FROM Venta
				WHERE Mov = @OrigenCxc
				AND MovID = @OrigenIDCxc
				AND Estatus IN ('Concluido', 'Pendiente', 'Cancelado')
				EXEC spObtenerFinanciamientoMAVI @IDVenta
												,@Financiamiento OUTPUT
				SET @Importe = @Importe - ISNULL(@Financiamiento, 0.0)
			END

		END

	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'AGENT'
	BEGIN

		IF @Mov = 'Canc Dif Caja'
		BEGIN
			SELECT @Ok = 80200
		END

	END

	SELECT @CtaDinero = NULLIF(RTRIM(@CtaDinero), '')
	EXEC xpCuentaDineroNivelSucursal @Empresa
									,@Sucursal
									,@FormaPago
									,@CtaDinero OUTPUT
									,@Ok OUTPUT
									,@OkRef OUTPUT

	IF @Modulo = 'CXC'
		SELECT @Contacto = Cte.Cliente
			  ,@ContactoEnviarA = Cxc.ClienteEnviarA
			  ,@ContactoTipo = 'Cliente'
			  ,@FormasPagoRestringidas = Cte.FormasPagoRestringidas
			  ,@IVAFiscal = Cxc.IVAFiscal
			  ,@IEPSFiscal = Cxc.IEPSFiscal
		FROM Cxc
			,Cte
		WHERE Cxc.ID = @ID
		AND Cxc.Cliente = Cte.Cliente

	IF @Modulo = 'VTAS'
		SELECT @Contacto = Cte.Cliente
			  ,@ContactoTipo = 'Cliente'
			  ,@FormasPagoRestringidas = Cte.FormasPagoRestringidas
			  ,@IVAFiscal = Venta.IVAFiscal
			  ,@IEPSFiscal = Venta.IEPSFiscal
		FROM Venta
			,Cte
		WHERE Venta.ID = @ID
		AND Venta.Cliente = Cte.Cliente

	IF @Modulo = 'CXP'
		SELECT @Contacto = Proveedor
			  ,@ContactoTipo = 'Proveedor'
			  ,@IVAFiscal = IVAFiscal
			  ,@IEPSFiscal = IEPSFiscal
		FROM Cxp
		WHERE ID = @ID

	IF @Modulo = 'GAS'
		SELECT @Contacto = Acreedor
			  ,@ContactoTipo = 'Proveedor'
			  ,@IVAFiscal = IVAFiscal
			  ,@IEPSFiscal = IEPSFiscal
		FROM Gasto
		WHERE ID = @ID

	IF @Modulo = 'AF'
		SELECT @Contacto = Proveedor
			  ,@ContactoTipo = 'Proveedor'
		FROM ActivoFijo
		WHERE ID = @ID

	IF @Modulo = 'COMS'
		SELECT @Contacto = Proveedor
			  ,@ContactoTipo = 'Proveedor'
		FROM Compra
		WHERE ID = @ID

	IF @Modulo = 'CREDI'
		SELECT @Contacto = Acreedor
			  ,@ContactoTipo = 'Proveedor'
		FROM Credito
		WHERE ID = @ID

	IF @Modulo = 'AGENT'
		SELECT @Contacto = Agente
			  ,@ContactoTipo = 'Agente'
		FROM Agent
		WHERE ID = @ID

	IF @Modulo = 'NOM'
	BEGIN

		IF @ContactoEspecifico IS NOT NULL
			SELECT @Contacto = @ContactoEspecifico
				  ,@ContactoTipo = 'Personal'
		ELSE
		BEGIN
			SELECT @Contacto = MIN(Proveedor)
			FROM Prov
			WHERE Nombre = @BeneficiarioEspecifico

			IF @Contacto IS NOT NULL
				SELECT @ContactoTipo = 'Proveedor'

		END

	END

	IF @Modulo = 'VALE'
		SELECT @Contacto = Cliente
			  ,@ContactoTipo = 'Cliente'
			  ,@ImporteTotal = ISNULL(Importe, 0)
		FROM Vale
		WHERE ID = @ID

	IF @Modulo = 'CR'
		SELECT @Contacto = Cajero
			  ,@ContactoTipo = 'Agente'
		FROM CR
		WHERE ID = @ID

	IF @Modulo = 'CAM'
		SELECT @Contacto = Cliente
			  ,@ContactoTipo = 'Cliente'
			  ,@Referencia = LTRIM(CONVERT(CHAR, @MovID))
		FROM Cambio
		WHERE ID = @ID

	SELECT @CfgFormaPagoCambio = FormaPagoCambio
		  ,@CfgFormaPagoRequerida = FormaPagoRequerida
	FROM EmpresaCfg
	WHERE Empresa = @Empresa
	SELECT @CfgMovSolicitudDeposito = BancoSolicitudDeposito
		  ,@CfgMovDeposito = BancoDeposito
		  ,@CfgMovSolicitudCheque = BancoSolicitudCheque
		  ,@CfgMovCheque = BancoCheque
		  ,@CfgMovChequeTraspaso = BancoChequeTraspaso
		  ,@CfgMovCajaIngreso = CajaIngreso
		  ,@CfgMovCajaEgreso = CajaEgreso
		  ,@CfgMovChequeDevuelto =
		   CASE @Modulo
			   WHEN 'CXC' THEN NULLIF(RTRIM(BancoDepositoEnFalso), '')
			   WHEN 'CXP' THEN NULLIF(RTRIM(BancoChequeDevuelto), '')
			   ELSE NULL
		   END
		  ,@CfgCargoBancario = BancoCargoBancario
		  ,@CfgCargoBancarioIVA = BancoCargoBancarioIVA
		  ,@CfgAbonoBancario = BancoAbonoBancario
		  ,@CfgAbonoBancarioIVA = BancoAbonoBancarioIVA
		  ,@CfgCreditoDA = CreditoDepositoAnticipado
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa

	IF @@ERROR <> 0
		SELECT @Ok = 1

	SELECT @CtaDineroTipo = ISNULL(UPPER(Tipo), 'BANCO')
	FROM CtaDinero
	WHERE CtaDinero = @CtaDinero
	SELECT @CfgEmpresaDinero = UPPER(NULLIF(RTRIM(EmpresaDinero), ''))
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @@ERROR <> 0
		SELECT @Ok = 1

	IF @CfgEmpresaDinero <> 'MISMA'
		AND @CfgEmpresaDinero <> 'MISMO'
		AND @CfgEmpresaDinero IS NOT NULL
		SELECT @Empresa = @CfgEmpresaDinero

	IF @IgnorarFormaPago = 0
		AND @CtaDinero IS NOT NULL
		AND @FormaPago IS NOT NULL
		SELECT @MovIngreso = NULLIF(RTRIM(MovIngresos), '')
			  ,@MovEgreso = NULLIF(RTRIM(MovEgresos), '')
		FROM FormaPago
		WHERE FormaPago = @FormaPago

	IF @MovIngreso IS NULL
		SELECT @MovIngreso =
		 CASE @CtaDineroTipo
			 WHEN 'CAJA' THEN @CfgMovCajaIngreso
			 ELSE @CfgMovSolicitudDeposito
		 END

	IF @MovEgreso IS NULL
		SELECT @MovEgreso =
		 CASE @CtaDineroTipo
			 WHEN 'CAJA' THEN @CfgMovCajaEgreso
			 ELSE @CfgMovSolicitudCheque
		 END

	IF @MovTipo IN ('VTAS.N', 'VTAS.FM', 'VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.P', 'VTAS.S')
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovIngreso
		ELSE
		BEGIN
			SELECT @DineroMov = @MovEgreso
				  ,@Importe = -@Importe
				  ,@ConDesglose = 0

			IF @Cuenta IS NOT NULL
				SELECT @BeneficiarioNombre = NULLIF(RTRIM(Nombre), '')
				FROM Cte
				WHERE Cliente = @Cuenta

		END

	END
	ELSE

	IF @MovTipo IN ('VTAS.VP', 'VTAS.SD', 'VTAS.B', 'VTAS.D', 'VTAS.DF')
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovEgreso
		ELSE
			SELECT @DineroMov = @MovIngreso
				  ,@Importe = -@Importe
				  ,@DetalleNegativo = 1

	END
	ELSE

	IF @MovTipo = 'DIN.TI'
		SELECT @DineroMov = @CfgMovChequeTraspaso
			  ,@ContactoTipo = 'Empresa'
			  ,@Contacto = @Empresa
			  ,@BeneficiarioNombre = Nombre
		FROM Empresa
		WHERE Empresa = @Empresa
	ELSE

	IF @MovTipo IN ('DIN.C', 'DIN.CP')
	BEGIN

		IF @OrigenTipo = 'CR'
			SELECT @MovIngreso = @CfgMovDeposito
				  ,@MovEgreso = @CfgMovCheque

		IF @Importe > 0.0
			SELECT @DineroMov = @MovIngreso
		ELSE
			SELECT @DineroMov = @MovEgreso
				  ,@Importe = -@Importe
				  ,@DetalleNegativo = 1

	END
	ELSE

	IF @MovTipo IN ('CXC.C', 'CXC.DP', 'CXC.NCP', 'CXC.ANC', 'CXC.A', 'CXC.AA', 'CXC.AR',
		'CXP.CAP', 'CXP.C', 'CXP.DE', 'CXP.DC', 'GAS.DA', 'GAS.DC', 'GAS.OI', 'AGENT.CO')
		OR (@Mov IN ('Cancela Credilana', 'Cancela Prestamo') AND ISNULL(@OrigenTipoCxc, '') = 'VTAS')
		SELECT @DineroMov = @MovIngreso
	ELSE

	IF @MovTipo IN ('CXP.P', 'CXP.DP', 'CXP.NCP', 'CXP.ANC', 'CXP.A', 'CXP.AA', 'CXC.CAP', 'CXC.DE', 'CXC.DFA', 'CXC.DI', 'CXC.DC',
		'AGENT.P', 'AGENT.A', 'GAS.A', 'GAS.C', 'GAS.CCH', 'GAS.CP', 'AF.RE', 'AF.MA', 'AF.PS', 'AF.PM')
	BEGIN
		SELECT @DineroMov = @MovEgreso

		IF @Cuenta IS NOT NULL
		BEGIN

			IF @Modulo = 'CXC'
			BEGIN
				SELECT @BeneficiarioNombre = NULLIF(RTRIM(Nombre), '')
				FROM Cte
				WHERE Cliente = @Cuenta

				IF (
						SELECT CxcEnviarABeneficiario
						FROM EmpresaCfg2
						WHERE Empresa = @Empresa
					)
					= 1
					SELECT @BeneficiarioNombre = NULLIF(RTRIM(Nombre), '')
					FROM CteEnviarA
					WHERE Cliente = @Contacto
					AND ID = @ContactoEnviarA

			END
			ELSE

			IF @Modulo IN ('CXP', 'GAS', 'AF')
				SELECT @Nombre = NULLIF(RTRIM(Nombre), '')
					  ,@BeneficiarioNombre = NULLIF(RTRIM(BeneficiarioNombre), '')
					  ,@LeyendaCheque = NULLIF(RTRIM(LeyendaCheque), '')
				FROM Prov
				WHERE Proveedor = @Cuenta

			IF @Modulo = 'AGENT'
				SELECT @Nombre = NULLIF(RTRIM(Nombre), '')
					  ,@BeneficiarioNombre = NULLIF(RTRIM(BeneficiarioNombre), '')
				FROM Agente
				WHERE Agente = @Cuenta

			IF @BeneficiarioNombre IS NULL
				SELECT @BeneficiarioNombre = @Nombre

		END

	END
	ELSE

	IF @MovTipo IN ('GAS.CB', 'GAS.AB')
	BEGIN
		SELECT @DineroMovID = @MovID

		IF @SeparacionDelIVA = 0
		BEGIN

			IF @MovTipo = 'GAS.CB'
			BEGIN

				IF @Mov = 'Devolucion Efectivo'
					SELECT @DineroMov = 'Devolucion Efectivo'
				ELSE
					SELECT @DineroMov = @CfgCargoBancario

			END
			ELSE

			IF @MovTipo = 'GAS.AB'
				SELECT @DineroMov = @CfgAbonoBancario

		END
		ELSE
		BEGIN

			IF @MovTipo = 'GAS.CB'
			BEGIN

				IF @Mov = 'Devolucion Efectivo'
					SELECT @DineroMov = 'Dev Efectivo IVA'
				ELSE
					SELECT @DineroMov = @CfgCargoBancarioIVA

			END
			ELSE

			IF @MovTipo = 'GAS.AB'
				SELECT @DineroMov = @CfgAbonoBancarioIVA

		END

		IF EXISTS (SELECT * FROM MovTipo WHERE Modulo = 'DIN' AND Mov = @DineroMov AND GenerarGasto = 1)
			SELECT @Ok = 70140
				  ,@OkRef = @DineroMov

	END
	ELSE

	IF @MovTipo IN ('CXC.CD', 'CXP.CD')
		SELECT @DineroMov = @CfgMovChequeDevuelto
	ELSE

	IF @MovTipo IN ('AC.SE', 'AC.C')
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovIngreso
		ELSE
			SELECT @DineroMov = @MovEgreso
				  ,@Importe = -@Importe
				  ,@DetalleNegativo = 1

	END
	ELSE

	IF @MovTipo IN ('AC.D', 'AC.R')
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovEgreso
		ELSE
			SELECT @DineroMov = @MovIngreso
				  ,@Importe = -@Importe
				  ,@DetalleNegativo = 1

	END
	ELSE

	IF @MovTipo IN ('CAM.O', 'CAM.V', 'CAM.S')
	BEGIN

		IF @MovTipo = 'CAM.V'
			AND UPPER(@Tipo) IN ('COMPRA', 'COBRO')
		BEGIN
			SELECT @DineroMov = @MovIngreso
		END
		ELSE
		BEGIN
			SELECT @DineroMov = @MovEgreso
			SELECT @BeneficiarioNombre = NULLIF(RTRIM(Nombre), '')
			FROM Beneficiario
			WHERE Beneficiario = @Beneficiario

			IF @BeneficiarioNombre IS NULL
				SELECT @BeneficiarioNombre = '.'

		END

	END
	ELSE

	IF @MovTipo IN ('VALE.A', 'VALE.AT')
		SELECT @DineroMov = @MovEgreso
			  ,@BeneficiarioNombre = RTRIM(@Mov) + ' ' + RTRIM(@MovID)
	ELSE

	IF @MovTipo = 'NOM.DP'
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovIngreso
		ELSE
			SELECT @DineroMov = @MovEgreso
				  ,@BeneficiarioNombre = @BeneficiarioEspecifico
				  ,@Importe = -@Importe

	END
	ELSE

	IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NC')
	BEGIN

		IF @Importe > 0.0
			SELECT @DineroMov = @MovEgreso
				  ,@DineroMov = ISNULL(NULLIF(RTRIM(@MovEspecifico), ''), @MovEgreso)
				  ,@BeneficiarioNombre = @BeneficiarioEspecifico
		ELSE
			SELECT @DineroMov = @MovIngreso
				  ,@Importe = -@Importe

	END
	ELSE

	IF @MovTipo = 'CREDI.DA'
		SELECT @DineroMov = @CfgCreditoDA
	ELSE

	IF @MovTipo = 'NOM.PI'
		SELECT @DineroMov = @MovEgreso
			  ,@BeneficiarioNombre = @BeneficiarioEspecifico
	ELSE

	IF @MovEspecifico IS NOT NULL
		SELECT @DineroMov = @MovEspecifico
	ELSE
		SELECT @Ok = 70020

	IF EXISTS (SELECT * FROM EmpresaCfgMovGenera WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND GeneraModulo = 'DIN')
	BEGIN
		SELECT @DineroMov = GeneraMov
			  ,@ArrastrarMovID = ArrastrarMovID
		FROM EmpresaCfgMovGenera
		WHERE Empresa = @Empresa
		AND Modulo = @Modulo
		AND Mov = @Mov
		AND GeneraModulo = 'DIN'

		IF @ArrastrarMovID = 1
			SELECT @DineroMovID = @MovID

	END

	IF @DineroMov IS NULL
		SELECT @Ok = 70020

	SELECT @DineroMovTipo = Clave
	FROM MovTipo
	WHERE Modulo = 'DIN'
	AND Mov = @DineroMov

	IF @Ok IS NOT NULL
		RETURN

	IF @Accion = 'CANCELAR'
		SELECT @GenerarDinero = 0
	ELSE
		SELECT @GenerarDinero = 1

	IF @Modulo = 'CXC'
		UPDATE Cxc
		SET GenerarDinero = @GenerarDinero
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		UPDATE Cxp
		SET GenerarDinero = @GenerarDinero
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		UPDATE Gasto
		SET GenerarDinero = @GenerarDinero
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		UPDATE Venta
		SET GenerarDinero = @GenerarDinero
		WHERE ID = @ID

	IF @Accion = 'CANCELAR'
		OR @Tipo = 'APLICA_POSFECHADO'
	BEGIN
		SELECT @OID = NULL

		IF @Tipo = 'APLICA_POSFECHADO'
		BEGIN

			IF @MovTipo IN ('CXC.ANC', 'CXP.ANC')
			BEGIN

				IF @Modulo = 'CXC'
					SELECT @OID = c.ID
						  ,@AplicaMov = c.Mov
						  ,@AplicaMovID = c.MovID
					FROM Cxc d
						,Cxc c
					WHERE d.ID = @ID
					AND d.MovAplica = c.Mov
					AND d.MovAplicaID = c.MovID
					AND c.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'CANCELADO')
					AND c.Empresa = @Empresa
				ELSE

				IF @Modulo = 'CXP'
					SELECT @OID = c.ID
						  ,@AplicaMov = c.Mov
						  ,@AplicaMovID = c.MovID
					FROM Cxp d
						,Cxp c
					WHERE d.ID = @ID
					AND d.MovAplica = c.Mov
					AND d.MovAplicaID = c.MovID
					AND c.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'CANCELADO')
					AND c.Empresa = @Empresa

			END
			ELSE
			BEGIN

				IF @Modulo = 'CXC'
					SELECT @OID = c.ID
						  ,@AplicaMov = d.Aplica
						  ,@AplicaMovID = d.AplicaID
					FROM CxcD d
						,Cxc c
					WHERE d.ID = @ID
					AND d.Aplica = c.Mov
					AND d.AplicaID = c.MovID
					AND c.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'CANCELADO')
					AND c.Empresa = @Empresa
				ELSE

				IF @Modulo = 'CXP'
					SELECT @OID = c.ID
						  ,@AplicaMov = d.Aplica
						  ,@AplicaMovID = d.AplicaID
					FROM CxpD d
						,Cxp c
					WHERE d.ID = @ID
					AND d.Aplica = c.Mov
					AND d.AplicaID = c.MovID
					AND c.Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'CANCELADO')
					AND c.Empresa = @Empresa

			END

		END
		ELSE
			SELECT @OID = @ID

		IF @OID IS NULL
			SELECT @Ok = 60220

		SELECT @DineroID = DID
			  ,@DineroMov = DMov
			  ,@DineroMovID = DMovID
		FROM MovFlujo
		WHERE Cancelado = 0
		AND Empresa = @Empresa
		AND OModulo = @Modulo
		AND OID = @OID
		AND DModulo = 'DIN'

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @DineroID IS NULL
			AND @Mov NOT IN ('Canc Dif Caja')
		BEGIN

			IF @Accion = 'CANCELAR'
				SELECT @Ok = NULL

			SELECT @OkRef = NULL
		END
		ELSE
		BEGIN

			IF @Tipo = 'APLICA_POSFECHADO'
				AND @Accion <> 'CANCELAR'
			BEGIN
				SELECT @Hoy = GETDATE()
				EXEC spExtraerFecha @Hoy OUTPUT
				UPDATE Dinero
				SET FechaEmision = @Hoy
				WHERE ID = @DineroID
				AND Estatus = 'POSFECHADO'
			END

		END

	END
	ELSE
	BEGIN
		SELECT @DineroAccion = 'AFECTAR'

		IF @Modulo NOT IN ('DIN', 'NOM')
			AND @MovTipo NOT IN ('CXC.C', 'CXC.DE', 'CXC.DFA', 'CXC.A', 'CXC.AA', 'CXC.AR', 'CXC.CAP', 'VTAS.N', 'VTAS.FM', 'VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.P', 'VTAS.S')
			SELECT @ConDesglose = 0

		IF @MovTipo IN ('CXC.DP', 'CXC.NCP', 'CXP.DP', 'CXP.NCP')
		BEGIN
			SELECT @DineroEstatus = 'POSFECHADO'

			IF @DineroAccion = 'AFECTAR'
				SELECT @DineroAccion = 'CONSECUTIVO'

		END

		SELECT @ImporteTotal = @Importe + ISNULL(@Impuestos, 0.0)
		SELECT @OrigenID = dbo.fnModuloID(@Empresa, @Modulo, @Mov, @MovID, @Ejercicio, @Periodo)
		EXEC spMovInfo NULL
					  ,@Modulo
					  ,@Mov
					  ,@MovID
					  ,@OrigenEstatus OUTPUT
					  ,@OrigenSucursal OUTPUT
					  ,@OrigenUEN OUTPUT
					  ,@Empresa = @Empresa
		INSERT Dinero (Sucursal, SucursalOrigen, SucursalDestino, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, CtaDinero, Cajero, Importe, Impuestos, BeneficiarioNombre, LeyendaCheque, Beneficiario, ConDesglose, FormaPago, OrigenTipo, Origen, OrigenID, UEN, FechaProgramada, IVAFiscal, IEPSFiscal, Contacto, ContactoTipo, ContactoEnviarA, ProveedorAutoEndoso, Nota)
			VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @DineroMov, @DineroMovID, @FechaAfectacion, @Concepto, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @DineroEstatus, @CtaDinero, @Cajero, @Importe, @Impuestos, @BeneficiarioNombre, @LeyendaCheque, @Beneficiario, 1, @FormaPago, @Modulo, @Mov, @MovID, @OrigenUEN, @Vencimiento, @IVAFiscal, @IEPSFiscal, @Contacto, @ContactoTipo, @ContactoEnviarA, @ProveedorAutoEndoso, @Nota)

		IF @@ERROR <> 0
			SELECT @Ok = 1

		SELECT @DineroID = SCOPE_IDENTITY()

		IF @ConDesglose = 0
			OR @DesgloseManual = 1
			INSERT DineroD (Sucursal, ID, Renglon, Importe, FormaPago, Referencia)
				VALUES (@Sucursal, @DineroID, 2048, @ImporteTotal, @FormaPago, @Referencia)
		ELSE
			EXEC spGenerarDineroDesglose @Sucursal
										,@Modulo
										,@ID
										,@DineroID
										,@CtaDinero
										,@BeneficiarioEspecifico
										,@CfgFormaPagoCambio
										,@Ok OUTPUT

		IF @DetalleNegativo = 1
			UPDATE DineroD
			SET Importe = -Importe
			WHERE ID = @DineroID

		IF @FormasPagoRestringidas = 0
		BEGIN
			SELECT @OkRef = NULL
			SELECT @OkRef = MIN(fp.FormaPago)
			FROM DineroD d
			LEFT OUTER JOIN FormaPago fp
				ON d.FormaPago = fp.FormaPago
				AND fp.Restringida = 1
			WHERE d.ID = @DineroID

			IF @OkRef IS NOT NULL
				SELECT @Ok = 30580
			ELSE
				SELECT @OkRef = NULL

		END

		EXEC spMovCopiarAnexos @Sucursal
							  ,@Modulo
							  ,@ID
							  ,'DIN'
							  ,@DineroID
	END

	IF @Ok IS NULL
		AND @DineroID IS NOT NULL
		EXEC xpGenerarDinero @Sucursal
							,@SucursalOrigen
							,@SucursalDestino
							,@Accion
							,@Empresa
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@MovTipo
							,@MovMoneda
							,@MovTipoCambio
							,@FechaAfectacion
							,@Concepto
							,@Proyecto
							,@Usuario
							,@Autorizacion
							,@Referencia
							,@DocFuente
							,@Observaciones
							,@ConDesglose
							,@GenerarSolicitud
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,@FormaPago
							,@Tipo
							,@Beneficiario
							,@Cuenta
							,@CtaDinero
							,@Cajero
							,@Importe
							,@Impuestos
							,@MovEspecifico
							,@BeneficiarioEspecifico
							,@Vencimiento
							,@DineroMov
							,@DineroMovID
							,@Ok OUTPUT
							,@OkRef OUTPUT
							,@DineroID

	IF @Ok IS NULL
		AND @DineroID IS NOT NULL
		EXEC spDinero @DineroID
					 ,'DIN'
					 ,@DineroAccion
					 ,'TODO'
					 ,@FechaRegistro
					 ,NULL
					 ,@Usuario
					 ,1
					 ,0
					 ,@DineroMov OUTPUT
					 ,@DineroMovID OUTPUT
					 ,@IDGenerar OUTPUT
					 ,@Ok OUTPUT
					 ,@OkRef OUTPUT
					 ,@EstacionTrabajo = @EstacionTrabajo

	IF @Ok = 80060
		SELECT @Ok = NULL
			  ,@OkRef = NULL

	EXEC spMovFlujo @Sucursal
				   ,@Accion
				   ,@Empresa
				   ,@Modulo
				   ,@ID
				   ,@Mov
				   ,@MovID
				   ,'DIN'
				   ,@DineroID
				   ,@DineroMov
				   ,@DineroMovID
				   ,@Ok OUTPUT

	IF @Accion = 'CANCELAR'
		AND @Tipo = 'APLICA_POSFECHADO'
	BEGIN
		EXEC spValidarTareas @Empresa
							,@Modulo
							,@DineroID
							,'POSFECHADO'
							,@Ok OUTPUT
							,@OkRef OUTPUT
		UPDATE Dinero
		SET Estatus = 'POSFECHADO'
		   ,FechaCancelacion = NULL
		   ,Saldo = NULL
		WHERE ID = @DineroID
		UPDATE MovFlujo
		SET Cancelado = 0
		WHERE Empresa = @Empresa
		AND OModulo = @Modulo
		AND OID = @OID
		AND DModulo = 'DIN'
		AND DID = @DineroID
	END

	IF @DineroMovTipo IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE', 'DIN.I', 'DIN.E')
		AND @Ok IS NULL
		EXEC spDineroRelacionar @Empresa
							   ,@Accion
							   ,'DIN'
							   ,@DineroID
							   ,@DineroMov
							   ,@DineroMovID
							   ,@CtaDinero

	IF @Modulo NOT IN ('CAM', 'VTAS')
		AND @Accion <> 'CANCELAR'
		AND @Tipo <> 'APLICA_POSFECHADO'
		AND @Ok IS NULL
		SELECT @Ok = 80030
			  ,@OkRef = 'Movimiento: ' + RTRIM(@DineroMov) + ' ' + LTRIM(CONVERT(CHAR, @DineroMovID))

	RETURN @DineroID
END

