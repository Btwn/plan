SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGenerarCx]
 @Sucursal INT
,@SucursalOrigen INT
,@SucursalDestino INT
,@Accion CHAR(20)
,@ModuloAfectar CHAR(5)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@Contacto CHAR(10)
,@EnviarA INT
,@Agente CHAR(10)
,@Tipo CHAR(20)
,@CtaDinero CHAR(10)
,@FormaPago VARCHAR(50)
,@Importe MONEY
,@Impuestos MONEY
,@Retencion MONEY
,@ComisionTotal MONEY
,@Beneficiario INT
,@Aplica CHAR(20)
,@AplicaMovID VARCHAR(20)
,@ImporteAplicar MONEY
,@VIN VARCHAR(20)
,@MovEspecifico CHAR(20)
,@CxModulo CHAR(5) OUTPUT
,@CxMov CHAR(20) OUTPUT
,@CxMovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@INSTRUCCIONES_ESP VARCHAR(20) = NULL
,@IVAFiscal FLOAT = NULL
,@IEPSFiscal FLOAT = NULL
,@PersonalCobrador CHAR(10) = NULL
,@Retencion2 MONEY = NULL
,@Retencion3 MONEY = NULL
,@ModuloEspecifico CHAR(5) = NULL
,@EndosarA VARCHAR(10) = NULL
,@Conteo INT = NULL
,@Nota VARCHAR(100) = NULL
,@MovIDEspecifico VARCHAR(20) = NULL
,@ContUso VARCHAR(20) = NULL
,@LineaCredito VARCHAR(20) = NULL
,@LineaCreditoExpress BIT = NULL
,@TipoAmortizacion VARCHAR(20) = NULL
,@TipoTasa VARCHAR(20) = NULL
,@TieneTasaEsp BIT = NULL
,@TasaEsp FLOAT = NULL
,@Comisiones MONEY = NULL
,@ComisionesIVA MONEY = NULL
,@CopiarMovImpuesto BIT = 0
,@NoAutoAplicar BIT = 0
AS
BEGIN
	DECLARE
		@CxID INT
	   ,@Equipo BIT
	   ,@Cte VARCHAR(10)
	   ,@CteEnviarA INT
	   ,@SeEnviaBuroCte BIT
	   ,@SeEnviaBuroCanal BIT
	   ,@Monto FLOAT
	   ,@ImpuestoFinanciamiento FLOAT
	   ,@DefImpuesto FLOAT
	SELECT @Equipo = 0

	IF @Mov IN ('Credilana', 'Prestamo Personal', 'Cancela Prestamo', 'Cancela Credilana')
	BEGIN
		EXEC spObtenerFinanciamientoMAVI @ID
										,@Monto OUTPUT
		SELECT @DefImpuesto = ISNULL(DefImpuesto, 0)
		FROM EmpresaGral
		WHERE Empresa = @Empresa
		SELECT @DefImpuesto = (@DefImpuesto / 100.00) + 1
		SELECT @ImpuestoFinanciamiento = ISNULL(@Monto, 0.0)
		SELECT @Monto = ISNULL(@Monto, 0) / @DefImpuesto
		SELECT @ImpuestoFinanciamiento = @ImpuestoFinanciamiento - ISNULL(@Monto, 0)
		SELECT @Importe = @Importe - ISNULL(@ImpuestoFinanciamiento, 0.0)
		SELECT @Impuestos = ISNULL(@ImpuestoFinanciamiento, 0)
		SELECT @CtaDinero = DefCtaDinero
			  ,@Agente = DefCajero
		FROM Usuario
		WHERE Usuario = @Usuario
		SELECT @FormaPago = 'EFECTIVO'
	END

	IF @ModuloAfectar = 'AGENT'
		AND @Agente IS NOT NULL
		SELECT @Equipo = Equipo
		FROM Agente
		WHERE Agente = @Agente

	IF @Equipo = 1
	BEGIN
		DECLARE
			crEquipo
			CURSOR FOR
			SELECT Agente
				  ,@ComisionTotal * (Porcentaje / 100.0)
			FROM EquipoAgente
			WHERE Equipo = @Agente
		OPEN crEquipo
		FETCH NEXT FROM crEquipo INTO @Agente, @ComisionTotal
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @Ok IS NULL
			EXEC @CxID = spGenerarAfectarCx @Sucursal
										   ,@SucursalOrigen
										   ,@SucursalDestino
										   ,@Accion
										   ,@ModuloAfectar
										   ,@Empresa
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@MovTipo
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@FechaEmision
										   ,@Concepto
										   ,@Proyecto
										   ,@Usuario
										   ,@Autorizacion
										   ,@Referencia
										   ,@DocFuente
										   ,@Observaciones
										   ,@FechaRegistro
										   ,@Ejercicio
										   ,@Periodo
										   ,@Condicion
										   ,@Vencimiento
										   ,@Contacto
										   ,@EnviarA
										   ,@Agente
										   ,@Tipo
										   ,@CtaDinero
										   ,@FormaPago
										   ,@Importe
										   ,@Impuestos
										   ,@Retencion
										   ,@ComisionTotal
										   ,@Beneficiario
										   ,@Aplica
										   ,@AplicaMovID
										   ,@ImporteAplicar
										   ,@VIN
										   ,@MovEspecifico
										   ,@CxModulo OUTPUT
										   ,@CxMov OUTPUT
										   ,@CxMovID OUTPUT
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT
										   ,@INSTRUCCIONES_ESP
										   ,@IVAFiscal
										   ,@IEPSFiscal
										   ,@PersonalCobrador
										   ,@Retencion2
										   ,@Retencion3
										   ,@ModuloEspecifico
										   ,@EndosarA
										   ,@Conteo
										   ,@Nota
										   ,@MovIDEspecifico
										   ,@ContUso
										   ,@LineaCredito
										   ,@LineaCreditoExpress
										   ,@TipoAmortizacion
										   ,@TipoTasa
										   ,@TieneTasaEsp
										   ,@TasaEsp
										   ,@Comisiones
										   ,@ComisionesIVA
										   ,@CopiarMovImpuesto
										   ,@NoAutoAplicar

		FETCH NEXT FROM crEquipo INTO @Agente, @ComisionTotal
		END
		CLOSE crEquipo
		DEALLOCATE crEquipo
	END
	ELSE
	BEGIN

		IF ISNULL(@CtaDinero, '') = ''
			SELECT @CtaDinero = CtaDinero
			FROM Prov
			WHERE Proveedor = @Contacto

		EXEC @CxID = spGenerarAfectarCx @Sucursal
									   ,@SucursalOrigen
									   ,@SucursalDestino
									   ,@Accion
									   ,@ModuloAfectar
									   ,@Empresa
									   ,@Modulo
									   ,@ID
									   ,@Mov
									   ,@MovID
									   ,@MovTipo
									   ,@MovMoneda
									   ,@MovTipoCambio
									   ,@FechaEmision
									   ,@Concepto
									   ,@Proyecto
									   ,@Usuario
									   ,@Autorizacion
									   ,@Referencia
									   ,@DocFuente
									   ,@Observaciones
									   ,@FechaRegistro
									   ,@Ejercicio
									   ,@Periodo
									   ,@Condicion
									   ,@Vencimiento
									   ,@Contacto
									   ,@EnviarA
									   ,@Agente
									   ,@Tipo
									   ,@CtaDinero
									   ,@FormaPago
									   ,@Importe
									   ,@Impuestos
									   ,@Retencion
									   ,@ComisionTotal
									   ,@Beneficiario
									   ,@Aplica
									   ,@AplicaMovID
									   ,@ImporteAplicar
									   ,@VIN
									   ,@MovEspecifico
									   ,@CxModulo OUTPUT
									   ,@CxMov OUTPUT
									   ,@CxMovID OUTPUT
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT
									   ,@INSTRUCCIONES_ESP
									   ,@IVAFiscal
									   ,@IEPSFiscal
									   ,@PersonalCobrador
									   ,@Retencion2
									   ,@Retencion3
									   ,@ModuloEspecifico
									   ,@EndosarA
									   ,@Conteo
									   ,@Nota
									   ,@MovIDEspecifico
									   ,@ContUso
									   ,@LineaCredito
									   ,@LineaCreditoExpress
									   ,@TipoAmortizacion
									   ,@TipoTasa
									   ,@TieneTasaEsp
									   ,@TasaEsp
									   ,@Comisiones
									   ,@ComisionesIVA
									   ,@CopiarMovImpuesto
	END

	IF (@Mov IN ('Factura', 'Factura Mayoreo', 'Factura VIU', 'Credilana', 'Prestamo Personal'))
	BEGIN
		SELECT @Cte = Cliente
			  ,@CteEnviarA = EnviarA
		FROM Venta
		WHERE Mov = @Mov
		AND MovID = @MovID
		SELECT @SeEnviaBuroCte = SeEnviaBuroCreditoMavi
		FROM CteEnviarA
		WHERE Cliente = @Cte
		AND ID = @CteEnviarA
		SELECT @SeEnviaBuroCanal = SeEnviaBuroCreditoMavi
		FROM VentasCanalMavi
		WHERE ID = @CteEnviarA

		IF (@SeEnviaBuroCte = 1)
			EXEC spCambiarCxcBuroCanalVenta @Mov
										   ,@MovID

	END

	EXEC spActualizaDesglose 0
							,@Mov
							,@MovID
							,'VTAS'
	RETURN @CxID
END

