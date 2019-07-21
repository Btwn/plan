SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovTipo
@Modulo		char(5),
@Mov			char(20),
@FechaAfectacion	datetime,
@Empresa		char(5),
@Estatus		char(15),
@Concepto		varchar(50)     OUTPUT,
@MovTipo		char(20)	OUTPUT,
@Periodo		int		OUTPUT,
@Ejercicio		int		OUTPUT,
@Ok			int		OUTPUT,
@GenerarGasto	bit		= 0	OUTPUT,
@SubClave		varchar(20)	= NULL  OUTPUT

AS BEGIN
DECLARE
@Requerido 		bit,
@UtilizarEste	bit,
@ConceptoMov	char(20),
@ConceptoOmision	varchar(50)
SELECT @Concepto  = NULLIF(RTRIM(@Concepto), '')
SELECT @MovTipo   = UPPER(Clave), @GenerarGasto = ISNULL(GenerarGasto, 0), @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
EXEC spPeriodoEjercicio @Empresa, @Modulo, @FechaAfectacion, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
BEGIN
SELECT @ConceptoMov = NULL
SELECT @ConceptoMov = Mov, @ConceptoOmision = NULLIF(RTRIM(Concepto), ''), @Requerido = Requerido, @UtilizarEste = UtilizarEste
FROM EmpresaConcepto
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov
IF @ConceptoMov IS NOT NULL
BEGIN
IF NULLIF(RTRIM(@Concepto), '') IS NULL AND @UtilizarEste = 1 SELECT @Concepto = @ConceptoOmision
IF @Requerido = 1 AND @Concepto IS NULL SELECT @Ok = 20480
END
END
RETURN
END

