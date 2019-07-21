SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spBloquearUsuario]
@Usuario	varchar(10)
 
AS BEGIN
DECLARE
@Estatus	varchar(15)
SELECT @Estatus = UPPER(Estatus) FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
--IF @Estatus = 'ALTA'
--UPDATE Usuario SET Estatus = 'BLOQUEADO' WHERE Usuario = @Usuario
RETURN
END

