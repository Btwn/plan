SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spRegenerarCFDFlex
@Estacion		int,
@Empresa		varchar(5),
@Modulo			varchar(5),
@ID				int,
@Estatus		varchar(15),
@Ok				int				= NULL OUTPUT,
@OkRef			varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE
@OkDesc           	varchar(255),
@OkTipo           	varchar(50)
EXEC spCFDFlex @Estacion, @Empresa, @Modulo, @ID, @Estatus, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

