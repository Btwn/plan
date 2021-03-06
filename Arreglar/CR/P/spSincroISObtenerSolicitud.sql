SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISObtenerSolicitud
@iDatos				int,
@Solicitud			uniqueidentifier OUTPUT

AS BEGIN
SELECT @Solicitud = Solicitud
FROM OPENXML (@iDatos, '/Intelisis/Solicitud/IntelisisSincroIS')
WITH (Solicitud uniqueidentifier)
END

