SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVerMovTipoCFD]
 @Empresa VARCHAR(5)
,@Modulo VARCHAR(5)
,@Mov VARCHAR(20)
,@ID INT = NULL
AS
BEGIN
	DECLARE
		@CFD BIT
	   ,@Timbrado BIT
	   ,@VersionCFD VARCHAR(10)
	   ,@UUID VARCHAR(50)
	   ,@SelloSAT VARCHAR(MAX)
	   ,@TFDCadenaOriginal VARCHAR(MAX)
	   ,@Sello VARCHAR(MAX)
	   ,@CFDI BIT
	   ,@Estatus VARCHAR(20)
		 ,@CFDFlex BIT
	EXEC spMovInfo @ID = @ID OUTPUT
				  ,@Modulo = @Modulo
				  ,@Estatus = @Estatus OUTPUT
	SELECT @CFD = 0
			,@CFDFlex = 0
	EXEC spMovTipoCFD @Empresa
					 ,@Modulo
					 ,@Mov
					 ,@CFD OUTPUT
					 ,@CFDFlex OUTPUT
	SELECT @CFDI = CFDI
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @CFD = 1
		AND @Estatus <> 'CANCELADO'
	BEGIN

		IF EXISTS (SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID)
		BEGIN
			SELECT @VersionCFD = SUBSTRING(CadenaOriginal, 3, 3)
				  ,@Timbrado = Timbrado
				  ,@UUID = UUID
				  ,@SelloSAT = SelloSAT
				  ,@TFDCadenaOriginal = TFDCadenaOriginal
				  ,@Sello = Sello
			FROM CFD
			WHERE Modulo = @Modulo
			AND ModuloID = @ID

			IF NULLIF(@VersionCFD, '') IS NULL
				OR ISNUMERIC(@VersionCFD) = 0
				SELECT @VersionCFD = Version
				FROM EmpresaCFD
				WHERE Empresa = @Empresa

			IF @VersionCFD >= '3.2'
				OR @CFDI = 1
			BEGIN

				IF @UUID IS NOT NULL
					OR @SelloSAT IS NOT NULL
					SELECT @CFD = 0

			END
			ELSE

			IF NULLIF(@Sello, '') IS NOT NULL
				SELECT @CFD = 0

		END

		IF @VersionCFD >= '3.2'
			OR @CFDI = 1
		BEGIN

			IF EXISTS (SELECT * FROM MovTipo mt JOIN MovFlujo mf ON mf.OModulo = mt.Modulo AND mf.OMov = mt.Mov JOIN CFD cfd ON cfd.Modulo = mt.Modulo AND ModuloID = mf.OID AND (NULLIF(cfd.SelloSAT, '') IS NOT NULL OR cfd.Timbrado = 1 OR cfd.UUID IS NOT NULL) WHERE mt.ConsecutivoModulo = @Modulo AND mt.ConsecutivoMov = @Mov AND mt.Modulo != @Modulo AND mt.Mov != @Mov AND mf.DID = @ID AND mf.DModulo = @Modulo)
				SELECT @CFD = 0

		END
		ELSE
		BEGIN

			IF EXISTS (SELECT * FROM MovTipo mt JOIN MovFlujo mf ON mf.OModulo = mt.Modulo AND mf.OMov = mt.Mov JOIN CFD cfd ON cfd.Modulo = mt.Modulo AND ModuloID = mf.OID AND NULLIF(cfd.Sello, '') IS NOT NULL WHERE mt.ConsecutivoModulo = @Modulo AND mt.ConsecutivoMov = @Mov AND mt.Modulo != @Modulo AND mt.Mov != @Mov AND mf.DID = @ID AND mf.DModulo = @Modulo)
				SELECT @CFD = 0

		END

	END

	SELECT 'CFD' = @CFD
			--,'CFDFlex' = @CFDFlex
	RETURN
END

