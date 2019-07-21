SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoComprobanteCerrarDia
(
@Fecha	 datetime,
@Ok		 int	      = NULL OUTPUT,
@OkRef	 varchar(255) = NULL OUTPUT
)

AS BEGIN
DECLARE
@TipoComprobante	varchar(10),
@Concepto		varchar(50),
@Referencia		varchar(50)
EXEC spExtraerFecha @Fecha OUTPUT
UPDATE TipoComprobante SET
Concepto     = tcd.Concepto,
Referencia   = tcd.Referencia,
VigenciaD    = tcd.VigenciaD
FROM TipoComprobante tc JOIN TipoComprobanteD tcd
ON tc.TipoComprobante = tcd.TipoComprobante
WHERE tcd.VigenciaD <= @Fecha
AND ISNULL(tcd.TieneMovimientos,0) = 0
AND tcd.VigenciaD = (SELECT MAX(TipoComprobanteD.VigenciaD) FROM TipoComprobanteD WHERE TipoComprobante = tc.TipoComprobante AND TipoComprobanteD.VigenciaD <= @Fecha)
IF @@ERROR <> 0 SET @Ok = 1
END

