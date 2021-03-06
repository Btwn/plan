SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSHost
@Host		varchar(20)	OUTPUT,
@Cluster		varchar(20)	OUTPUT

AS
BEGIN
SELECT TOP 1 @Host = Host,
@Cluster = Cluster
FROM POSiSync WITH (NOLOCK)
RETURN
END

