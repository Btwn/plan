SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovSituacionNueva
@Modulo				char(5),
@Mov				varchar(20),
@EstatusNuevo 		char(15),
@EstatusAnterior 	char(15),
@SituacionNueva 	varchar(50)	OUTPUT,
@ID					int			= NULL,
@Tipo				varchar(50)	= NULL

AS BEGIN
DECLARE @Flujo				varchar(20),
@MovSituacionBinaria	bit,
@Empresa				varchar(5),
@SQL					nvarchar(max),
@SituacionID			int
SELECT @SQL = 'SELECT @Empresa = Empresa FROM '+dbo.fnMovTabla(@Modulo)+' WHERE ID = @ID'
EXEC sp_executesql @SQL, N'@Empresa varchar(5) OUTPUT, @ID int', @Empresa OUTPUT, @ID
SELECT @Flujo = Flujo FROM MovSituacionL WHERE Mov = @Mov AND Modulo = @Modulo AND Estatus = @EstatusNuevo
SELECT @MovSituacionBinaria = ISNULL(MovSituacionBinaria, 0) FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @SituacionNueva = NULL, @Tipo = NULLIF(RTRIM(@Tipo), '')
IF (SELECT SituacionFinalAlRegresar FROM Version) = 1 AND dbo.fnMovEstatusValor(@EstatusNuevo) < dbo.fnMovEstatusValor(@EstatusAnterior)
BEGIN
IF @Tipo IS NULL
SELECT @SituacionNueva = Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND UPPER(Flujo) = 'FINAL'
ELSE
SELECT @SituacionNueva = Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND UPPER(Flujo) = 'FINAL' AND Tipo = @Tipo
END ELSE
BEGIN
IF @MovSituacionBinaria = 0  OR (@MovSituacionBinaria = 1 AND @Flujo = 'Normal')
BEGIN
IF @Tipo IS NULL
SELECT @SituacionNueva = Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND UPPER(Flujo) IN ('INICIAL TODAS', 'INICIAL ESPECIAL')
ELSE
SELECT @SituacionNueva = Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND UPPER(Flujo) IN ('INICIAL TODAS', 'INICIAL ESPECIAL') AND @Tipo = @Tipo
END
ELSE
BEGIN
SELECT @SituacionNueva = Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND ISNULL(EsPadre, 0) = 1 AND Situacion <> '.'
EXEC spMovSituacionBinariaSiguiente @@SPID, @Modulo, @ID, @Mov, @EstatusNuevo, @SituacionNueva, @SituacionNueva OUTPUT, @SituacionID OUTPUT
END
END
IF @ID IS NOT NULL
EXEC spMovSituacionNuevaAfectar @Modulo, @ID, @SituacionNueva
RETURN
END

