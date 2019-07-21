SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilLoginListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario	varchar(10),
@HardwareID	varchar(32),
@Firma		varchar(20)
SELECT
@Usuario	   = Usuario,
@HardwareID    = HardwareID
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10), HardwareID varchar(32))
SET @Firma = 'XXXXXXXXXXXXXXX'
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT	@Firma Firma,
M.Agente,
u.Nombre,
M.ContrasenaCorta ContrasenaCorta
FROM	Usuario U
JOIN	MovilUsuarioCfg M ON U.Usuario = M.Usuario
WHERE	U.Usuario = @Usuario
) AS MovilLoginListado FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok)
END

