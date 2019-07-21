SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spIncidenciaFrecuencia]
 @Numero INT
,@Frecuencia VARCHAR(20)
,@PeriodoTipo VARCHAR(20)
,@Fecha DATETIME OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Dia INT
	   ,@Mes INT
	   ,@Ano INT

	IF @PeriodoTipo = 'CONFIDENCIAL'
		SELECT @PeriodoTipo = 'QUINCENAL'
	IF @Frecuencia = 'CADA NOMINA'
	BEGIN

		IF @Numero > 1
			SELECT @Fecha = DATEADD(DAY, 1, @Fecha)

		EXEC spCalcularPeriodicidad @Fecha
								   ,@PeriodoTipo
								   ,@Fecha OUTPUT
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
	END
	ELSE
	BEGIN

		IF @Numero > 1
			OR (@Frecuencia = 'INICIO MES' AND DAY(@Fecha) > 1)
			SELECT @Fecha = DATEADD(MONTH, 1, @Fecha)

		SELECT @Dia = DAY(@Fecha)
			  ,@Mes = MONTH(@Fecha)
			  ,@Ano = YEAR(@Fecha)

		IF @Frecuencia = 'INICIO MES'
			SELECT @Dia = 1
		ELSE

		IF @Frecuencia = 'FIN MES'
			EXEC spDiasMes @Mes
						  ,@Ano
						  ,@Dia OUTPUT

		EXEC spIntToDateTime @Dia
							,@Mes
							,@Ano
							,@Fecha OUTPUT
	END

	EXEC xpIncidenciaFrecuencia @Numero
							   ,@Frecuencia
							   ,@PeriodoTipo
							   ,@Fecha OUTPUT
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
	RETURN
END

