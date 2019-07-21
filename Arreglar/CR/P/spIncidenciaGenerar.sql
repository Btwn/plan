SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spIncidenciaGenerar]
 @ID INT
,@NominaConcepto VARCHAR(10)
,@Empresa CHAR(5)
,@Sucursal INT
,@Usuario CHAR(10)
,@Moneda CHAR(10)
,@TipoCambio FLOAT
,@Personal CHAR(10)
,@FechaEmision DATETIME
,@FechaAplicacion DATETIME
,@Referencia VARCHAR(50)
,@FechaD DATETIME
,@FechaA DATETIME
,@Cantidad FLOAT
,@Valor FLOAT
,@Porcentaje FLOAT
,@Acreedor VARCHAR(10)
,@Vencimiento DATETIME
,@Repetir BIT
,@Prorratear BIT
,@Frecuencia VARCHAR(20)
,@Veces FLOAT
,@Especial VARCHAR(50)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@a INT
	   ,@ImporteTotal MONEY
	   ,@Importe MONEY
	   ,@Fecha DATETIME
	   ,@PeriodoTipo VARCHAR(20)
	SELECT @a = 1
	EXEC spIncidenciaCalc @NominaConcepto
						 ,@Empresa
						 ,@Personal
						 ,@Cantidad OUTPUT
						 ,@Valor
						 ,@Porcentaje
						 ,@ImporteTotal OUTPUT
						 ,@PeriodoTipo OUTPUT

	IF @Especial IN ('FALTAS', 'INCAPACIDADES')
	BEGIN
		SELECT @Importe = @ImporteTotal / @Cantidad
			  ,@Fecha = @FechaD
		WHILE @a <= ABS(@Cantidad)
		BEGIN

		IF @Cantidad < 0.0
		BEGIN
			EXEC spIncidenciaD @ID
							  ,@a
							  ,@NominaConcepto
							  ,@Empresa
							  ,@Sucursal
							  ,@Usuario
							  ,@Moneda
							  ,@TipoCambio
							  ,@Personal
							  ,@FechaEmision
							  ,@Fecha
							  ,@Referencia
							  ,-1.0
							  ,@Importe
							  ,@Acreedor
							  ,@Vencimiento
			SELECT @Fecha = DATEADD(DAY, -1, @Fecha)
		END
		ELSE
		BEGIN
			EXEC spIncidenciaD @ID
							  ,@a
							  ,@NominaConcepto
							  ,@Empresa
							  ,@Sucursal
							  ,@Usuario
							  ,@Moneda
							  ,@TipoCambio
							  ,@Personal
							  ,@FechaEmision
							  ,@Fecha
							  ,@Referencia
							  ,1.0
							  ,@Importe
							  ,@Acreedor
							  ,@Vencimiento
			SELECT @Fecha = DATEADD(DAY, 1, @Fecha)
		END

		SELECT @a = @a + 1
		END
	END
	ELSE

	IF @Repetir = 1
	BEGIN
		SELECT @Importe = @ImporteTotal
		WHILE @a <= @Veces
		BEGIN
		EXEC spIncidenciaFrecuencia @a
								   ,@Frecuencia
								   ,@PeriodoTipo
								   ,@FechaAplicacion OUTPUT
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
		EXEC spIncidenciaD @ID
						  ,@a
						  ,@NominaConcepto
						  ,@Empresa
						  ,@Sucursal
						  ,@Usuario
						  ,@Moneda
						  ,@TipoCambio
						  ,@Personal
						  ,@FechaEmision
						  ,@FechaAplicacion
						  ,@Referencia
						  ,@Cantidad
						  ,@Importe
						  ,@Acreedor
						  ,@Vencimiento
		SELECT @a = @a + 1
		END
	END
	ELSE

	IF @Prorratear = 1
	BEGIN
		SELECT @Importe = @ImporteTotal / @Veces
		WHILE @a <= @Veces
		BEGIN
		EXEC spIncidenciaFrecuencia @a
								   ,@Frecuencia
								   ,@PeriodoTipo
								   ,@FechaAplicacion OUTPUT
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
		EXEC spIncidenciaD @ID
						  ,@a
						  ,@NominaConcepto
						  ,@Empresa
						  ,@Sucursal
						  ,@Usuario
						  ,@Moneda
						  ,@TipoCambio
						  ,@Personal
						  ,@FechaEmision
						  ,@FechaAplicacion
						  ,@Referencia
						  ,@Cantidad
						  ,@Importe
						  ,@Acreedor
						  ,@Vencimiento
		SELECT @a = @a + 1
		END
	END
	ELSE
		EXEC spIncidenciaD @ID
						  ,@a
						  ,@NominaConcepto
						  ,@Empresa
						  ,@Sucursal
						  ,@Usuario
						  ,@Moneda
						  ,@TipoCambio
						  ,@Personal
						  ,@FechaEmision
						  ,@FechaAplicacion
						  ,@Referencia
						  ,@Cantidad
						  ,@ImporteTotal
						  ,@Acreedor
						  ,@Vencimiento

	IF (@Repetir = 1 OR @Prorratear = 1)
		AND (@a > @Veces)
		AND (@a - @Veces > 0.0)
	BEGIN
		SELECT @Importe = @Importe * (@Veces - (@a - 1.0))

		IF ROUND(@Importe, 2) > 0.0
		BEGIN
			EXEC spIncidenciaFrecuencia @a
									   ,@Frecuencia
									   ,@PeriodoTipo
									   ,@FechaAplicacion OUTPUT
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT
			EXEC spIncidenciaD @ID
							  ,@a
							  ,@NominaConcepto
							  ,@Empresa
							  ,@Sucursal
							  ,@Usuario
							  ,@Moneda
							  ,@TipoCambio
							  ,@Personal
							  ,@FechaEmision
							  ,@FechaAplicacion
							  ,@Referencia
							  ,@Cantidad
							  ,@Importe
							  ,@Acreedor
							  ,@Vencimiento
		END

	END

	RETURN
END

