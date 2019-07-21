SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSustentoComprobanteCerrarDia
(
@Fecha	 datetime,
@Ok		 int	      = NULL OUTPUT,
@OkRef	 varchar(255) = NULL OUTPUT
)

AS BEGIN
DECLARE
@SustentoComprobante	varchar(10),
@Concepto		varchar(50),
@Referencia		varchar(50)
EXEC spExtraerFecha @Fecha OUTPUT
UPDATE SustentoComprobante SET
Concepto     = scd.Concepto,
Referencia   = scd.Referencia,
VigenciaD    = scd.VigenciaD
FROM SustentoComprobante sc JOIN SustentoComprobanteD scd
ON sc.SustentoComprobante = scd.SustentoComprobante
WHERE scd.VigenciaD <= @Fecha
AND ISNULL(scd.TieneMovimientos,0) = 0
AND scd.VigenciaD = (SELECT MAX(SustentoComprobanteD.VigenciaD) FROM SustentoComprobanteD WHERE SustentoComprobante = sc.SustentoComprobante AND SustentoComprobanteD.VigenciaD <= @Fecha)
IF @@ERROR <> 0 SET @Ok = 1
END

