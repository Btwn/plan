USE [IntelisisTmp]
GO
/****** Object:  StoredProcedure [dbo].[spBloquearUsuario]    Script Date: 28/06/2019 04:56:02 p. m. ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spBloquearUsuario]
@Usuario	varchar(10)
 
AS BEGIN
DECLARE
@Estatus	varchar(15)
SELECT @Estatus = UPPER(Estatus) FROM Usuario WHERE Usuario = @Usuario
--IF @Estatus = 'ALTA'
--UPDATE Usuario SET Estatus = 'BLOQUEADO' WHERE Usuario = @Usuario
RETURN
END
