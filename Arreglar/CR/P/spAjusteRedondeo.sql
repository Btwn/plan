SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAjusteRedondeo]
 @Sucursal INT
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
AS
BEGIN
	DECLARE
		@CfgMovAjusteRedondeo CHAR(20)
	   ,@Conteo INT
	   ,@ID INT
	   ,@FechaRegistro DATETIME
	   ,@FechaEmision DATETIME
	   ,@Rama CHAR(5)
	   ,@Cuenta CHAR(20)
	   ,@Saldo MONEY
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Mov CHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@IDGenerar INT
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@OkDesc VARCHAR(255)
	   ,@OkTipo VARCHAR(50)
	   ,@RedondeoMonetarios INT
		 ,@SucursalMov INT
	SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
	SELECT @FechaRegistro = GETDATE()
	SELECT @FechaEmision = CONVERT(DATETIME, CONVERT(CHAR(10), GETDATE(), 120), 120)
		  ,@Conteo = 0
		  ,@Ok = NULL
		  ,@OkRef = NULL

	IF @Modulo = 'CXC'
		SELECT @Rama = 'CRND'
	ELSE
		SELECT @Rama = 'PRND'

	SELECT @CfgMovAjusteRedondeo =
	 CASE @Modulo
		 WHEN 'CXC' THEN NULLIF(RTRIM(CxcAjusteRedondeo), '')
		 ELSE NULLIF(RTRIM(CxpAjusteRedondeo), '')
	 END
	FROM EmpresaCfgMov
	WHERE Empresa = @Empresa

	IF @Modulo = 'CXC'
		DECLARE
			crAjusteRedondeo
			CURSOR FOR
			SELECT Sucursal
				  ,NULLIF(RTRIM(s.Cuenta), '')
				  ,s.Saldo
				  ,m.Moneda
				  ,m.TipoCambio
			FROM Saldo s
			JOIN EmpresaCfg ec
				ON s.Empresa = ec.Empresa
			JOIN Mon m
				ON s.Moneda = m.Moneda
			WHERE s.Rama = @Rama
			AND s.Empresa = @Empresa
			AND ISNULL(s.Saldo, 0) <> 0.0
			AND s.Saldo BETWEEN -m.CxcAjusteRedondeo AND m.CxcAjusteRedondeo
	ELSE
		DECLARE
			crAjusteRedondeo
			CURSOR FOR
			SELECT Sucursal
				  ,NULLIF(RTRIM(s.Cuenta), '')
				  ,s.Saldo
				  ,m.Moneda
				  ,m.TipoCambio
			FROM Saldo s
			JOIN EmpresaCfg ec
				ON s.Empresa = ec.Empresa
			JOIN Mon m
				ON s.Moneda = m.Moneda
			WHERE s.Rama = @Rama
			AND s.Empresa = @Empresa
			AND ISNULL(s.Saldo, 0) <> 0.0
			AND s.Saldo BETWEEN -m.CxpAjusteRedondeo AND m.CxpAjusteRedondeo

	OPEN crAjusteRedondeo
	FETCH NEXT FROM crAjusteRedondeo INTO @SucursalMov, @Cuenta, @Saldo, @Moneda, @TipoCambio
	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @@FETCH_STATUS <> -2
		AND @Ok IS NULL
	BEGIN

		IF @Modulo = 'CXC'
			INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, UltimoCambio, Cliente, ClienteMoneda, ClienteTipoCambio, Importe)
				VALUES (@SucursalMov, @Empresa, @CfgMovAjusteRedondeo, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Cuenta, @Moneda, @TipoCambio, -@Saldo)
		ELSE
			INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, UltimoCambio, Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe)
				VALUES (@SucursalMov, @Empresa, @CfgMovAjusteRedondeo, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Cuenta, @Moneda, @TipoCambio, -@Saldo)

		SELECT @ID = SCOPE_IDENTITY()
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

		IF @Ok IS NULL
			SELECT @Conteo = @Conteo + 1

	END

	FETCH NEXT FROM crAjusteRedondeo INTO @SucursalMov, @Cuenta, @Saldo, @Moneda, @TipoCambio
	END
	CLOSE crAjusteRedondeo
	DEALLOCATE crAjusteRedondeo

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

