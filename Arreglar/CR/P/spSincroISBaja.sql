SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISBaja
@Tabla			varchar(100),
@Llave			xml

AS BEGIN
IF @Tabla IS NOT NULL AND @Llave IS NOT NULL
INSERT SincroISBaja (Tabla, Llave) VALUES (@Tabla, @Llave)
RETURN
END

