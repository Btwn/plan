SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAccesoID (@SPID int)
RETURNS varchar(10)

AS BEGIN
DECLARE
@ID	int
SELECT @ID = MAX(ID)
FROM Acceso WITH (NOLOCK)
WHERE SPID = @SPID AND FechaSalida IS NULL
RETURN @ID
END

