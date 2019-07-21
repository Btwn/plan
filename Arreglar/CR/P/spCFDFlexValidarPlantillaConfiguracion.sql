SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexValidarPlantillaConfiguracion
(
@Comprobante		varchar(50),
@Modulo			char(5),
@CFDI				bit,
@Ok				int OUTPUT,
@OkRef			varchar(255) OUTPUT
)

AS
BEGIN
DECLARE
@TipoCFDI		float
SELECT @TipoCFDI = ISNULL(TipoCFDI,0) FROM eDoc WHERE eDoc = @Comprobante AND Modulo = @Modulo
IF @CFDI <> @TipoCFDI
SELECT @Ok = 71685, @OkRef = @Comprobante
END

