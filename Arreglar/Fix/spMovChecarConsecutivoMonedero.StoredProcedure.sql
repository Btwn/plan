USE [IntelisisTmp]
GO
/****** Object:  StoredProcedure [dbo].[spMovChecarConsecutivoMonedero]    Script Date: 26/06/2019 07:23:31 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spMovChecarConsecutivoMonedero]
 @Empresa VARCHAR(5)
,@Modulo VARCHAR(5)
,@Mov VARCHAR(20)
,@MovID VARCHAR(20)
,@Ejercicio INT
,@Periodo INT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@YaExiste INT
	SELECT @YaExiste = NULL
	SELECT @YaExiste = COUNT(*)
	FROM MonederoMAVI
	WHERE Empresa = @Empresa
	AND Mov = @Mov
	AND MovID = @MovID
	AND Estatus NOT IN ('SINAFECTAR')

	IF ISNULL(@YaExiste, 0) > 0
		SELECT @Ok = 30010
			  ,@OkRef = RTRIM(@Mov) + ' ' + RTRIM(@MovID) + ' (' + RTRIM(@Modulo) + ')'

	RETURN
END
