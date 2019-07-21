SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINXMLValido
@XML		    varchar(max),
@Existe             bit = 0 OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
EXEC xpeDocINXMLValido @XML, @Existe OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
RETURN
END

