SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spEliminarSaldosMenores]
 @Sucursal INT
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
AS
BEGIN
	DECLARE
		@CfgMov CHAR(20)
	   ,@Conteo INT
	   ,@ID INT
	   ,@Renglon FLOAT
	   ,@FechaRegistro DATETIME
	   ,@FechaEmision DATETIME
	   ,@Contacto CHAR(10)
	   ,@UltContacto CHAR(10)
	   ,@Saldo MONEY
	   ,@SumaImporte MONEY
	   ,@Moneda CHAR(10)
	   ,@UltMoneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Mov CHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@MovGenerar CHAR(20)
	   ,@MovIDGenerar VARCHAR(20)
	   ,@MovTipo VARCHAR(20)
	   ,@IDGenerar INT
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@OkDesc VARCHAR(255)
	   ,@OkTipo VARCHAR(50)
	   ,@CxID INT
	SELECT @FechaRegistro = GETDATE()
	SELECT @FechaEmision = CAST(CONVERT(VARCHAR, @FechaRegistro, 101) AS DATETIME)
		  ,@ID = NULL
		  ,@Conteo = 0
		  ,@Ok = NULL
		  ,@OkRef = NULL
		  ,@UltContacto = NULL
		  ,@UltMoneda = NULL
	SELECT @CfgMov =
	 CASE @Modulo
		 WHEN 'CXC' THEN NULLIF(RTRIM(CxcAjuste), '')
		 ELSE NULLIF(RTRIM(CxpAjuste), '')
	 END
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa

	IF @Modulo = 'CXC'
		DECLARE
			crEliminarSaldos
			CURSOR FOR
			SELECT c.ID
				  ,mt.Clave
				  ,m.Moneda
				  ,m.TipoCambio
				  ,c.Cliente
				  ,c.Mov
				  ,c.MovID
				  ,ISNULL(c.Saldo, 0)
			FROM Cxc c
				,Mon m
				,MovTipo mt
			WHERE c.Empresa = @Empresa
			AND m.Moneda = c.Moneda
			AND c.Saldo >=
			CASE c.Moneda
				WHEN 'Pesos' THEN ISNULL(mt.EliminarSaldosMenoresD, 0)
				WHEN 'Dolar' THEN ISNULL(mt.EliminarSaldosMenoresDDolar, 0)
				ELSE 0
			END
			AND c.Saldo <=
			CASE c.Moneda
				WHEN 'Pesos' THEN ISNULL(mt.EliminarSaldosMenoresA, 0)
				WHEN 'Dolar' THEN ISNULL(mt.EliminarSaldosMenoresADolar, 0)
				ELSE 0
			END
			AND c.Estatus = 'PENDIENTE'
			AND mt.EliminarSaldosMenores = 1
			AND mt.Modulo = @Modulo
			AND mt.Mov = c.Mov
			AND mt.Clave IN ('CXC.F', 'CXC.FAC', 'CXC.CA', 'CXC.CAD', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DC')
			AND ISNULL(c.Saldo, 0) > 0.0
			AND ISNULL(c.Saldo, 0) < ISNULL(c.Importe, 0)
			ORDER BY c.Moneda, c.Cliente
	ELSE
		DECLARE
			crEliminarSaldos
			CURSOR FOR
			SELECT c.ID
				  ,mt.Clave
				  ,m.Moneda
				  ,m.TipoCambio
				  ,c.Proveedor
				  ,c.Mov
				  ,c.MovID
				  ,ISNULL(c.Saldo, 0)
			FROM Cxp c
				,Mon m
				,MovTipo mt
			WHERE c.Empresa = @Empresa
			AND m.Moneda = c.Moneda
			AND c.Saldo >=
			CASE c.Moneda
				WHEN 'Pesos' THEN ISNULL(mt.EliminarSaldosMenoresD, 0)
				WHEN 'Dolar' THEN ISNULL(mt.EliminarSaldosMenoresDDolar, 0)
				ELSE 0
			END
			AND c.Saldo <=
			CASE c.Moneda
				WHEN 'Pesos' THEN ISNULL(mt.EliminarSaldosMenoresA, 0)
				WHEN 'Dolar' THEN ISNULL(mt.EliminarSaldosMenoresADolar, 0)
				ELSE 0
			END
			AND c.Estatus = 'PENDIENTE'
			AND mt.EliminarSaldosMenores = 1
			AND mt.Modulo = @Modulo
			AND mt.Mov = c.Mov
			AND mt.Clave IN ('CXP.F', 'CXP.FAC', 'CXP.CA', 'CXP.CAD', 'CXP.D', 'CXP.DM', 'CXP.A', 'CXP.NC', 'CXP.NCD', 'CXP.NCP', 'CXP.NCF', 'CXP.DC')
			AND ISNULL(c.Saldo, 0) > 0.0
			ORDER BY c.Moneda, c.Proveedor

	OPEN crEliminarSaldos
	FETCH NEXT FROM crEliminarSaldos INTO @CxID, @MovTipo, @Moneda, @TipoCambio, @Contacto, @Mov, @MovID, @Saldo
	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
		AND @Ok IS NULL
	BEGIN

		IF @MovTipo IN ('CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DC', 'CXP.A', 'CXP.NC', 'CXP.NCD', 'CXP.NCP', 'CXP.NCF', 'CXP.DC')
			SELECT @Saldo = -@Saldo

		IF @ID IS NULL
			OR @UltMoneda <> @Moneda
			OR @UltContacto <> @Contacto
		BEGIN
			SELECT @UltMoneda = @Moneda
				  ,@UltContacto = @Contacto

			IF @ID IS NOT NULL
				AND @Ok IS NULL
			BEGIN

				IF @Modulo = 'CXC'
				BEGIN
					UPDATE Cxc
					SET Importe = @SumaImporte
					WHERE ID = @ID

					IF (@SumaImporte < 0)
						AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS ROJOS' AND Modulo = 'CXC')
						)
						UPDATE Cxc
						SET Concepto = 'SALDOS ROJOS'
						WHERE ID = @ID
					ELSE
					BEGIN

						IF (@SumaImporte >= 0)
							AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS NEGROS' AND Modulo = 'CXC')
							)
							UPDATE Cxc
							SET Concepto = 'SALDOS NEGROS'
							WHERE ID = @ID

					END

				END
				ELSE
				BEGIN
					UPDATE Cxp
					SET Importe = @SumaImporte
					WHERE ID = @ID

					IF (@SumaImporte < 0)
						AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS ROJOS' AND Modulo = 'CXP')
						)
						UPDATE Cxp
						SET Concepto = 'SALDOS ROJOS'
						WHERE ID = @ID
					ELSE
					BEGIN

						IF (@SumaImporte >= 0)
							AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS NEGROS' AND Modulo = 'CXP')
							)
							UPDATE Cxp
							SET Concepto = 'SALDOS NEGROS'
							WHERE ID = @ID

					END

				END

				EXEC spCx @ID
						 ,@Modulo
						 ,'AFECTAR'
						 ,'TODO'
						 ,@FechaEmision
						 ,NULL
						 ,@Usuario
						 ,0
						 ,0
						 ,@MovGenerar OUTPUT
						 ,@MovIDGenerar OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
			END

			IF @Ok IS NULL
			BEGIN

				IF @Modulo = 'CXC'
					INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, UltimoCambio, Cliente, ClienteMoneda, ClienteTipoCambio, AplicaManual)
						VALUES (@Sucursal, @Empresa, @CfgMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda, @TipoCambio, 1)
				ELSE
					INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, UltimoCambio, Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual)
						VALUES (@Sucursal, @Empresa, @CfgMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda, @TipoCambio, 1)

				SELECT @ID = SCOPE_IDENTITY()
				SELECT @Conteo = @Conteo + 1
					  ,@Renglon = 0.0
					  ,@SumaImporte = 0
			END

		END

		SELECT @Renglon = @Renglon + 2048.0
			  ,@SumaImporte = @SumaImporte + @Saldo

		IF @Modulo = 'CXC'
			INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe)
				VALUES (@ID, @Renglon, @Mov, @MovID, @Saldo)
		ELSE
			INSERT CxpD (ID, Renglon, Aplica, AplicaID, Importe)
				VALUES (@ID, @Renglon, @Mov, @MovID, @Saldo)

	END

	FETCH NEXT FROM crEliminarSaldos INTO @CxID, @MovTipo, @Moneda, @TipoCambio, @Contacto, @Mov, @MovID, @Saldo
	END
	CLOSE crEliminarSaldos
	DEALLOCATE crEliminarSaldos

	IF @ID IS NOT NULL
		AND @Ok IS NULL
	BEGIN

		IF @Modulo = 'CXC'
		BEGIN
			UPDATE Cxc
			SET Importe = @SumaImporte
			WHERE ID = @ID

			IF (@SumaImporte < 0)
				AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS ROJOS' AND Modulo = 'CXC')
				)
				UPDATE Cxc
				SET Concepto = 'SALDOS ROJOS'
				WHERE ID = @ID
			ELSE
			BEGIN

				IF (@SumaImporte >= 0)
					AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS NEGROS' AND Modulo = 'CXC')
					)
					UPDATE Cxc
					SET Concepto = 'SALDOS NEGROS'
					WHERE ID = @ID

			END

		END
		ELSE
		BEGIN
			UPDATE Cxp
			SET Importe = @SumaImporte
			WHERE ID = @ID

			IF (@SumaImporte < 0)
				AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS ROJOS' AND Modulo = 'CXP')
				)
				UPDATE Cxp
				SET Concepto = 'SALDOS ROJOS'
				WHERE ID = @ID
			ELSE
			BEGIN

				IF (@SumaImporte >= 0)
					AND (EXISTS (SELECT Concepto FROM Concepto WHERE Concepto = 'SALDOS NEGROS' AND Modulo = 'CXP')
					)
					UPDATE Cxp
					SET Concepto = 'SALDOS NEGROS'
					WHERE ID = @ID

			END

		END

		EXEC spCx @ID
				 ,@Modulo
				 ,'AFECTAR'
				 ,'TODO'
				 ,@FechaEmision
				 ,NULL
				 ,@Usuario
				 ,0
				 ,0
				 ,@Mov OUTPUT
				 ,@MovID OUTPUT
				 ,@IDGenerar OUTPUT
				 ,@Ok OUTPUT
				 ,@OkRef OUTPUT
	END

	IF @Ok IS NULL
		SELECT @Ok = 80000
			  ,@OkRef = LTRIM(CONVERT(CHAR, @conteo)) + ' Ajuste(s) generados.'
			  ,@OkTipo = 'INFO'
			  ,@OkDesc = 'Proceso Concluido'
	ELSE
		SELECT @OkDesc = Descripcion
			  ,@OkTipo = Tipo
		FROM MensajeLista
		WHERE Mensaje = @Ok

	SELECT @Ok
		  ,@OkDesc
		  ,@OkTipo
		  ,@OkRef
		  ,NULL
	RETURN
END
GO