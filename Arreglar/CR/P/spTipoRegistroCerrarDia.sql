SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoRegistroCerrarDia
(
@Fecha	 datetime,
@Ok		 int	      = NULL OUTPUT,
@OkRef	 varchar(255) = NULL OUTPUT
)

AS BEGIN
DECLARE
@TipoRegistro		varchar(10),
@Concepto		varchar(50),
@Referencia		varchar(50)
EXEC spExtraerFecha @Fecha OUTPUT
UPDATE TipoRegistro SET
Concepto     = trd.Concepto,
Referencia   = trd.Referencia,
VigenciaD    = trd.VigenciaD
FROM TipoRegistro tr JOIN TipoRegistroD trd
ON tr.TipoRegistro = trd.TipoRegistro
WHERE trd.VigenciaD <= @Fecha
AND ISNULL(trd.TieneMovimientos,0) = 0
AND trd.VigenciaD = (SELECT MAX(TipoRegistroD.VigenciaD) FROM TipoRegistroD WHERE TipoRegistro = tr.TipoRegistro AND TipoRegistroD.VigenciaD <= @Fecha)
IF @@ERROR <> 0 SET @Ok = 1
END

