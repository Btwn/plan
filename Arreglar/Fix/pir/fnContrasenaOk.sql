USE [IntelisisTmp]
GO
/****** Object:  UserDefinedFunction [dbo].[fnContrasenaOk]    Script Date: 11/06/2019 02:28:47 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[fnContrasenaOk] (@Contrasena varchar(32), @Encriptada varchar(32))
RETURNS bit
--WITH ENCRYPTION
AS BEGIN
DECLARE
@Resultado bit
SELECT @Resultado = 0
IF @Contrasena = @Encriptada
SELECT @Resultado = 1
RETURN(@Resultado)
END


