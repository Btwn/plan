SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLinkedServers

AS BEGIN
DECLARE @Tabla TABLE (
Servidor		varchar(100),
Proveedor		varchar(100),
Producto		varchar(100),
DataSource		varchar(100),
ProvString		varchar(100),
Locaton			varchar(100),
Cat				varchar(100)
)
INSERT INTO @Tabla
EXEC sp_linkedservers
SELECT Servidor FROM @Tabla
END

