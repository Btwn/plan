SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROC [dbo].[spContAuxInt] (
	@Empresa CHAR(5)
   ,@Estatus CHAR(10)
   ,@CuentaD CHAR(20)
   ,@CuentaA CHAR(20)
   ,@FechaD DATETIME
   ,@FechaA DATETIME
   ,@MovEspecifico CHAR(20) = NULL
   ,@CtaCat CHAR(20) = NULL
   ,@CtaFam CHAR(20) = NULL
   ,@CtaGrupo CHAR(20) = NULL
	)
AS
BEGIN

	IF UPPER(@MovEspecifico) IN ('0', 'NULL', '(TODOS)', '')
		SELECT @MovEspecifico = NULL

	IF UPPER(@CtaCat) IN ('0', 'NULL', '(TODOS)', '')
		SELECT @CtaCat = NULL

	IF UPPER(@CtaFam) IN ('0', 'NULL', '(TODOS)', '')
		SELECT @CtaFam = NULL

	IF UPPER(@CtaGrupo) IN ('0', 'NULL', '(TODOS)', '')
		SELECT @CtaGrupo = NULL

	IF EXISTS (SELECT NAME FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#TempResultado') AND TYPE = 'U')
		DROP TABLE #TempResultado

	IF EXISTS (SELECT NAME FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('Tempdb.dbo.#TempContAux') AND TYPE = 'U')
		DROP TABLE #TempContAux

	SELECT ContAux.ID
		  ,ContAux.Empresa
		  ,ContAux.Cuenta
		  ,ContAux.SubCuenta
		  ,ContAux.Ejercicio
		  ,ContAux.Periodo
		  ,ContAux.Renglon
		  ,ContAux.RenglonSub
		  ,ContAux.Concepto
		  ,ContAux.Debe
		  ,ContAux.Haber
		  ,ContAux.FechaContable
		  ,ContAux.Movimiento
		  ,ContMov = ContAux.Mov
		  ,ContAux.Referencia
		  ,ContAux.Estatus
		  ,ContAux.Mov
	INTO #TempContAux
	FROM ContAux
	WHERE ContAux.Empresa = @Empresa
	AND ContAux.Estatus = @Estatus
	AND ContAux.Cuenta >= @CuentaD
	AND ContAux.Cuenta <= @CuentaA
	AND ContAux.FechaContable >= @FechaD
	AND ContAux.FechaContable <= @FechaA
	AND ContAux.Mov = ISNULL(@MovEspecifico, ContAux.Mov)
	ORDER BY ContAux.Cuenta, ContAux.FechaContable, ContAux.ID
	SELECT t.ID
		  ,t.Empresa
		  ,t.Cuenta
		  ,t.SubCuenta
		  ,t.Ejercicio
		  ,t.Periodo
		  ,t.Renglon
		  ,t.RenglonSub
		  ,t.Concepto
		  ,t.Debe
		  ,t.Haber
		  ,t.FechaContable
		  ,t.Movimiento
		  ,t.Referencia
		  ,t.Estatus
		  ,t.mov
		  ,Cta.Descripcion
		  ,Cta.Cuenta AS 'CtaCuenta'
	INTO #TempResultado
	FROM Cta
	LEFT OUTER JOIN #TempContAux t
		ON Cta.Cuenta = t.Cuenta
	WHERE Cta.Cuenta BETWEEN @CuentaD AND @CuentaA
	AND Cta.TieneMovimientos = 1
	AND Cta.EsAcumulativa = 0
	AND ISNULL(Cta.Categoria, 0) = ISNULL(ISNULL(@CtaCat, Cta.Categoria), 0)
	AND ISNULL(Cta.Familia, 0) = ISNULL(ISNULL(@CtaFam, Cta.Familia), 0)
	AND ISNULL(Cta.Grupo, 0) = ISNULL(ISNULL(@CtaGrupo, Cta.Grupo), 0)
	SELECT a.ID
		  ,a.Empresa
		  ,a.Cuenta
		  ,a.SubCuenta
		  ,a.Ejercicio
		  ,a.Periodo
		  ,a.Renglon
		  ,a.RenglonSub
		  ,a.Concepto
		  ,Debe =
		   CASE
			   WHEN B.Id IS NOT NULL THEN B.Debe
			   ELSE A.Debe
		   END
		  ,Haber =
		   CASE
			   WHEN B.Id IS NOT NULL THEN B.Haber
			   ELSE A.Haber
		   END
		  ,a.FechaContable
		  ,a.Movimiento
		  ,a.Referencia
		  ,a.Estatus
		  ,a.mov
		  ,a.Descripcion
		  ,a.CtaCuenta
		  ,b.CtaOperativa
		  ,b.NombreCtaOperativa
		  ,b.origen
	FROM #TempResultado A
	LEFT JOIN SaldosInicialesAuxContDetalle B
		ON A.ID = B.ID
		AND A.CUENTA = B.CUENTA
		AND A.RENGLON = B.RENGLON
	ORDER BY a.CtaCuenta, a.FechaContable, a.ID
END
GO