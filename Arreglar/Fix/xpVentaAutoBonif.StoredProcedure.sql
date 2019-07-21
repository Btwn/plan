SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpVentaAutoBonif]
 @Sucursal INT
,@SucursalOrigen INT
,@SucursalDestino INT
,@Accion CHAR(20)
,@Modulo CHAR(5)
,@Empresa CHAR(5)
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
,@Cliente CHAR(10)
,@CobroIntegrado BIT
,@Importe MONEY
,@Impuestos MONEY
,@VIN VARCHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@Agente VARCHAR(10) = NULL
AS
BEGIN
	DECLARE
		@CxModulo CHAR(5)
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@Porcentaje FLOAT
	   ,@MovCargo CHAR(20)
	   ,@EsCredito BIT
	   ,@ImporteCargo MONEY
	   ,@ImpuestosCargo MONEY
	   ,@ImporteTotal MONEY
	   ,@Aplica CHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@BonificacionTipo VARCHAR(20)
	   ,@EnviarA INT
	   ,@CategoriaCanal VARCHAR(50)
	   ,@IDNCMAVI INT
	   ,@UEN INT
	SELECT @Aplica = @Mov
		  ,@AplicaID = @MovID
	SELECT @EsCredito = 1

	IF @MovTipo IN ('VTAS.D', 'VTAS.DF', 'VTAS.B')
	BEGIN
		SELECT @EsCredito = ~@EsCredito
		SELECT @Aplica = mf.DMov
			  ,@AplicaID = mf.DMovID
		FROM MovFlujo mf
		WHERE mf.OModulo = 'VTAS'
		AND mf.OID = @ID
		AND mf.DModulo = 'CXC'
	END

	IF @CobroIntegrado = 1
		SELECT @Aplica = NULL
			  ,@AplicaID = NULL

	SELECT @BonificacionTipo = ISNULL(UPPER(RTRIM(BonificacionTipo)), 'NO')
	FROM Cte
	WHERE Cliente = @Cliente
	SELECT @MovCargo =
	 CASE
		 WHEN @EsCredito = 1 THEN 'Nota Credito Mayoreo'
		 ELSE CxcNCargo
	 END
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa
	SELECT @EnviarA = EnviarA
	FROM Venta
	WHERE ID = @ID
	SELECT @CategoriaCanal = Categoria
	FROM VentasCanalMAVI
	WHERE ID = @EnviarA

	IF @BonificacionTipo = 'DIRECTA'
	BEGIN
		SELECT @Porcentaje = NULLIF(Bonificacion, 0)
		FROM Venta
		WHERE ID = @ID

		IF @Porcentaje < 0
			SELECT @Ok = 55070

		SELECT @ImporteCargo = @Importe * (@Porcentaje / 100)
			  ,@ImpuestosCargo = @Impuestos * (@Porcentaje / 100)
		SELECT @ImporteTotal = @ImporteCargo + @ImpuestosCargo

		IF @ImporteCargo IS NOT NULL
			AND @Ok IS NULL
			EXEC spGenerarCx @Sucursal
							,@SucursalOrigen
							,@SucursalDestino
							,@Accion
							,'CXC'
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
							,@Cliente
							,@EnviarA
							,@Agente
							,NULL
							,NULL
							,NULL
							,@ImporteCargo
							,@ImpuestosCargo
							,NULL
							,NULL
							,NULL
							,@Aplica
							,@AplicaID
							,@ImporteTotal
							,@VIN
							,@MovCargo
							,@CxModulo
							,@CxMov
							,@CxMovID
							,@Ok OUTPUT
							,@OkRef OUTPUT
							,'SIN_ORIGEN'
							,@NoAutoAplicar = 1

		IF @Ok = 80030
			SELECT @Ok = NULL
				  ,@OkRef = NULL

	END
	ELSE

	IF @BonificacionTipo = 'MULTIPLE'
		AND @CategoriaCanal = 'MAYOREO'
		AND @Mov = 'Factura Mayoreo'
	BEGIN
		DECLARE
			crCteBonificacion
			CURSOR FOR
			SELECT Concepto
				  ,Porcentaje
			FROM CteBonificacion
			WHERE Cliente = @Cliente
			AND (@FechaEmision BETWEEN FechaD AND FechaA OR (@FechaEmision >= FechaD AND FechaA IS NULL) OR (FechaD IS NULL AND @FechaEmision <= FechaA) OR (FechaD IS NULL AND FechaA IS NULL))
		OPEN crCteBonificacion
		FETCH NEXT FROM crCteBonificacion INTO @Concepto, @Porcentaje
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN

			IF @Porcentaje < 0
				SELECT @Ok = 55070

			SELECT @ImporteCargo = @Importe * (@Porcentaje / 100)
				  ,@ImpuestosCargo = @Impuestos * (@Porcentaje / 100)
			SELECT @ImporteTotal = @ImporteCargo + @ImpuestosCargo

			IF @ImporteCargo IS NOT NULL
				AND @Ok IS NULL
				EXEC @IDNCMAVI = spGenerarCx @Sucursal
											,@SucursalOrigen
											,@SucursalDestino
											,@Accion
											,'CXC'
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
											,@Cliente
											,@EnviarA
											,NULL
											,NULL
											,NULL
											,NULL
											,@ImporteCargo
											,@ImpuestosCargo
											,NULL
											,NULL
											,NULL
											,@Aplica
											,@AplicaID
											,@ImporteTotal
											,@VIN
											,@MovCargo
											,@CxModulo
											,@CxMov
											,@CxMovID
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,'SIN_ORIGEN'

			IF @IDNCMAVI IS NOT NULL
			BEGIN

				IF @Modulo = 'VTAS'
				BEGIN
					SELECT @UEN = UEN
					FROM Venta
					WHERE ID = @ID
					UPDATE Cxc
					SET UEN = @UEN
					WHERE ID = @IDNCMAVI
				END

			END

			IF @Ok = 80030
				SELECT @Ok = NULL
					  ,@OkRef = NULL

			FETCH NEXT FROM crCteBonificacion INTO @Concepto, @Porcentaje
		END

		END
		CLOSE crCteBonificacion
		DEALLOCATE crCteBonificacion
	END

	RETURN
END
GO