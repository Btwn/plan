SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spNOIImportarNomina]
 @Empresa VARCHAR(5)
,@TablaPeriodo VARCHAR(10)
,@Estacion INT
AS
BEGIN
	DECLARE
		@Sucursal INT
	   ,@SQL VARCHAR(MAX)
	   ,@SQL2 VARCHAR(MAX)
	   ,@SQL3 NVARCHAR(MAX)
	   ,@NomEspecial VARCHAR(1)
	   ,@BaseNOI VARCHAR(255)
	   ,@EmpresaNOI VARCHAR(2)
	   ,@Tipo VARCHAR(20)
	   ,@FechaD DATETIME
	   ,@FechaA DATETIME
	   ,@ID INT
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	DECLARE
		@Tabla TABLE (
			Personal VARCHAR(10)
		   ,SueldoDiario FLOAT
		   ,TotalPer FLOAT
		   ,TotalDed FLOAT
		   ,IMSS FLOAT
		   ,ISPT FLOAT
		   ,Infonavit FLOAT
		   ,NetoPagado FLOAT
		   ,NomEspecial BIT
		)
	DECLARE
		@Tabla2 TABLE (
			Personal VARCHAR(10)
		   ,NominaConcepto VARCHAR(10)
		   ,Valor FLOAT
		)
	SELECT @BaseNOI = '[' + Servidor + '].' + BaseDatosNombre
		  ,@EmpresaNOI = EmpresaAspel
		  ,@Sucursal = SucursalIntelisis
	FROM InterfaseAspel
	WHERE SistemaAspel = 'NOI'
	AND Empresa = @Empresa
	SELECT @Tipo = TipoPeriodo
	FROM InterfaseAspelNOI
	WHERE Empresa = @Empresa
	SELECT @FechaD = FechaD
		  ,@FechaA = FechaA
	FROM NOITablaPeriodo
	WHERE Nomina = @TablaPeriodo
	AND Estacion = @Estacion
	SET ANSI_WARNINGS ON
	SELECT @SQL = 'SELECT RTRIM(LTRIM(CLAVE_TRAB)),SUEL_DR,TOT_PER,TOT_DED,IMSS_TR,ISPT_TR,INFONTR,NETO_PG,0
FROM ' + @BaseNOI + '.dbo.RESINT' + @TablaPeriodo + @EmpresaNOI
	SELECT @SQL2 = 'SELECT RTRIM(LTRIM(CLAVE_TRAB)),UPPER(CHAR(PER_DED))+dbo.fnRellenarCerosIzquierda(NUM_PER,3),VALOR
FROM ' + @BaseNOI + '.dbo.RESINTPERDED' + @TablaPeriodo + @EmpresaNOI
	INSERT @Tabla (Personal, SueldoDiario, TotalPer, TotalDed, IMSS, ISPT, Infonavit, NetoPagado, NomEspecial)
	EXEC (@SQL)

	IF @@ERROR <> 0
		SET @Ok = 1

	INSERT @Tabla2 (Personal, NominaConcepto, Valor)
	EXEC (@SQL2)

	IF @@ERROR <> 0
		SET @Ok = 1

	SELECT @SQL3 = N'SELECT @NomEspecial = NOM_ESP FROM ' + @BaseNOI + '.dbo.TB' + @TablaPeriodo + @EmpresaNOI + 'C'
	EXEC sp_executesql @SQL3
					  ,N'@NomEspecial varchar(1) OUTPUT'
					  ,@NomEspecial OUTPUT
	UPDATE @Tabla
	SET NomEspecial =
	CASE
		WHEN @NomEspecial = 'S' THEN 1
		ELSE 0
	END

	IF EXISTS (SELECT * FROM NOINomina WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion)
		AND @Ok IS NULL
		DELETE NOINomina
		WHERE EmpresaNOI = @EmpresaNOI
			AND Nomina = @TablaPeriodo
			AND Estacion = @Estacion

	IF @@ERROR <> 0
		SET @Ok = 1

	IF @Ok IS NULL
		INSERT NOINomina (Estacion, EmpresaNOI, Nomina, Empresa, Sucursal, Tipo, FechaD, FechaA, Personal, SueldoDiario, TotalPer, TotalDed, IMSS, ISPT, Infonavit, NetoPagado, Verificado, NominaEspecial)
			SELECT @Estacion
				  ,@EmpresaNOI
				  ,@TablaPeriodo
				  ,@Empresa
				  ,@Sucursal
				  ,@Tipo
				  ,@FechaD
				  ,@FechaA
				  ,Personal
				  ,SueldoDiario
				  ,TotalPer
				  ,TotalDed
				  ,IMSS
				  ,ISPT
				  ,Infonavit
				  ,NetoPagado
				  ,1
				  ,NomEspecial
			FROM @Tabla

	IF @@ERROR <> 0
		SET @Ok = 1

	IF EXISTS (SELECT * FROM NOINominaD WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion)
		AND @Ok IS NULL
		DELETE NOINominaD
		WHERE EmpresaNOI = @EmpresaNOI
			AND Nomina = @TablaPeriodo
			AND Estacion = @Estacion

	IF @@ERROR <> 0
		SET @Ok = 1

	IF @Ok IS NULL
		INSERT NOINominaD (Estacion, EmpresaNOI, Nomina, Personal, NominaConcepto, Valor)
			SELECT @Estacion
				  ,@EmpresaNOI
				  ,@TablaPeriodo
				  ,Personal
				  ,NominaConcepto
				  ,Valor
			FROM @Tabla2

	IF @@ERROR <> 0
		SET @Ok = 1

	UPDATE NOINomina
	SET Ok = p.Ok
	   ,OkRef = p.OkRef
	   ,Verificado = p.Verificado
	   ,Nombre = p.Nombre + ' ' + p.ApellidoPaterno + ' ' + p.ApellidoMaterno
	FROM NOINomina n
	JOIN NOIPersonal p
		ON n.Personal = p.Personal
		AND p.Estacion = n.Estacion
		AND p.Nomina = n.Nomina
	WHERE n.EmpresaNOI = @EmpresaNOI
	AND n.Nomina = @TablaPeriodo
	AND n.Estacion = @Estacion

	IF EXISTS (SELECT * FROM NOINomina WHERE NetoPagado < 0.0 AND EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion)
		UPDATE NOINomina
		SET Ok = 30100
		   ,OkRef = 'Importe Incorrecto'
		   ,Verificado = 0
		WHERE EmpresaNOI = @EmpresaNOI
		AND Nomina = @TablaPeriodo
		AND Estacion = @Estacion
		AND NetoPagado < 0.0

	RETURN
END

