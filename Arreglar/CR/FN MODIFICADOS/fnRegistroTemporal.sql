SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRegistroTemporal (@Tabla varchar(100), @SucursalRemota int, @IDRemoto int, @SincroGUID uniqueidentifier)
RETURNS uniqueidentifier

AS BEGIN
RETURN(SELECT ISNULL(RegistroTemporal,@SincroGUID) FROM IDLocal WITH(NOLOCK) WHERE IDRemoto = @IDRemoto AND Tabla = @Tabla AND SucursalRemota = @SucursalRemota)
END

