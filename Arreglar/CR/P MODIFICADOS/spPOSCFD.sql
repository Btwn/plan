SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCFD
@ID			varchar(36),
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT

AS
BEGIN
DECLARE
@IDGenerar			int,
@Calcular			bit,
@Encripcion			varchar(20),
@XMLFinal			varchar(max),
@CadenaOriginal		varchar(MAX),
@Certificado		varchar(20),
@Sello				varchar(255),
@DocumentoXML		varchar(MAX),
@OkDesc				varchar(255)
END

