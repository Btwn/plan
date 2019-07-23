SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpMovTipoCFD]
 @Empresa VARCHAR(5)
,@Modulo VARCHAR(5)
,@Mov VARCHAR(20)
,@CFD BIT OUTPUT
,@CFDFlex BIT = NULL OUTPUT
AS
BEGIN
	SELECT @CFD = 0

	IF ((
			SELECT CFD
			FROM Empresa WITH(NOLOCK)
			WHERE Empresa = @Empresa
		)
		= 1)
		OR ((
			SELECT CFDFlex
			FROM EmpresaGral WITH(NOLOCK)
			WHERE Empresa = @Empresa
		)
		= 1 AND (
			SELECT eDoc
			FROM EmpresaGral WITH(NOLOCK)
			WHERE Empresa = @Empresa
		)
		= 1)
	BEGIN
		SELECT @CFD =
		 CASE
			 WHEN (
					 SELECT ISNULL(CFD, 0)
					 FROM MovTipo WITH(NOLOCK)
					 WHERE Modulo = @Modulo
					 AND Mov = @Mov
				 )
				 = 1
				 OR (
					 SELECT ISNULL(CFDFlex, 0)
					 FROM MovTipo WITH(NOLOCK)
					 WHERE Modulo = @Modulo
					 AND Mov = @Mov
				 )
				 = 1 THEN 1
			 ELSE 0
		 END
		SELECT @CFDFlex =
		 CASE
			 WHEN (
					 SELECT ISNULL(CFDFlex, 0)
					 FROM MovTipo WITH(NOLOCK)
					 WHERE Modulo = @Modulo
					 AND Mov = @Mov
				 )
				 = 1 THEN 1
			 ELSE 0
		 END
	END

	RETURN
END
GO