SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
			FROM Empresa
			WHERE Empresa = @Empresa
		)
		= 1)
		OR ((
			SELECT CFDFlex
			FROM EmpresaGral
			WHERE Empresa = @Empresa
		)
		= 1 AND (
			SELECT eDoc
			FROM EmpresaGral
			WHERE Empresa = @Empresa
		)
		= 1)
	BEGIN
		SELECT @CFD =
		 CASE
			 WHEN (
					 SELECT ISNULL(CFD, 0)
					 FROM MovTipo
					 WHERE Modulo = @Modulo
					 AND Mov = @Mov
				 )
				 = 1
				 OR (
					 SELECT ISNULL(CFDFlex, 0)
					 FROM MovTipo
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
					 FROM MovTipo
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