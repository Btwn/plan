SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spIntelisisServiceEmida
@ID					int,
@iSolicitud			int,
@Referencia			varchar(100),
@SubReferencia		varchar(100),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@CambiarEstatus		bit = 1			OUTPUT

AS
BEGIN
DECLARE @Empresa varchar(5) 
IF @Referencia = 'Emida.ActualizarCatalogo' EXEC spISEmidaActualizarCatalogo @ID, @iSolicitud, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT ELSE
IF @Referencia = 'Emida.AccountBalance' EXEC spISEmidaAccountBalance @ID, @iSolicitud, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT ELSE
IF @Referencia = 'Emida.RecargaTelefonica' EXEC spISEmidaRecargaTelefonica @ID, @iSolicitud, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT, @Empresa OUTPUT /* REQ13868 */ ELSE
IF @Referencia = 'Emida.LookupTransaction' EXEC spISEmidaLookupTransaction @ID, @iSolicitud, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT, @Empresa OUTPUT /* REQ13868 */ ELSE
IF @Referencia = 'Emida.SubmitPayment' EXEC spISEmidaSubmitPayment @ID, @iSolicitud, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT
IF @Referencia IN('Emida.RecargaTelefonica') 
EXEC spISEmidaRegistraLog @ID, @Empresa, @iSolicitud, @Resultado
RETURN
END

