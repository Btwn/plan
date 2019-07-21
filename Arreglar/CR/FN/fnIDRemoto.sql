SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnIDRemoto (@Tabla varchar(100), @SucursalLocal int, @IDLocal int)
RETURNS int

AS BEGIN
RETURN(SELECT IDRemoto FROM IDLocal WHERE Tabla = @Tabla AND SucursalLocal = @SucursalLocal AND IDLocal = @IDLocal)
END

